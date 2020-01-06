part of queries;

abstract class IGrouping<TKey, TElement> implements IEnumerable<TElement> {
  TKey get key;
}

class _Grouping<TKey, TElement> extends Object
    with Enumerable<TElement>
    implements IGrouping<TKey, TElement> {
  final IEnumerable<TElement> _elements;

  TKey _key;

  _Grouping(TKey key, this._elements) {
    _key = key;
  }

  @override
  Iterator<TElement> get iterator {
    return _elements.iterator;
  }

  @override
  TKey get key => _key;
}
