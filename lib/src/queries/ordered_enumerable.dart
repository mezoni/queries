part of queries;

abstract class IOrderedEnumerable<TElement> implements IEnumerable<TElement> {
  IOrderedEnumerable<TElement> createOrderedEnumerable<TKey>(
      Func1<TElement, TKey> keySelector,
      IComparer<TKey> comparer,
      bool descending);

  IOrderedEnumerable<TElement> thenBy<TKey>(Func1<TElement, TKey> keySelector,
      [IComparer<TKey> comparer]);

  IOrderedEnumerable<TElement> thenByDescending<TKey>(
      Func1<TElement, TKey> keySelector,
      [IComparer<TKey> comparer]);
}

class _OrderedEnumerable<TElement, TKey> extends Object
    with Enumerable<TElement>
    implements IOrderedEnumerable<TElement> {
  IComparer<TKey> _comparer;

  bool _descending;

  Func1<TElement, TKey> _keySelector;

  _OrderedEnumerable<TElement, Object> _parent;

  IEnumerable<TElement> _source;

  _OrderedEnumerable(
      IEnumerable<TElement> source,
      Func1<TElement, TKey> keySelector,
      IComparer<TKey> comparer,
      bool descending,
      this._parent) {
    if (source == null) {
      throw new ArgumentError.notNull("source");
    }

    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    if (descending == null) {
      throw new ArgumentError.notNull("descending");
    }

    if (comparer == null) {
      comparer = Comparer.getDefault<TKey>();
    }

    _comparer = comparer;
    _descending = descending;
    _keySelector = keySelector;
    _source = source;
  }

  Iterator<TElement> get iterator {
    if (_parent == null) {
      return _orderBy().iterator;
    } else {
      return _thenBy().iterator;
    }
  }

  IOrderedEnumerable<TElement> createOrderedEnumerable<TKey>(
      Func1<TElement, TKey> keySelector,
      IComparer<TKey> comparer,
      bool descending) {
    return new _OrderedEnumerable<TElement, TKey>(
        this, keySelector, comparer, descending, this);
  }

  IOrderedEnumerable<TElement> thenBy<TKey>(Func1<TElement, TKey> keySelector,
      [IComparer<TKey> comparer]) {
    return createOrderedEnumerable<TKey>(keySelector, comparer, false);
  }

  IOrderedEnumerable<TElement> thenByDescending<TKey>(
      Func1<TElement, TKey> keySelector,
      [IComparer<TKey> comparer]) {
    return createOrderedEnumerable<TKey>(keySelector, comparer, true);
  }

  Iterable<TElement> _orderBy() sync* {
    Comparator<TElement> comparator;
    if (_descending) {
      comparator = (TElement x, TElement y) =>
          -_comparer.compare(_keySelector(x), _keySelector(y));
    } else {
      comparator = (TElement x, TElement y) =>
          _comparer.compare(_keySelector(x), _keySelector(y));
    }

    var sorter = new _SymmergeSorter<TElement>(comparator);
    var result = _source.toList();
    sorter.sort(result);
    for (var element in result) {
      yield element;
    }
  }

  Iterable<TElement> _thenBy() sync* {
    var result = new List<TElement>();
    var it = _source.iterator;
    if (it.moveNext()) {
      Comparator<TElement> currComparator;
      TElement current;
      var group = new List<TElement>();
      var hasCurrent = false;
      var length = 1;
      Comparator<TElement> prevComparator;
      var previous = it.current;
      var prevKeySelector = _parent._keySelector;
      if (_descending) {
        currComparator = (TElement x, TElement y) =>
            -_comparer.compare(_keySelector(x), _keySelector(y));
        prevComparator = (TElement x, TElement y) =>
            -_parent._comparer.compare(prevKeySelector(x), prevKeySelector(y));
      } else {
        currComparator = (TElement x, TElement y) =>
            _comparer.compare(_keySelector(x), _keySelector(y));
        prevComparator = (TElement x, TElement y) =>
            _parent._comparer.compare(prevKeySelector(x), prevKeySelector(y));
      }

      var sorter = new _SymmergeSorter<TElement>(currComparator);
      group.add(previous);
      while (true) {
        while (it.moveNext()) {
          current = it.current;
          if (prevComparator(previous, current) == 0) {
            group.add(current);
            previous = current;
            length++;
          } else {
            hasCurrent = true;
            break;
          }
        }

        if (length != 0) {
          switch (length) {
            case 1:
              break;
            case 2:
              if (currComparator(group[0], group[1]) > 0) {
                var swap = group[0];
                group[0] = group[1];
                group[1] = swap;
              }

              break;
            default:
              sorter.sort(group);
          }

          result.addAll(group);
          if (!hasCurrent) {
            break;
          }

          group = <TElement>[];
          hasCurrent = false;
          length = 1;
          group.add(current);
          previous = current;
        } else {
          break;
        }
      }
    }

    var l = result.length;
    for (var i = 0; i < l; i++) {
      yield result[i];
    }
  }
}
