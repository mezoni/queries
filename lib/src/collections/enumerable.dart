part of queries.collections;

abstract class IEnumerable<TSource> {
  /// Returns an iterator that iterates through the collection.
  Iterator<TSource> get iterator;

  /// Applies an accumulator function over a sequence.
  TSource aggregate(Func2<TSource, TSource, TSource> func);

  /// Applies an accumulator function over a sequence.
  TAccumulate aggregate$1<TAccumulate>(
      TAccumulate seed, Func2<TAccumulate, TSource, TAccumulate> func);

  /// Applies an accumulator function over a sequence.
  TResult aggregate$2<TAccumulate, TResult>(
      TAccumulate seed,
      Func2<TAccumulate, TSource, TAccumulate> func,
      Func1<TAccumulate, TResult> resultSelector);

  /// Determines whether all elements of a sequence satisfy a condition.
  bool all(Func1<TSource, bool> predicate);

  /// Determines whether any element of a sequence exists or satisfies a
  /// condition.
  bool any([Func1<TSource, bool> predicate]);

  /// Appends a value to the end of the sequence.
  IEnumerable<TSource> append(TSource element);

  /// Returns the [Iterable]<[TSource]> sequence obtained from the current
  Iterable<TSource> asIterable();

  /// Computes the average of a sequence of numeric values.
  double average([Func1<TSource, num> selector]);

  /// Casts the elements of an [IEnumerable] to the specified type.
  IEnumerable<TResult> cast<TResult>();

  /// Concatenates two sequences.
  IEnumerable<TSource> concat(IEnumerable<TSource> other);

  /// Determines whether a sequence contains a specified element.
  bool contains(TSource value, [IEqualityComparer<TSource> comparer]);

  /// Returns the number of elements in a sequence.
  int count([Func1<TSource, bool> predicate]);

  /// Returns the elements, or a default valued singleton collection if the
  /// sequence is empty.
  IEnumerable<TSource> defaultIfEmpty([TSource defaultValue]);

  /// Returns distinct elements from a sequence.
  IEnumerable<TSource> distinct([IEqualityComparer<TSource> comparer]);

  /// Returns the element at a specified index in a sequence.
  TSource elementAt(int index);

  /// Returns the element at a specified index in a sequence or a default
  /// value if the index is out of range.
  TSource elementAtOrDefault(int index);

