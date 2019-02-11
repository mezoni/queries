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
    return _orderAll().iterator;
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

  List<List<TElement>> _order(List<List<TElement>> data, bool lastLevel) {
    var result = <List<TElement>>[];
    Comparator<TElement> comparator;
    if (_descending) {
      comparator = (TElement x, TElement y) =>
          -_comparer.compare(_keySelector(x), _keySelector(y));
    } else {
      comparator = (TElement x, TElement y) =>
          _comparer.compare(_keySelector(x), _keySelector(y));
    }

    var sorter = new _SymmergeSorter<TElement>(comparator);
    var numberOfParts = data.length;
    for (var i = 0; i < numberOfParts; i++) {
      var elements = data[i];
      sorter.sort(elements);
      if (lastLevel) {
        result.add(elements);
        continue;
      }

      var numberOfElements = elements.length;
      if (numberOfElements == 1) {
        result.add([elements[0]]);
        continue;
      }

      var previous = elements[0];
      var newElements = [previous];
      result.add(newElements);
      for (var j = 1; j < numberOfElements; j++) {
        var element = elements[j];
        if (comparator(element, previous) != 0) {
          newElements = <TElement>[];
          result.add(newElements);
        }

        newElements.add(element);
        previous = element;
      }
    }

    return result;
  }

  Iterable<TElement> _orderAll() sync* {
    var source = _source.toList();
    if (source.length == 0) {
      return;
    }

    var data = <List<TElement>>[];
    data.add(source);
    var queue = <_OrderedEnumerable<TElement, Object>>[];
    _OrderedEnumerable<TElement, Object> sequence = this;
    while (sequence != null) {
      queue.add(sequence);
      sequence = sequence._parent;
    }

    for (var i = queue.length - 1; i >= 0; i--) {
      var sequence = queue[i];
      data = sequence._order(data, i == 0);
    }

    var numberOfParts = data.length;
    for (var i = 0; i < numberOfParts; i++) {
      var elements = data[i];
      var numberOfElements = elements.length;
      for (var j = 0; j < numberOfElements; j++) {
        yield elements[j];
      }
    }
  }
}
