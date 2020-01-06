part of queries;

abstract class ILookup<TKey, TElement>
    implements IEnumerable<IGrouping<TKey, TElement>> {
  int get length;

  IEnumerable<TElement> operator [](TKey key);

  bool containsKey(TKey key);
}

class Lookup<TKey, TElement> extends Object
    with Enumerable<IGrouping<TKey, TElement>>
    implements ILookup<TKey, TElement> {
  IGrouping<TKey, TElement> _current;

  final Dictionary<TKey, IGrouping<TKey, TElement>> _groupings;

  Lookup._internal(this._groupings);

  IGrouping<TKey, TElement> get current {
    return _current;
  }

  @override
  Iterator<IGrouping<TKey, TElement>> get iterator {
    return _groupings.values.iterator;
  }

  @override
  int get length {
    return _groupings.length;
  }

  @override
  IEnumerable<TElement> operator [](TKey key) {
    var grouping = _groupings[key];
    if (grouping != null) {
      return grouping;
    }

    return _Enumerable<TElement>(<TElement>[]);
  }

  IEnumerable<TResult> applyResultSelector<TResult>(
      TResult Function(TKey key, IEnumerable<TElement> elements)
          resultSelector) {
    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
    }

    return select<TResult>((g) => resultSelector(g.key, g));
  }

  @override
  bool containsKey(TKey key) {
    return _groupings.containsKey(key);
  }
}
