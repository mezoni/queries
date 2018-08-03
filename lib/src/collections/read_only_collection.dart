part of queries.collections;

abstract class IReadOnlyCollection<TElement> implements IEnumerable<TElement> {
  int get length;
}

class ReadOnlyCollection<TElement> extends _Collection<TElement>
    with Enumerable<TElement> {
  ReadOnlyCollection(List<TElement> items) {
    if (items == null) {
      throw new ArgumentError("items: $items");
    }

    _items = items;
  }

  bool get isReadOnly {
    return true;
  }

  List<TElement> get items {
    throw new UnsupportedError("items()");
  }

  void operator []=(int index, TElement item) {
    throw new UnsupportedError("operator []=");
  }

  void add(TElement element) {
    throw new UnsupportedError("add()");
  }

  void clear() {
    throw new UnsupportedError("clear()");
  }

  void insert(int index, TElement item) {
    throw new UnsupportedError("insert()");
  }

  bool remove(TElement item) {
    throw new UnsupportedError("remove()");
  }

  TElement removeAt(int index) {
    throw new UnsupportedError("removeAt()");
  }
}
