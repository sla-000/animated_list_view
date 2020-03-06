import 'package:flutter_test/flutter_test.dart';

import '../lib/utils/merge.dart';

void main() {
  group('Test standalone zip', () {
    test('test1', () {
      final List<int> x = <int>[1, 2, 3];
      final List<int> y = <int>[];

      x.zip(y);

      expect(x.zip(y), <int>[1, 2, 3]);
    });

    test('test2', () {
      final List<int> x = <int>[];
      final List<int> y = <int>[1, 2, 3];

      x.zip(y);

      expect(x.zip(y), <int>[1, 2, 3]);
    });

    test('test3', () {
      final List<int> x = <int>[1, 2, 3];
      final List<int> y = <int>[10];

      x.zip(y);

      expect(x.zip(y), <int>[1, 10, 2, 3]);
    });

    test('test4', () {
      final List<int> x = <int>[10];
      final List<int> y = <int>[1, 2, 3];

      x.zip(y);

      expect(x.zip(y), <int>[10, 1, 2, 3]);
    });

    test('test5', () {
      final List<int> x = <int>[1, 2, 3, 4, 5];
      final List<int> y = <int>[10, 11, 12, 13, 14];

      x.zip(y);

      expect(x.zip(y), <int>[1, 10, 2, 11, 3, 12, 4, 13, 5, 14]);
    });
  });

  group('Test merge when all old values removed', () {
    test('test1', () {
      final List<int> x = <int>[1, 2, 3, 4, 5];
      final List<int> y = <int>[10, 11, 12, 13, 14];

      final List<int> rez = mergeChanges(x, y);

      expect(rez, <int>[1, 10, 2, 11, 3, 12, 4, 13, 5, 14]);
    });

    test('test2', () {
      final List<int> x = <int>[1, 2, 3, 4, 5];
      final List<int> y = <int>[10, 11, 12, 13, 14, 15];

      final List<int> rez = mergeChanges(x, y);

      expect(rez, <int>[10, 1, 11, 2, 12, 3, 13, 4, 14, 5, 15]);
    });

    test('test3', () {
      final List<int> x = <int>[1, 2, 3, 4, 5, 6];
      final List<int> y = <int>[10, 11, 12, 13, 14];

      final List<int> rez = mergeChanges(x, y);

      expect(rez, <int>[1, 10, 2, 11, 3, 12, 4, 13, 5, 14, 6]);
    });
  });

  group('Test toAdd and toRemove only', () {
    List<int> toAdd;
    List<int> toRemove;

    setUp(() {
      toAdd = <int>[];
      toRemove = <int>[];
    });

    group('Test mergeChanges function equal', () {
      test('test1', () {
        final List<int> x = <int>[1];
        final List<int> y = <int>[1];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove, <int>[]);
      });

      test('test2', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[1, 2, 3];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove, <int>[]);
      });
    });

    group('Test mergeChanges function mix', () {
      test('test1', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[2, 1];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove, <int>[]);
      });

      test('test2', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[1, 3, 2];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove, <int>[]);
      });

      test('test3', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[3, 2, 1];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove, <int>[]);
      });

      test('test4', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[2, 1, 3];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove, <int>[]);
      });
    });

    group('Test mergeChanges function add', () {
      test('test1', () {
        final List<int> x = <int>[1];
        final List<int> y = <int>[1, 2];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd.length, 1);
        expect(toAdd.contains(2), true);
        expect(toRemove, <int>[]);
      });

      test('test2', () {
        final List<int> x = <int>[1];
        final List<int> y = <int>[2, 1];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd.length, 1);
        expect(toAdd.contains(2), true);
        expect(toRemove, <int>[]);
      });

      test('test3', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[1, 2, 3];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd.length, 1);
        expect(toAdd.contains(3), true);
        expect(toRemove, <int>[]);
      });

      test('test4', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[1, 3, 2];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd.length, 1);
        expect(toAdd.contains(3), true);
        expect(toRemove, <int>[]);
      });

      test('test5', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[3, 2, 1];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd.length, 1);
        expect(toAdd.contains(3), true);
        expect(toRemove, <int>[]);
      });

      test('test6', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[6, 1, 2, 3, 4, 7, 5];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd.length, 2);
        expect(toAdd.contains(6), true);
        expect(toAdd.contains(7), true);
        expect(toRemove, <int>[]);
      });
    });

    group('Test mergeChanges function remove', () {
      test('test1', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[1];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove.length, 1);
        expect(toRemove.contains(2), true);
      });

      test('test2', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[2];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove.length, 1);
        expect(toRemove.contains(1), true);
      });

      test('test3', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[1, 3];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove.length, 1);
        expect(toRemove.contains(2), true);
      });

      test('test4', () {
        final List<int> x = <int>[1, 2, 3, 4];
        final List<int> y = <int>[2, 4];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove.length, 2);
        expect(toRemove.contains(1), true);
        expect(toRemove.contains(3), true);
      });

      test('test5', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[4, 5];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove.length, 3);
        expect(toRemove.contains(1), true);
        expect(toRemove.contains(2), true);
        expect(toRemove.contains(3), true);
      });

      test('test6', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[1, 2];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove.length, 3);
        expect(toRemove.contains(3), true);
        expect(toRemove.contains(4), true);
        expect(toRemove.contains(5), true);
      });

      test('test7', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[2, 4];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd, <int>[]);
        expect(toRemove.length, 3);
        expect(toRemove.contains(1), true);
        expect(toRemove.contains(3), true);
        expect(toRemove.contains(5), true);
      });
    });

    group('Test mergeChanges function all', () {
      test('test1', () {
        final List<int> x = <int>[1, 2, 3, 4, 5, 6, 7, 8];
        final List<int> y = <int>[2, 9, 10, 3, 4, 6, 11, 12];

        mergeChanges(x, y, toAdd: toAdd, toRemove: toRemove);

        expect(toAdd.length, 4);
        expect(toAdd.contains(9), true);
        expect(toAdd.contains(10), true);
        expect(toAdd.contains(11), true);
        expect(toAdd.contains(12), true);
        expect(toRemove.length, 4);
        expect(toRemove.contains(1), true);
        expect(toRemove.contains(5), true);
        expect(toRemove.contains(7), true);
        expect(toRemove.contains(8), true);
      });
    });
  });

  group('Test rez only', () {
    group('Test mergeChanges function equal', () {
      test('test1', () {
        final List<int> x = <int>[1];
        final List<int> y = <int>[1];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1]);
      });

      test('test2', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[1, 2, 3];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3]);
      });
    });

    group('Test mergeChanges function mix', () {
      test('test1', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[2, 1];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[2, 1]);
      });

      test('test2', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[1, 3, 2];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 3, 2]);
      });

      test('test3', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[3, 2, 1];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[3, 2, 1]);
      });

      test('test4', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[2, 1, 3];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[2, 1, 3]);
      });
    });

    group('Test mergeChanges function add', () {
      test('test1', () {
        final List<int> x = <int>[1];
        final List<int> y = <int>[1, 2];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2]);
      });

      test('test2', () {
        final List<int> x = <int>[1];
        final List<int> y = <int>[2, 1];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[2, 1]);
      });

      test('test3', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[1, 2, 3];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3]);
      });

      test('test4', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[1, 3, 2];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 3, 2]);
      });

      test('test5', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[3, 2, 1];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[3, 2, 1]);
      });

      test('test6', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[6, 1, 2, 3, 4, 7, 5];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[6, 1, 2, 3, 4, 7, 5]);
      });
    });

    group('Test mergeChanges function remove simple', () {
      test('test1', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[1];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2]);
      });

      test('test2', () {
        final List<int> x = <int>[1, 2];
        final List<int> y = <int>[2];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2]);
      });

      test('test-4b3fewfesdvcw', () {
        final List<int> x = <int>[1, 2, 3, 4];
        final List<int> y = <int>[2, 3, 4];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3, 4]);
      });

      test('test4', () {
        final List<int> x = <int>[1, 2, 3, 4];
        final List<int> y = <int>[1, 2, 3];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3, 4]);
      });

      test('test5', () {
        final List<int> x = <int>[1, 2, 3, 4, 5, 6];
        final List<int> y = <int>[2, 3, 4, 5];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3, 4, 5, 6]);
      });
    });

    group('Test mergeChanges function remove complicated', () {
      test('test1', () {
        final List<int> x = <int>[1, 2, 3];
        final List<int> y = <int>[1, 3];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3]);
      });

      test('test-ht4g2dcf223btgr', () {
        final List<int> x = <int>[1, 2, 3, 4];
        final List<int> y = <int>[2, 4];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3, 4]);
      });

      test('test3', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[4, 5];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3, 4, 5]);
      });

      test('test4', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[1, 2];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3, 4, 5]);
      });

      test('test5', () {
        final List<int> x = <int>[1, 2, 3, 4, 5];
        final List<int> y = <int>[2, 4];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 3, 4, 5]);
      });
    });

    group('Test mergeChanges function all', () {
      test('test-j6g3g4f3grfd2e31', () {
        final List<int> x = <int>[1, 2, 3, 4, 5, 6, 7, 8];
        final List<int> y = <int>[2, 9, 10, 3, 4, 6, 11, 12];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 2, 9, 10, 3, 4, 5, 6, 11, 12, 7, 8]);
      });

      test('test-n5644g334f2', () {
        final List<int> x = <int>[5, 4, 2, 9];
        final List<int> y = <int>[3, 8, 5, 4];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[3, 8, 5, 4, 2, 9]);
      });

      test('test-t4g3f2bt4r3', () {
        final List<int> x = <int>[1, 4, 0, 7, 3, 8, 6, 2, 9, 5];
        final List<int> y = <int>[4, 7, 0, 5];

        final List<int> rez = mergeChanges(x, y);

        expect(rez, <int>[1, 4, 7, 0, 3, 8, 6, 2, 9, 5]);
      });
    });
  });
}
