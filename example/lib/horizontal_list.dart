import 'package:animated_list_view/animated_list_view.dart';
import 'package:example/add_delete_logic.dart';
import 'package:example/item.dart';
import 'package:example/one_item_widget.dart';
import 'package:flutter/material.dart';

class HorizontalAnimatedListWidget extends StatefulWidget {
  const HorizontalAnimatedListWidget({
    Key key,
  }) : super(key: key);

  @override
  _HorizontalAnimatedListWidgetState createState() =>
      _HorizontalAnimatedListWidgetState();
}

class _HorizontalAnimatedListWidgetState
    extends State<HorizontalAnimatedListWidget> {
  final List<Item> _items = <Item>[];
  List<Widget> _widgets;
  final AddDeleteLogic addDelete = AddDeleteLogic();

  @override
  void initState() {
    super.initState();

    for (int index = 0; index < 10; ++index) {
      _items.add(Item(addDelete.getNextNumber()));
    }
  }

  @override
  Widget build(BuildContext context) {
    _widgets = _items
        .map((Item item) => OneItemWidget(
              key: ValueKey<int>(item.number),
              number: item.number,
              color: item.color,
              vertical: false,
              onDelete: () {
                addDelete.delete(_items, item.number);
                setState(() {});
              },
              onAddAfter: () {
                addDelete.addAfter(_items, item.number);
                setState(() {});
              },
              onAddBefore: () {
                addDelete.addBefore(_items, item.number);
                setState(() {});
              },
            ))
        .toList();

    return AnimatedListView(
      scrollDirection: Axis.horizontal,
      children: _widgets,
      duration: const Duration(milliseconds: 1500),
    );
  }
}
