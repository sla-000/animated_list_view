import 'package:example/item.dart';

class AddDeleteLogic {
  AddDeleteLogic({
    this.tilesCounter = 10,
  });

  int tilesCounter;

  int getNextNumber() {
    return tilesCounter++;
  }

  void addBefore(List<Item> lst, int currentNumber) {
    final next = getNextNumber();

    final itemIndex = lst.indexWhere((item) => item.number == currentNumber);

    if (itemIndex == -1) {
      return;
    }

    lst.insert(
      itemIndex,
      Item(next),
    );
  }

  void addAfter(List<Item> lst, int currentNumber) {
    final next = getNextNumber();

    final itemIndex = lst.indexWhere((item) => item.number == currentNumber);

    if (itemIndex == -1) {
      return;
    }

    lst.insert(
      itemIndex + 1,
      Item(next),
    );
  }

  void delete(List<Item> lst, int currentNumber) {
    final item = lst.firstWhere((item) => item.number == currentNumber,
        orElse: () => null);

    if (item != null) {
      lst.remove(item);
    }
  }
}
