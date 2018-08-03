part of queries;

abstract class Enumerable<TSource> implements IEnumerable<TSource> {
  TSource aggregate(Func2<TSource, TSource, TSource> func) {
    if (func == null) {
      throw new ArgumentError.notNull("func");
    }

    var cond = false;
    TSource result;
    var it = iterator;
    while (it.moveNext()) {
      if (cond) {
        result = func(result, it.current);
      } else {
        result = it.current;
        cond = true;
      }
    }

    if (!cond) {
      throw _errorEmptySequence();
    }

    return result;
  }

  TAccumulate aggregate$1<TAccumulate>(
      TAccumulate seed, Func2<TAccumulate, TSource, TAccumulate> func) {
    if (func == null) {
      throw new ArgumentError.notNull("func");
    }

    var acc = seed;
    var it = iterator;
    while (it.moveNext()) {
      acc = func(acc, it.current);
    }

    return acc;
  }

  TResult aggregate$2<TAccumulate, TResult>(
      TAccumulate seed,
      Func2<TAccumulate, TSource, TAccumulate> func,
      Func1<TAccumulate, TResult> resultSelector) {
    if (func == null) {
      throw new ArgumentError.notNull("func");
    }

    if (resultSelector == null) {
      throw new ArgumentError.notNull("resultSelector");
    }

    var acc = seed;
    var it = iterator;
    while (it.moveNext()) {
      acc = func(acc, it.current);
    }

    return resultSelector(acc);
  }

  bool all(Func1<TSource, bool> predicate) {
    if (predicate == null) {
      throw new ArgumentError.notNull("predicate");
    }

    var it = iterator;
    while (it.moveNext()) {
      if (!predicate(it.current)) {
        return false;
      }
    }

    return true;
  }

  bool any([Func1<TSource, bool> predicate]) {
    if (predicate == null) {
      return iterator.moveNext();
    }

    var it = iterator;
    while (it.moveNext()) {
      if (predicate(it.current)) {
        return true;
      }
    }

    return false;
  }

  IEnumerable<TSource> append(TSource element) {
    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        yield it.current;
      }

