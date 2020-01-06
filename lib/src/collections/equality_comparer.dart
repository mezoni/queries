part of queries.collections;

class CustomEqualityComparer<T> implements IEqualityComparer<T> {
  bool Function(T, T) _equals;

  int Function(T) _getHashCode;

  CustomEqualityComparer(
      bool Function(T, T) equals, int Function(T) getHashCode) {
    if (equals == null) {
      throw ArgumentError.notNull('equals');
    }

    if (getHashCode == null) {
      throw ArgumentError.notNull('getHashCode');
    }

    _equals = equals;
    _getHashCode = getHashCode;
  }

  @override
  bool equals(T a, T b) => _equals(a, b);

  @override
  int getHashCode(T object) => _getHashCode(object);
}

class EqualityComparer<T> implements IEqualityComparer<T> {
  @override
  bool equals(T a, T b) {
    return a == b;
  }

  @override
  int getHashCode(T object) {
    return object.hashCode;
  }
}

abstract class IEqualityComparer<T> {
  bool equals(T a, T b);

  int getHashCode(T object);
}