  /// Produces the set difference of two sequences.
  IEnumerable<TSource> except(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]);

  /// Returns the first element of a sequence.
  TSource first(Func1<TSource, bool> predicate);

  /// Returns the first element of a sequence, or a default value if no
  /// element is found.
  TSource firstOrDefault([Func1<TSource, bool> predicate]);

  /// Groups the elements of a sequence.
  IEnumerable<IGrouping<TKey, TSource>> groupBy<TKey>(
      Func1<TSource, TKey> keySelector,
      [IEqualityComparer<TKey> comparer]);

  /// Groups the elements of a sequence.
  IEnumerable<IGrouping<TKey, TElement>> groupBy$1<TKey, TElement>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      [IEqualityComparer<TKey> comparer]);

  /// Groups the elements of a sequence.
  IEnumerable<TResult> groupBy$2<TKey, TResult>(
      Func1<TSource, TKey> keySelector,
      Func2<TKey, IEnumerable<TSource>, TResult> resultSelector,
      [IEqualityComparer<TKey> comparer]);

  /// Groups the elements of a sequence.
  IEnumerable<TResult> groupBy$3<TKey, TElement, TResult>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      Func2<TKey, IEnumerable<TElement>, TResult> resultSelector,
      [IEqualityComparer<TKey> comparer]);

  /// Correlates the elements of two sequences based on key equality, and
  /// groups the results.
  IEnumerable<TResult> groupJoin<TInner, TKey, TResult>(
      IEnumerable<TInner> inner,
      Func1<TSource, TKey> outerKeySelector,
      Func1<TInner, TKey> innerKeySelector,
      Func2<TSource, IEnumerable<TInner>, TResult> resultSelector,
      [IEqualityComparer<TKey> comparer]);

  /// Produces the set intersection of two sequences.
  IEnumerable<TSource> intersect(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]);

  /// Correlates the elements of two sequences based on matching keys.
  IEnumerable<TResult> join<TInner, TKey, TResult>(
      IEnumerable<TInner> inner,
      Func1<TSource, TKey> outerKeySelector,
      Func1<TInner, TKey> innerKeySelector,
      Func2<TSource, TInner, TResult> resultSelector,
      [IEqualityComparer<TKey> comparer]);

  /// Returns the last element of a sequence.
  TSource last([Func1<TSource, bool> predicate]);

  /// Returns the last element of a sequence, or a default value if no element
  /// is found.
  TSource lastOrDefault([Func1<TSource, bool> predicate]);

  /// Returns the maximum value in a sequence of values.
  TSource max();

  /// Returns the maximum value in a sequence of values.
  TResult max$1<TResult extends num>(TResult Function(TSource element) selector);

  /// Returns the minimum value in a sequence of values.
  TSource min();

  /// Returns the minimum value in a sequence of values.
  TResult min$1<TResult extends num>(Func1<TSource, TResult> selector);

  /// Filters the elements based on a specified type.
  IEnumerable<TResult> ofType<TResult>();

  /// Sorts the elements of a sequence in ascending order by using a specified
  /// comparer.
  IOrderedEnumerable<TSource> orderBy<TKey>(Func1<TSource, TKey> keySelector,
      [IComparer<TKey> comparer]);

  /// Sorts the elements of a sequence in descending order by using a
  /// specified comparer.
  IOrderedEnumerable<TSource> orderByDescending<TKey>(
      Func1<TSource, TKey> keySelector,
      [IComparer<TKey> comparer]);

  /// Adds a value to the beginning of the sequence.
  IEnumerable<TSource> prepend(TSource element);

  /// Inverts the order of the elements in a sequence.
  IEnumerable<TSource> reverse();

  /// Projects each element of a sequence into a new form.
  IEnumerable<TResult> select<TResult>(Func1<TSource, TResult> selector);

  /// Projects each element of a sequence into a new form.
  IEnumerable<TResult> select$1<TResult>(Func2<TSource, int, TResult> selector);

  /// Projects each element of a sequence to an [IEnumerable]<[TResult]> and
  /// flattens the resulting sequences into one sequence.
  IEnumerable<TResult> selectMany<TResult>(
      Func1<TSource, IEnumerable<TResult>> selector);

  /// Projects each element of a sequence to an [IEnumerable]<[TResult]> and
  /// flattens the resulting sequences into one sequence.
  IEnumerable<TResult> selectMany$1<TResult>(
      Func2<TSource, int, IEnumerable<TResult>> selector);

  /// Projects each element of a sequence to an [IEnumerable]<[TResult]> and
  /// flattens the resulting sequences into one sequence.
  IEnumerable<TResult> selectMany$2<TCollection, TResult>(
      Func1<TSource, IEnumerable<TCollection>> collectionSelector,
      Func2<TSource, TCollection, TResult> resultSelector);

  /// Projects each element of a sequence to an [IEnumerable]<[TResult]> and
  /// flattens the resulting sequences into one sequence.
  IEnumerable<TResult> selectMany$3<TCollection, TResult>(
      Func2<TSource, int, IEnumerable<TCollection>> collectionSelector,
      Func2<TSource, TCollection, TResult> resultSelector);

  /// Determines whether two sequences are equal according to an equality
  /// comparer.
  bool sequenceEqual(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]);

  /// Returns a single, specific element of a sequence.
  TSource single([Func1<TSource, bool> predicate]);

  /// Returns a single, specific element of a sequence, or a default value if
  /// that element is not found.
  TSource singleOrDefault([Func1<TSource, bool> predicate]);

  /// Bypasses a specified number of elements in a sequence and then returns
  /// the remaining elements.
  IEnumerable<TSource> skip(int count);

  /// Bypasses elements in a sequence as long as a specified condition is true
  /// and then returns the remaining elements.
  IEnumerable<TSource> skipWhile(Func1<TSource, bool> predicate);

  /// Bypasses elements in a sequence as long as a specified condition is true
  /// and then returns the remaining elements.
  IEnumerable<TSource> skipWhile$1(Func2<TSource, int, bool> predicate);

  /// Computes the sum of a sequence of numeric values.
  TSource sum();

  /// Computes the sum of a sequence of numeric values.
  TResult sum$1<TResult extends num>(Func1<TSource, TResult> selector);

  /// Returns a specified number of contiguous elements from the start of a
  /// sequence.
  IEnumerable<TSource> take(int count);

  /// Returns elements from a sequence as long as a specified condition is
  /// true, and then skips the remaining elements.
  IEnumerable<TSource> takeWhile(Func1<TSource, bool> predicate);

  /// Returns elements from a sequence as long as a specified condition is
  /// true, and then skips the remaining elements.
  IEnumerable<TSource> takeWhile$1(Func2<TSource, int, bool> predicate);

  /// Creates a [Collection]<[TSource]>.
  Collection<TSource> toCollection();

  /// Creates a [Dictionary]<[TKey], [TValue]>.
  Dictionary<TKey, TSource> toDictionary<TKey>(Func1<TSource, TKey> keySelector,
      [IEqualityComparer<TKey> comparer]);

  /// Creates a [Dictionary]<[TKey], [TValue]>.
  Dictionary<TKey, TElement> toDictionary$1<TKey, TElement>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      [IEqualityComparer<TKey> comparer]);

  /// Creates a [HashSet]<[TSource]>.
  HashSet<TSource> toHashSet([IEqualityComparer<TSource> comparer]);

  /// Creates a [List]<[TSource]>.
  List<TSource> toList({bool growable = true});

  /// Creates a [Lookup]<[TKey], [TElement]>.
  Lookup<TKey, TSource> toLookup<TKey>(Func1<TSource, TKey> keySelector,
      [IEqualityComparer<TKey> comparer]);

  /// Creates a [Lookup]<[TKey], [TElement]>.
  Lookup<TKey, TElement> toLookup$1<TKey, TElement>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      [IEqualityComparer<TKey> comparer]);

  /// Produces the set union of two sequences.
  IEnumerable<TSource> union(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]);

  /// Filters a sequence of values based on a predicate.
  IEnumerable<TSource> where(Func1<TSource, bool> predicate);

  /// Filters a sequence of values based on a predicate.
  IEnumerable<TSource> where$1(Func2<TSource, int, bool> predicate);

  /// Applies a specified function to the corresponding elements of two
  /// sequences, producing a sequence of the results
  IEnumerable zip<TSecond, TResult>(IEnumerable<TSecond> second,
      Func2<TSource, TSecond, TResult> resultSelector);
}
