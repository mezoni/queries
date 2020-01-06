part of queries.collections;

abstract class IReadOnlyCollection<TElement> implements IEnumerable<TElement> {
  int get length;
}

class ReadOnlyCollection<TElement> extends _Collection<TElement>
    with Enumerable<TElement> {
  ReadOnlyCollection(List<TElement> items) {
    if (items == null) {
      throw ArgumentError.notNull('items');
    }

    _items = items;
  }

  @override
  bool get isReadOnly {
    return true;
  }

  @override
  List<TElement> get items {
    throw UnsupportedError('items()');
  }

  @override
  void operator []=(int index, TElement item) {
    throw UnsupportedError('operator []=');
  }

  @override
  void add(TElement element) {
    throw UnsupportedError('add()');
  }

  @override
  void clear() {
    throw UnsupportedError('clear()');
  }

  @override
  void insert(int index, TElement item) {
    throw UnsupportedError('insert()');
  }

  @override
  bool remove(TElement item) {
    throw UnsupportedError('remove()');
  }

  @override
  TElement removeAt(int index) {
    throw UnsupportedError('removeAt()');
  }
}
