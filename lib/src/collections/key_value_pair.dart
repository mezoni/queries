part of queries.collections;

class KeyValuePair<TKey, TValue> {
  final TKey key;

  final TValue value;

  KeyValuePair(this.key, this.value);

  @override
  int get hashCode {
    return key.hashCode | value.hashCode;
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is KeyValuePair) {
      return key == other.key && value == other.value;
    }

    return false;
  }

  @override
  String toString() {
    return '$key : $value';
  }
}
