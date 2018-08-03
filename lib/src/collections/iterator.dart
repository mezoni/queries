part of queries.collections;

typedef bool _IteratorAction();

class _Iterator<TElement> implements Iterator<TElement> {
  _IteratorAction action;

  TElement result;

  int state = 0;

  _Iterator();

  TElement get current => result;

  bool moveNext() => action();
}
