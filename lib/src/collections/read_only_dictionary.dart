part of queries.collections;

abstract class IReadOnlyDictionary<TKey, TValue>
    implements
        IReadOnlyCollection<KeyValuePair<TKey, TValue>>,
        IEnumerable<KeyValuePair<TKey, TValue>> {
  IEqualityComparer<TKey> get comparer;

  IEnumerable<TKey> get keys;

  IEnumerable<TValue> get values;

  TValue operator [](TKey key);

  bool containsKey(TKey key);

  Map<TKey, TValue> toMap();
}

class ReadOnlyDictionary<TKey, TValue> extends _ReadOnlyDictionary<TKey, TValue>
    with Enumerable<KeyValuePair<TKey, TValue>> {
  ReadOnlyDictionary(IDictionary<TKey, TValue> dictionary) {
    if (dictionary == null) {
      throw ArgumentError.notNull('dictionary');
    }

    _dictionary = dictionary;
  }

  @override
  ReadOnlyDictionaryKeyCollection<TKey, TValue> get keys {
    return ReadOnlyDictionaryKeyCollection<TKey, TValue>._internal(this);
  }

  @override
  ReadOnlyDictionaryValueCollection<TKey, TValue> get values {
    return ReadOnlyDictionaryValueCollection<TKey, TValue>._internal(this);
  }
}

class ReadOnlyDictionaryKeyCollection<TKey, TValue> extends Object
    with Enumerable<TKey>
    implements ICollection<TKey> {
  // ReadOnlyDictionary<TKey, TValue> _dictionary;

  ICollection<TKey> _items;

  ReadOnlyDictionaryKeyCollection._internal(
      ReadOnlyDictionary<TKey, TValue> dictionary) {
    if (dictionary == null) {
      throw ArgumentError.notNull('dictionary');
    }

    // _dictionary = dictionary;
    _items = dictionary._dictionary.keys;
  }

  @override
  bool get isReadOnly {
    return true;
  }

  @override
  Iterator<TKey> get iterator {
    return _items.iterator;
  }

  @override
  int get length {
    return _items.length;
  }

  @override
  void add(TKey item) {
    throw UnsupportedError('add()');
  }

  @override
  void clear() {
    throw UnsupportedError('clear()');
  }

  @override
  bool containsValue(TKey value) {
    var iterator = this.iterator;
    while (iterator.moveNext()) {
      if (value == iterator.current) {
        return true;
      }
    }

    return false;
  }

  // TODO: copyTo()
  @override
  void copyTo(List<TKey> list, int index) {
    throw UnimplementedError('copyTo()');
  }

  @override
  bool remove(TKey item) {
    throw UnsupportedError('remove()');
  }

  @override
  String toString() {
    return _items.toString();
  }
}

class ReadOnlyDictionaryValueCollection<TKey, TValue> extends Object
    with Enumerable<TValue>
    implements ICollection<TValue> {
  // ReadOnlyDictionary<TKey, TValue> _dictionary;

  ICollection<TValue> _items;

  ReadOnlyDictionaryValueCollection._internal(
      ReadOnlyDictionary<TKey, TValue> dictionary) {
    if (dictionary == null) {
      throw ArgumentError.notNull('dictionary');
    }

    // _dictionary = dictionary;
    _items = dictionary._dictionary.values;
  }

  @override
  bool get isReadOnly {
    return true;
  }

  @override
  Iterator<TValue> get iterator {
    return _items.iterator;
  }

  @override
  int get length {
    return _items.length;
  }

  @override
  void add(TValue item) {
    throw UnsupportedError('add()');
  }

  @override
  void clear() {
    throw UnsupportedError('clear()');
  }

  @override
  bool containsValue(TValue value) {
    var iterator = this.iterator;
    while (iterator.moveNext()) {
      if (value == iterator.current) {
        return true;
      }
    }

    return false;
  }

  // TODO: copyTo()
  @override
  void copyTo(List<TValue> list, int index) {
    throw UnimplementedError('copyTo()');
  }

  @override
  bool remove(TValue item) {
    throw UnsupportedError('remove()');
  }

  @override
  String toString() {
    return _items.toString();
  }
}

abstract class _ReadOnlyDictionary<TKey, TValue>
    implements
        ICollection<KeyValuePair<TKey, TValue>>,
        IDictionary<TKey, TValue>,
        IReadOnlyCollection<KeyValuePair<TKey, TValue>>,
        IReadOnlyDictionary<TKey, TValue> {
  IDictionary<TKey, TValue> _dictionary;

  @override
  IEqualityComparer<TKey> get comparer {
    return _dictionary.comparer;
  }

  @override
  bool get isReadOnly {
    return true;
  }

  @override
  Iterator<KeyValuePair<TKey, TValue>> get iterator {
    Iterable<KeyValuePair<TKey, TValue>> generator() sync* {
      var it = _dictionary.keys.iterator;
      while (it.moveNext()) {
        var key = it.current;
        yield KeyValuePair(key, _dictionary[key]);
        ;
      }
    }

    return generator().iterator;
  }

  @override
  int get length {
    return _dictionary.length;
  }

  @override
  TValue operator [](TKey key) {
    return _dictionary[key];
  }

  @override
  void operator []=(TKey key, TValue value) {
    throw UnsupportedError('operator []=');
  }

  @override
  void add(KeyValuePair<TKey, TValue> element) {
    throw UnsupportedError('add()');
  }

  @override
  void clear() {
    throw UnsupportedError('clear()');
  }

  @override
  bool containsKey(TKey key) {
    return _dictionary.containsKey(key);
  }

  @override
  bool containsValue(KeyValuePair<TKey, TValue> item) {
    return _dictionary.containsValue(item);
  }

  // TODO: copyTo()
  @override
  void copyTo(List<KeyValuePair<TKey, TValue>> list, int index) {
    throw UnimplementedError('copyTo()');
  }

  @override
  bool remove(KeyValuePair<TKey, TValue> element) {
    throw UnsupportedError('remove()');
  }

  @override
  bool removeKey(TKey key) {
    throw UnsupportedError('removeKey()');
  }

  @override
  Map<TKey, TValue> toMap() {
    var map = LinkedHashMap<TKey, TValue>(
        equals: _dictionary.comparer.equals,
        hashCode: _dictionary.comparer.getHashCode);
    for (var kvp in asIterable()) {
      map[kvp.key] = kvp.value;
    }

    return map;
  }

  @override
  String toString() {
    return _dictionary.toString();
  }
}
