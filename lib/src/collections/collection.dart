part of queries.collections;

/// The [Collection] class is a wrapper for a [List].
class Collection<TElement> extends Object
    with _Collection<TElement>, Enumerable<TElement> {
  /// Constructs the collection for specified list of items.
  ///
  /// Parameters.
  ///  [List]<[TElement]> items
  ///
  /// Exceptions:
  Collection([List<TElement> items]) {
    if (items == null) {
      items = <TElement>[];
    }

    _items = items;
  }
}

abstract class ICollection<TElement> implements IEnumerable<TElement> {
  /// Returns [:true:] if collection is read only; otherwise, [:false:].
  bool get isReadOnly;

  /// Returns the size of collection.
  int get length;

  /// Adds the item to collection.
  ///
  /// Parameters:
  ///  [TElement] item
  ///  Item to add to the collection.
  ///
  /// Exeptions:
  void add(TElement item);

  /// Clears the collection.
  ///
  /// Parameters:
  ///
  /// Exceptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  void clear();

  /// Returns [:true:] if collection contains the value; otherwise, [:false:]
  ///
  /// Parameters:
  ///  [TElement] value
  ///  Value for search in collection.
  ///
  /// Exceptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  bool containsValue(TElement value);

  /// Copies the collection to list starting at the specified index.
  ///
  /// Parameters:
  ///  [List]<[TElement]> list
  ///  List into which will be copied the collection.
  ///
  ///  [int] index
  ///  Start index of collection.
  ///
  /// Exceptions:
  ///  [ArgumentError]
  ///  [list] is [:null:]
  ///
  ///  [ArgumentError]
  ///  [index] is [:null:]
  ///
  ///  [RangeError]
  ///  [index] out of range
  ///   OR
  ///  Insufficient size of the [list]
  void copyTo(List<TElement> list, int index);

  /// Removes the item from collection and returns [:true:] if item  has been
  /// removed; otherwise, [:false:].
  ///
  /// Parameters:
  ///  [TElement] item
  ///  Item to remove from the collection.
  ///
  /// Exeptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  bool remove(TElement item);
}

abstract class _Collection<TElement>
    implements
        ICollection<TElement>,
        IList<TElement>,
        IReadOnlyCollection<TElement>,
        IReadOnlyList<TElement> {
  List<TElement> _items;

  /// Returns [:true:] if collection is read only; otherwise, [:false:].
  bool get isReadOnly {
    return false;
  }

  /// Returns the wrapped list of collection.
  List<TElement> get items {
    if (isReadOnly) {
      throw UnsupportedError("items");
    }

    return _items;
  }

  /// Returns iterator of collection.
  Iterator<TElement> get iterator {
    return _items.iterator;
  }

  /// Returns the size of collection.
  int get length {
    return _items.length;
  }

  /// Returns the item at specified index.
  ///
  /// Parameters:
  ///  [int] index
  ///  Index of item.
  ///
  /// Exceptions:
  ///  [ArgumentError]
  ///  [index] is [:null:]
  ///
  ///  [RangeError]
  ///  [index] is out of range
  TElement operator [](int index) {
    return _items[index];
  }

  /// Sets the item at specified index.
  ///
  /// Parameters:
  ///  [int] index
  ///  Index of item.
  ///
  ///  [TElement] item
  ///  Item to set in collection.
  ///
  /// Exceptions:
  ///  [UnsupportedError]
  ///   Collection is readonly.
  ///
  ///  [ArgumentError]
  ///  [index] is [:null:]
  ///
  ///  [RangeError]
  ///  [index] is out of range
  void operator []=(int index, TElement item) {
    if (isReadOnly) {
      throw UnsupportedError("items=");
    }

    _items[index] = item;
  }

  /// Adds the item to collection.
  ///
  /// Parameters:
  ///  [TElement] item
  ///  Item to add to the collection.
  ///
  /// Exeptions:
  void add(TElement element) {
    if (isReadOnly) {
      throw UnsupportedError("add()");
    }

    _items.add(element);
  }

  /// Clears the collection.
  ///
  /// Parameters:
  ///
  /// Exceptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  void clear() {
    if (isReadOnly) {
      throw UnsupportedError("clear()");
    }

    _items.clear();
  }

  /// Returns [:true:] if collection contains the value; otherwise, [:false:]
  ///
  /// Parameters:
  /// [TElement] value
  /// Value for search in collection.
  ///
  /// Exceptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  bool containsValue(TElement item) {
    return _items.contains(item);
  }

  /// Copies the collection to list starting at the specified index.
  ///
  /// Parameters:
  ///  [List]<[TElement]> list
  ///  List into which will be copied the collection.
  ///
  ///  [int] index
  ///  Start index of collection.
  ///
  /// Exceptions:
  ///  [ArgumentError]
  ///  [list] is [:null:]
  ///
  ///  [ArgumentError]
  ///  [index] is [:null:]
  ///
  ///  [RangeError]
  ///  [index] out of range
  ///   OR
  ///  Insufficient size of the [list]
  void copyTo(List<TElement> list, int index) {
    if (list == null) {
      throw ArgumentError.notNull("list");
    }

    if (index == null) {
      throw ArgumentError.notNull("index");
    }

    var length = this.length;
    var rest = length - index;
    if (index < 0 || rest <= 0) {
      throw RangeError("index: $index");
    }

    var end = index + rest;
    for (var i = index; i < end; i++) {
      list[i] = _items[i];
    }
  }

  /// Returns the index of specified item if collection contains this item;
  /// otherwise, -1.
  ///
  /// Parameters:
  ///  [TElement] item
  ///  Item for search in collection.
  ///
  ///  [int] start
  ///  Start index.
  ///
  /// Exceptions:
  ///  TODO: Exceptions in Dart undocumented
  int indexOf(TElement item, [int start = 0]) {
    return _items.indexOf(item, start);
  }

  /// Inserts the item in collection.
  ///
  /// Parameters:
  ///  [int] index
  ///  Index of item.
  ///
  ///  [TElement] item
  ///  Item to insert in collection.
  ///
  /// Exeptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  ///
  ///  TODO: Exceptions in Dart undocumented
  void insert(int index, TElement item) {
    if (isReadOnly) {
      throw UnsupportedError("insert()");
    }

    _items.insert(index, item);
  }

  /// Removes the item from collection and returns [:true:] if item  has been
  /// removed; otherwise, [:false:].
  ///
  /// Parameters:
  ///  [TElement] item
  ///  Item to remove from the collection.
  ///
  /// Exeptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  bool remove(TElement item) {
    if (isReadOnly) {
      throw UnsupportedError("remove()");
    }

    return _items.remove(item);
  }

  /// Removes the item at specified index and returns this item.
  ///
  /// Parameters:
  ///  [int] index
  ///  Index that specifies removed item.
  ///
  /// Exceptions:
  ///  [UnsupportedError]
  ///  Collection is readonly.
  ///
  ///  [ArgumentError]
  ///  [index] is [:null:]
  ///
  ///  [RangeError]
  ///  [index] out of range
  TElement removeAt(int index) {
    if (isReadOnly) {
      throw UnsupportedError("removeAt()");
    }

    return _items.removeAt(index);
  }

  /// Converts collection to string and returns the result.
  ///
  /// Parameters:
  ///
  /// Exceptions:
  String toString() {
    return _items.toString();
  }
}
