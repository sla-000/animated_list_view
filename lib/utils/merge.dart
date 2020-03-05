const int kIndexNotFound = -1;

List<T> mergeChanges<T>(
  List<T> list1,
  List<T> list2, {
  List<T> toAdd,
  List<T> toRemove,
  bool Function(T x1, T x2) isEqual,
}) {
  assert(list1 != null);
  assert(list2 != null);

  toAdd ??= <T>[];
  toRemove ??= <T>[];

  isEqual ??= (T a, T b) => (a.runtimeType == b.runtimeType) && (a == b);

  findDelta(list1, list2, isEqual, toRemove);

  findDelta(list2, list1, isEqual, toAdd);

  final List<T> rez = <T>[];

  rez.addAll(list2);

  return rez;
}

void findDelta<T>(
  List<T> list1,
  List<T> list2,
  bool isEqual(T x1, T x2),
  List<T> toRemove,
) {
  for (int q = 0; q < list1.length; ++q) {
    final T valInList1 = list1[q];

    if (list2.indexWhere((T valInList2) => isEqual(valInList2, valInList1)) ==
        kIndexNotFound) {
      toRemove.add(valInList1);
    }
  }
}
