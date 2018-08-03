part of queries;

abstract class IGrouping<TKey, TElement> implements IEnumerable<TElement> {
  TKey get key;
}

class _Grouping<TKey, TElement> extends Object
    with Enumerable<TElement>
    implements IGrouping<TKey, TElement> {
  IEnumerable<TElement> _elements;

  TKey _key;

  _Grouping(TKey key, this._elements) {
    _key = key;
  }

  Iterator<TElement> get iterator {
    return _elements.iterator;
  }

  TKey get key => _key;
}
