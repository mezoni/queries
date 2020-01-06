part of queries;

class _Iterable<E> extends IterableBase<E> {
  Iterator<E> _iterator;

  _Iterable(Iterator<E> iterator) {
    if (iterator == null) {
      throw ArgumentError.notNull('iterator');
    }

    _iterator = iterator;
  }

  @override
  Iterator<E> get iterator => _iterator;
}
