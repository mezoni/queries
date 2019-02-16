part of queries.collections;

abstract class IReadOnlyCollection<TElement> implements IEnumerable<TElement> {
  int get length;
}

class ReadOnlyCollection<TElement> extends _Collection<TElement>
    with Enumerable<TElement> {
  ReadOnlyCollection(List<TElement> items) {
    if (items == null) {
      throw ArgumentError.notNull("items");
    }

    _items = items;
  }

  bool get isReadOnly {
    return true;
  }

  List<TElement> get items {
    throw UnsupportedError("items()");
  }

  void operator []=(int index, TElement item) {
    throw UnsupportedError("operator []=");
  }

  void add(TElement element) {
    throw UnsupportedError("add()");
  }

  void clear() {
    throw UnsupportedError("clear()");
  }

  void insert(int index, TElement item) {
    throw UnsupportedError("insert()");
  }

  bool remove(TElement item) {
    throw UnsupportedError("remove()");
  }

  TElement removeAt(int index) {
    throw UnsupportedError("removeAt()");
  }
}
