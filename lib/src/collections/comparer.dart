part of queries.collections;

typedef int Comparison<T>(T x, T y);

abstract class Comparer<T> {
  static IComparer<T> create<T>(Comparison<T> comparison) {
    if (comparison == null) {
      throw new ArgumentError.notNull("comparison");
    }

    return new _GenericComparer(comparison);
  }

  static IComparer<T> getDefault<T>() {
    var test = new _TypeHolder<T>();
    if (test is _TypeHolder<Comparable<T>>) {
      return new _GenericComparer<T>(Comparable.compare as Func2<T, T, int>);
    }

    throw new StateError("Unable to determine default comparer");
  }
}

abstract class IComparer<T> {
  int compare(T x, T y);
}

class _GenericComparer<T> implements IComparer<T> {
  Comparison<T> comparison;

  _GenericComparer(this.comparison);

  int compare(T x, T y) {
    if (x == null || y == null) {
      if (y == null && x == null) {
        return 0;
      }
      if (y == null) {
        return 1;
      }
      if (x == null) {
        return -1;
      }
    }

    return comparison(x, y);
  }
}
