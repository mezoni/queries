part of queries.collections;

class KeyValuePair<TKey, TValue> {
  final TKey key;

  final TValue value;

  KeyValuePair(this.key, this.value);

  int get hashCode {
    return key.hashCode | value.hashCode;
  }

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is KeyValuePair) {
      return key == other.key && value == other.value;
    }

    return false;
  }

  String toString() {
    return "$key : $value";
  }
}