      yield element;
    }

    return new _Enumerable<TSource>(generator());
  }

  Iterable<TSource> asIterable() {
    return new _Iterable<TSource>(iterator);
  }

  double average([Func1<TSource, num> selector]) {
    if (this is! IEnumerable<num>) {
      _errorUnableToCompute<TSource>("average");
    }

    var count = 0;
    num sum;
    if (selector == null) {
      var it = iterator as Iterator<num>;
      while (it.moveNext()) {
        var current = it.current;
        if (current != null) {
          if (sum == null) {
            sum = current;
          }

          sum += current;
        }

        count++;
      }
    } else {
      var it = iterator;
      while (it.moveNext()) {
        var value = selector(it.current);
        if (value != null) {
          if (sum == null) {
            sum = value;
          }
          sum += value;
        }

        count++;
      }
    }

    if (count > 0 && sum != null) {
      return sum / count;
    }

    return sum as double;
  }

  IEnumerable<TResult> cast<TResult>() {
    throw new UnimplementedError("cast");
  }

  IEnumerable<TSource> concat(IEnumerable<TSource> other) {
    if (other == null) {
      throw new ArgumentError.notNull("other");
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        yield it.current;
      }

      it = other.iterator;
      while (it.moveNext()) {
        yield it.current;
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  bool contains(TSource value, [IEqualityComparer<TSource> comparer]) {
    if (comparer == null) {
      comparer = new EqualityComparer<TSource>();
    }

    var it = iterator;
    while (it.moveNext()) {
      if (comparer.equals(it.current, value)) {
        return true;
      }
    }

    return false;
  }

  int count([Func1<TSource, bool> predicate]) {
    var count = 0;
    if (predicate == null) {
      if (this is IList<TSource>) {
        var list = this as IList<TSource>;
        return list.length;
      }

      var it = iterator;
      while (it.moveNext()) {
        count++;
      }
    } else {
      var it = iterator;
      while (it.moveNext()) {
        if (predicate(it.current)) {
          count++;
        }
      }
    }

    return count;
  }

  IEnumerable<TSource> defaultIfEmpty([TSource defaultValue]) {
    Iterable<TSource> generator() sync* {
      var empty = true;
      var it = iterator;
      while (it.moveNext()) {
        empty = false;
        yield it.current;
      }

      if (empty) {
        yield defaultValue;
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> distinct([IEqualityComparer<TSource> comparer]) {
    if (comparer == null) {
      comparer = new EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      var hashSet =
          new HashSet(equals: comparer.equals, hashCode: comparer.getHashCode);
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (hashSet.add(current)) {
          yield current;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  TSource elementAt(int index) {
    if (index == null) {
      throw new ArgumentError.notNull("index");
    }

    if (index < 0) {
      throw new RangeError.value(index, "index");
    }

    if (this is IList<TSource>) {
      var list = this as IList<TSource>;
      return list[index];
    }

    var counter = 0;
    var it = iterator;
    while (it.moveNext()) {
      if (counter++ == index) {
        return it.current;
      }
    }

    throw new RangeError.range(index, 0, counter - 1);
  }

  TSource elementAtOrDefault(int index) {
    TSource result;
    if (index == null) {
      throw new ArgumentError.notNull("index");
    }

    if (index < 0) {
      return result;
    }

    if (this is IList<TSource>) {
      var list = this as IList<TSource>;
      if (index + 1 > list.length) {
        return result;
      }

      return list[index];
    }

    var counter = 0;
    var it = iterator;
    while (it.moveNext()) {
      if (counter++ == index) {
        return it.current;
      }
    }

    return result;
  }

  IEnumerable<TSource> except(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw new ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      var hashSet = other.toHashSet(comparer);
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (!hashSet.contains(current)) {
          yield current;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  TSource first([Func1<TSource, bool> predicate]) {
    var it = iterator;
    if (predicate == null) {
      if (it.moveNext()) {
        return it.current;
      }
    } else {
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current)) {
          return current;
        }
      }
    }

    throw _errorEmptySequence();
  }

  TSource firstOrDefault([Func1<TSource, bool> predicate]) {
    TSource result;
    var it = iterator;
    if (predicate == null) {
      if (it.moveNext()) {
        return it.current;
      }
    } else {
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current)) {
          return current;
        }
      }
    }

    return result;
  }

  IEnumerable<IGrouping<TKey, TSource>> groupBy<TKey>(
      Func1<TSource, TKey> keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    IGrouping<TKey, TSource> resultSelector(
        TKey key, IEnumerable<TSource> elements) {
      return new _Grouping(key, elements);
    }

    return groupBy$3<TKey, TSource, IGrouping<TKey, TSource>>(
        keySelector, (e) => e, resultSelector);
  }

  IEnumerable<IGrouping<TKey, TElement>> groupBy$1<TKey, TElement>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw new ArgumentError.notNull("elementSelector");
    }

    IGrouping<TKey, TElement> resultSelector(
        TKey key, IEnumerable<TElement> elements) {
      return new _Grouping(key, elements);
    }

    return groupBy$3<TKey, TElement, IGrouping<TKey, TElement>>(
        keySelector, elementSelector, resultSelector);
  }

  IEnumerable<TResult> groupBy$2<TKey, TResult>(
      Func1<TSource, TKey> keySelector,
      Func2<TKey, IEnumerable<TSource>, TResult> resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (resultSelector == null) {
      throw new ArgumentError.notNull("resultSelector");
    }

    return groupBy$3<TKey, TSource, TResult>(
        keySelector, (e) => e, resultSelector);
  }

  IEnumerable<TResult> groupBy$3<TKey, TElement, TResult>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      Func2<TKey, IEnumerable<TElement>, TResult> resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw new ArgumentError.notNull("elementSelector");
    }

    if (resultSelector == null) {
      throw new ArgumentError.notNull("resultSelector");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TKey>();
    }

    Iterable<TResult> generator() sync* {
      var map = new LinkedHashMap<TKey, List<TElement>>(
          equals: comparer.equals, hashCode: comparer.getHashCode);
      var it = iterator;
      while (it.moveNext()) {
        var value = it.current;
        var key = keySelector(value);        
        var element = elementSelector(value);
        var elements = map[key];
        if (elements == null) {
          elements = <TElement>[];
          map[key] = elements;
        }

        elements.add(element);
      }

      for (var key in map.keys) {
        new _Enumerable<TElement>(map[key]);
        yield resultSelector(key, new _Enumerable<TElement>(map[key]));
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  IEnumerable<TResult> groupJoin<TInner, TKey, TResult>(
      IEnumerable<TInner> inner,
      TKey outerKeySelector(TSource element),
      TKey innerKeySelector(TInner element),
      TResult resultSelector(
          TSource outerElement, IEnumerable<TInner> innerElements),
      [IEqualityComparer<TKey> comparer]) {
    if (inner == null) {
      throw new ArgumentError.notNull("inner");
    }

    if (innerKeySelector == null) {
      throw new ArgumentError.notNull("innerKeySelector");
    }

    if (outerKeySelector == null) {
      throw new ArgumentError.notNull("outerKeySelector");
    }

    if (resultSelector == null) {
      throw new ArgumentError.notNull("resultSelector");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TKey>();
    }

    Iterable<TResult> generator() sync* {
      var dict = new Dictionary<TKey, List<TInner>>(comparer);
      var it = inner.iterator;
      while (it.moveNext()) {
        var current = it.current;
        var key = innerKeySelector(current);
        var elements = dict[key];
        if (elements == null) {
          elements = <TInner>[];
          dict[key] = elements;
        }

        elements.add(current);
      }

      var it2 = iterator;
      while (it2.moveNext()) {
        var current = it2.current;
        var key = outerKeySelector(current);
        var innerValues = dict[key];
        if (innerValues != null) {
          yield resultSelector(current, new _Enumerable<TInner>(innerValues));
        }
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  IEnumerable<TSource> intersect(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw new ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      var second = other.toHashSet(comparer);
      var output = new HashSet<TSource>(
          equals: comparer.equals, hashCode: comparer.getHashCode);
      var it = second.iterator;
      while (it.moveNext()) {
        second.add(it.current);
      }

      it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (second.contains(current)) {
          if (output.add(current)) {
            yield current;
          }
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TResult> join<TInner, TKey, TResult>(
      IEnumerable<TInner> inner,
      TKey outerKeySelector(TSource outerElement),
      TKey innerKeySelector(TInner innerElement),
      TResult resultSelector(TSource outerElement, TInner innerElement),
      [IEqualityComparer<TKey> comparer]) {
    if (inner == null) {
      throw new ArgumentError.notNull("inner");
    }

    if (innerKeySelector == null) {
      throw new ArgumentError.notNull("innerKeySelector");
    }

    if (outerKeySelector == null) {
      throw new ArgumentError.notNull("outerKeySelector");
    }

    if (resultSelector == null) {
      throw new ArgumentError.notNull("resultSelector");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TKey>();
    }

    Iterable<TResult> generator() sync* {
      var innerMap = new LinkedHashMap<TKey, List<TInner>>(
          equals: comparer.equals, hashCode: comparer.getHashCode);
      var it = inner.iterator;
      while (it.moveNext()) {
        var innerValue = it.current;
        var key = innerKeySelector(innerValue);
        var elements = innerMap[key];
        if (elements == null) {
          elements = <TInner>[];
          innerMap[key] = elements;
        }

        elements.add(innerValue);
      }

      var it2 = iterator;
      while (it2.moveNext()) {
        var outerValue = it2.current;
        var key = outerKeySelector(outerValue);
        var innerValues = innerMap[key];
        if (innerValues != null) {
          for (var innerValue in innerValues) {
            yield resultSelector(outerValue, innerValue);
          }
        }
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  TSource last([Func1<TSource, bool> predicate]) {
    var it = iterator;
    var length = 0;
    TSource result;
    if (predicate == null) {
      while (it.moveNext()) {
        length++;
        result = it.current;
      }
    } else {
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current)) {
          length++;
          result = current;
        }
      }
    }

    if (length == 0) {
      throw _errorEmptySequence();
    }

    return result;
  }

  TSource lastOrDefault([Func1<TSource, bool> predicate]) {
    var it = iterator;
    TSource result;
    if (predicate == null) {
      while (it.moveNext()) {
        result = it.current;
      }
    } else {
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current)) {
          result = current;
        }
      }
    }

    return result;
  }

  TSource max() {
    return (this as IEnumerable<num>).max$1<num>((e) => e) as TSource;
  }

  TResult max$1<TResult extends num>(TResult selector(TSource element)) {
    if (selector == null) {
      throw new ArgumentError.notNull("selector");
    }

    return _computeNullable<TResult>("max", (r, v) => r < v ? v : r, selector);
  }

  TSource min() {
    return (this as IEnumerable<num>).min$1<num>((e) => e) as TSource;
  }

  TResult min$1<TResult extends num>(TResult selector(TSource element)) {
    return _computeNullable<TResult>("min", (r, v) => r > v ? v : r, selector);
  }

  IEnumerable<TResult> ofType<TResult>() {
    throw new UnimplementedError("ofType");
  }

  IOrderedEnumerable<TSource> orderBy<TKey>(Func1<TSource, TKey> keySelector,
      [IComparer<TKey> comparer]) {
    return new _OrderedEnumerable<TSource, TKey>(
        this, keySelector, null, false, null);
  }

  IOrderedEnumerable<TSource> orderByDescending<TKey>(
      Func1<TSource, TKey> keySelector,
      [IComparer<TKey> comparer]) {
    return new _OrderedEnumerable<TSource, TKey>(
        this, keySelector, null, true, null);
  }

  IEnumerable<TSource> prepend(TSource element) {
    Iterable<TSource> generator() sync* {
      yield element;
      var it = iterator;
      while (it.moveNext()) {
        yield it.current;
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> reverse() {
    Iterable<TSource> generator() sync* {
      IList<TSource> list;
      if (this is IList<TSource>) {
        list = this as IList<TSource>;
      } else {
        list = toCollection();
      }

      var length = list.length;
      for (var i = length - 1; i >= 0; i--) {
        yield list[i];
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TResult> select<TResult>(Func1<TSource, TResult> selector) {
    if (selector == null) {
      throw new ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        yield selector(it.current);
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  IEnumerable<TResult> select$1<TResult>(
      Func2<TSource, int, TResult> selector) {
    if (selector == null) {
      throw new ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      var index = 0;
      var it = iterator;
      while (it.moveNext()) {
        yield selector(it.current, index++);
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  IEnumerable<TResult> selectMany<TResult>(
      Func1<TSource, IEnumerable<TResult>> selector) {
    if (selector == null) {
      throw new ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        var it2 = selector(current).iterator;
        while (it2.moveNext()) {
          yield it2.current;
        }
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  IEnumerable<TResult> selectMany$1<TResult>(
      Func2<TSource, int, IEnumerable<TResult>> selector) {
    if (selector == null) {
      throw new ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      var index = 0;
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        var it2 = selector(current, index++).iterator;
        while (it2.moveNext()) {
          yield it2.current;
        }
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  IEnumerable<TResult> selectMany$2<TCollection, TResult>(
      Func1<TSource, IEnumerable<TCollection>> collectionSelector,
      Func2<TSource, TCollection, TResult> resultSelector) {
    if (collectionSelector == null) {
      throw new ArgumentError.notNull("collectionSelector");
    }

    if (resultSelector == null) {
      throw new ArgumentError.notNull("resultSelector");
    }

    Iterable<TResult> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        var it2 = collectionSelector(current).iterator;
        while (it2.moveNext()) {
          yield resultSelector(current, it2.current);
        }
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  IEnumerable<TResult> selectMany$3<TCollection, TResult>(
      Func2<TSource, int, IEnumerable<TCollection>> collectionSelector,
      Func2<TSource, TCollection, TResult> resultSelector) {
    if (collectionSelector == null) {
      throw new ArgumentError.notNull("collectionSelector");
    }

    if (resultSelector == null) {
      throw new ArgumentError.notNull("resultSelector");
    }

    Iterable<TResult> generator() sync* {
      var index = 0;
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        var it2 = collectionSelector(current, index++).iterator;
        while (it2.moveNext()) {
          yield resultSelector(current, it2.current);
        }
      }
    }

    return new _Enumerable<TResult>(generator());
  }

  bool sequenceEqual(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw new ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TSource>();
    }

    var it1 = iterator;
    var it2 = iterator;
    while (true) {
      var moved1 = it1.moveNext();
      var moved2 = it2.moveNext();
      if (moved1 && moved2) {
        if (!comparer.equals(it1.current, it2.current)) {
          return false;
        }
      } else {
        if (moved1 != moved2) {
          return false;
        } else {
          break;
        }
      }
    }

    return true;
  }

  TSource single([Func1<TSource, bool> predicate]) {
    TSource result;
    var it = iterator;
    if (predicate == null) {
      if (!it.moveNext()) {
        throw _errorEmptySequence();
      }

      result = it.current;
      if (it.moveNext()) {
        throw _errorMoreThanOneElement();
      }
    } else {
      var found = false;
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current)) {
          if (found) {
            throw _errorMoreThanOneElement();
          }

          found = true;
          result = current;
        }
      }

      if (!found) {
        throw _errorEmptySequence();
      }
    }

    return result;
  }

  TSource singleOrDefault([Func1<TSource, bool> predicate]) {
    TSource result;
    var it = iterator;
    if (predicate == null) {
      if (!it.moveNext()) {
        return result;
      }

      result = it.current;
      if (it.moveNext()) {
        throw _errorMoreThanOneElement();
      }
    } else {
      var found = false;
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current)) {
          if (found) {
            throw _errorMoreThanOneElement();
          }

          found = true;
          result = current;
        }
      }

      if (!found) {
        return result;
      }
    }

    return result;
  }

  IEnumerable<TSource> skip(int count) {
    if (count == null) {
      throw new ArgumentError.notNull("count");
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        if (count-- <= 0) {
          yield it.current;
          break;
        }
      }

      while (it.moveNext()) {
        yield it.current;
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> skipWhile(Func1<TSource, bool> predicate) {
    if (predicate == null) {
      throw new ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (!predicate(current)) {
          yield current;
          break;
        }
      }

      while (it.moveNext()) {
        yield it.current;
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> skipWhile2(Func2<TSource, int, bool> predicate) {
    if (predicate == null) {
      throw new ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var index = 0;
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (!predicate(current, index++)) {
          yield current;
          break;
        }
      }

      while (it.moveNext()) {
        yield it.current;
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  TSource sum() {
    return (this as IEnumerable<num>).sum$1<num>((e) => e) as TSource;
  }

  TResult sum$1<TResult extends num>(TResult selector(TSource element)) {
    return _computeNullable<TResult>("sum", (r, v) => r + v, selector);
  }

  IEnumerable<TSource> take(int count) {
    if (count == null) {
      throw new ArgumentError.notNull("count");
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        if (count-- > 0) {
          yield it.current;
        } else {
          break;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> takeWhile(Func1<TSource, bool> predicate) {
    if (predicate == null) {
      throw new ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        if (predicate(it.current)) {
          yield it.current;
        } else {
          break;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> takeWhile$1(Func2<TSource, int, bool> predicate) {
    if (predicate == null) {
      throw new ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var index = 0;
      var it = iterator;
      while (it.moveNext()) {
        if (predicate(it.current, index++)) {
          yield it.current;
        } else {
          break;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  Collection<TSource> toCollection() {
    return new Collection<TSource>(toList());
  }

  Dictionary<TKey, TSource> toDictionary<TKey>(Func1<TSource, TKey> keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TKey>();
    }

    var result = new Dictionary<TKey, TSource>(comparer);
    var it = iterator;
    while (it.moveNext()) {
      var current = it.current;
      var key = keySelector(current);
      result[key] = current;
    }

    return result;
  }

  Dictionary<TKey, TElement> toDictionary$1<TKey, TElement>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw new ArgumentError.notNull("elementSelector");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TKey>();
    }

    var result = new Dictionary<TKey, TElement>(comparer);
    var it = iterator;
    while (it.moveNext()) {
      var current = it.current;
      var key = keySelector(current);
      result[key] = elementSelector(current);
    }

    return result;
  }

  HashSet<TSource> toHashSet([IEqualityComparer<TSource> comparer]) {
    if (comparer == null) {
      comparer = new EqualityComparer<TSource>();
    }

    var result = new HashSet<TSource>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    result.addAll(asIterable());
    return result;
  }

  List<TSource> toList({bool growable: true}) {
    if (growable == null) {
      throw new ArgumentError.notNull("growable");
    }

    return new List<TSource>.from(asIterable(), growable: growable);
  }

  Lookup<TKey, TSource> toLookup<TKey>(Func1<TSource, TKey> keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TKey>();
    }

    var dict = new Dictionary<TKey, IGrouping<TKey, TSource>>(comparer);
    var it = groupBy<TKey>(keySelector, comparer).iterator;
    while (it.moveNext()) {
      var current = it.current;
      dict[current.key] = current;
    }

    return new Lookup<TKey, TSource>._internal(dict);
  }

  Lookup<TKey, TElement> toLookup$1<TKey, TElement>(
      Func1<TSource, TKey> keySelector,
      Func1<TSource, TElement> elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw new ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw new ArgumentError.notNull("elementSelector");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TKey>();
    }

    var dict = new Dictionary<TKey, IGrouping<TKey, TElement>>(comparer);
    var it = groupBy$1<TKey, TElement>(keySelector, elementSelector, comparer)
        .iterator;
    while (it.moveNext()) {
      var current = it.current;
      dict[current.key] = current;
    }

    return new Lookup<TKey, TElement>._internal(dict);
  }

  IEnumerable<TSource> union(IEnumerable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw new ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = new EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      var hashSet =
          new HashSet(equals: comparer.equals, hashCode: comparer.getHashCode);
      while (it.moveNext()) {
        var current = it.current;
        if (hashSet.add(current)) {
          yield current;
        }
      }

      it = other.iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (hashSet.add(current)) {
          yield current;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> where(Func1<TSource, bool> predicate) {
    if (predicate == null) {
      throw new ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current)) {
          yield current;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  IEnumerable<TSource> where$1(Func2<TSource, int, bool> predicate) {
    if (predicate == null) {
      throw new ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var index = 0;
      var it = iterator;
      while (it.moveNext()) {
        var current = it.current;
        if (predicate(current, index++)) {
          yield current;
        }
      }
    }

    return new _Enumerable<TSource>(generator());
  }

  TResult _computeNullable<TResult extends num>(
      String name,
      Func2<TResult, TResult, TResult> func,
      TResult selector(TSource element)) {
    TResult result;
    var first = true;
    var it = iterator;
    while (it.moveNext()) {
      var current = it.current;
      if (current == null) {
        continue;
      }

      var value = selector(current);
      if (result == null) {
        result = value;
      }

      if (value != null) {
        if (!first) {
          result = func(result, value);
        } else {
          first = false;
        }
      }
    }

    return result;
  }

  StateError _errorEmptySequence() {
    return new StateError("Sequence contains no elements");
  }

  StateError _errorMoreThanOneElement() {
    return new StateError("Sequence contains more than one element");
  }

  StateError _errorUnableToCompute<TResult>(String operation) {
    return new StateError(
        "Unable to compute '$operation' of '$TResult' values");
  }

  /// Returns an empty [IEnumerable]<[TResult]> that has the specified type
  /// argument.
  static IEnumerable<TResult> empty<TResult>() {
    // TODO: Unimplemented "empty";
    throw new UnimplementedError("empty");
  }

  /// Generates a sequence of integral numbers within a specified range.
  static IEnumerable<int> range(int start, int count) {
    Iterable<int> generator() sync* {
      for (var i = 0; i < count; i++) {
        yield start + i;
      }
    }

    return new _Enumerable<int>(generator());
  }

  /// Generates a sequence that contains one repeated value.
  static IEnumerable<T> repeat<T>(T element, int count) {
    Iterable<T> generator() sync* {
      for (var i = 0; i < count; i++) {
        yield element;
      }
    }

    return new _Enumerable<T>(generator());
  }
}

class _Enumerable<T> extends Object with Enumerable<T> {
  Iterable<T> _iterable;

  _Enumerable(this._iterable);

  Iterator<T> get iterator {
    return _iterable.iterator;
  }
}
