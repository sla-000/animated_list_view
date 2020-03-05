import 'dart:math';

const int kIndexNotFound = -1;

List<T> mergeChanges<T>(
  List<T> listOld,
  List<T> listNew, {
  List<T> toAdd,
  List<T> toRemove,
  bool Function(T x1, T x2) isEqual,
}) {
  assert(listOld != null);
  assert(listNew != null);

  toAdd ??= <T>[];
  toRemove ??= <T>[];

  isEqual ??= (T a, T b) => (a.runtimeType == b.runtimeType) && (a == b);

  findDelta<T>(listOld, listNew, isEqual, toRemove);

  findDelta<T>(listNew, listOld, isEqual, toAdd);

  if (toRemove.isEmpty) {
    return listNew;
  }

  if (toRemove.length == listOld.length) {
    return _allRemoved<T>(listOld, listNew);
  }

  final List<T> rez = List<T>.of(listNew);

  final List<T> toRemoveLeft = <T>[];

  for (int q = 0; q < toRemove.length; ++q) {
    final T valFromListOldRemovingInListNew = toRemove[q];

    final int indexValFromListOldToAddToListNew = listOld.indexWhere(
        (T valInListOld) =>
            isEqual(valInListOld, valFromListOldRemovingInListNew));

    if (indexValFromListOldToAddToListNew == 0) {
      rez.insert(0, valFromListOldRemovingInListNew);
      continue;
    } else if (indexValFromListOldToAddToListNew == (listOld.length - 1)) {
      rez.add(valFromListOldRemovingInListNew);
      continue;
    } else {
      toRemoveLeft.add(valFromListOldRemovingInListNew);
    }
  }

  int stayedValueIndex = 0;

  for (int q = 0; q < listOld.length; ++q) {
    final T valListOld = listOld[q];

    if (toRemoveLeft.contains(valListOld)) {
    } else {
      stayedValueIndex = q;
    }
  }

  return rez;
}

List<T> _allRemoved<T>(List<T> list1, List<T> list2) {
  List<T> rez;

  if (list1.length >= list2.length) {
    rez = list1.zip(list2);
  } else {
    rez = list2.zip(list1);
  }

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

extension MyListExtension<T> on List<T> {
  List<T> zip(List<T> lst) {
    final List<T> rez = <T>[];
    final int maxLength = max(length, lst.length);

    for (int q = 0; q < maxLength; ++q) {
      if (q < length) {
        rez.add(elementAt(q));
      }

      if (q < lst.length) {
        rez.add(lst.elementAt(q));
      }
    }

    return rez;
  }
}
