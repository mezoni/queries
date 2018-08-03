part of queries;

class _Iterable<E> extends IterableBase<E> {
  Iterator<E> _iterator;

  _Iterable(Iterator<E> iterator) {
    if (iterator == null) {
      throw new ArgumentError.notNull("iterator");
    }

    _iterator = iterator;
  }

  Iterator<E> get iterator => _iterator;
}
