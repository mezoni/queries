part of queries.collections;

abstract class IList<TElement>
    implements ICollection<TElement>, IReadOnlyCollection<TElement> {
  TElement operator [](int index);

  void operator []=(int index, TElement item);

  int indexOf(TElement item, [int start = 0]);

  void insert(int index, TElement item);

  TElement removeAt(int index);
}

abstract class IReadOnlyList<TElement>
    implements IReadOnlyCollection<TElement> {
  TElement operator [](int index);
}
