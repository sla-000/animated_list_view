import 'package:animated_list_view/animated_list_view.dart';
import 'package:example/add_delete_logic.dart';
import 'package:example/item.dart';
import 'package:example/one_item_widget.dart';
import 'package:flutter/material.dart';

class VerticalAnimatedListWidget extends StatefulWidget {
  const VerticalAnimatedListWidget({
    Key key,
  }) : super(key: key);

  @override
  _VerticalAnimatedListWidgetState createState() =>
      _VerticalAnimatedListWidgetState();
}

class _VerticalAnimatedListWidgetState
    extends State<VerticalAnimatedListWidget> {
  final List<Item> _items = <Item>[];
  List<Widget> _widgets;
  final AddDeleteLogic addDelete = AddDeleteLogic(tilesCounter: 100);

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
              vertical: true,
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
      scrollDirection: Axis.vertical,
      children: _widgets,
      customAnimation: _customAnimation,
    );
  }

  Widget _customAnimation({
    @required Widget child,
    @required Animation<double> animation,
    @required bool appearing,
  }) {
    if (appearing) {
      final Animation<double> curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

      return SizeTransition(
        sizeFactor: curvedAnimation,
        axis: Axis.vertical,
        child: child,
      );
    } else {
      final Animation<double> sizeAnimation =
          CurvedAnimation(parent: animation, curve: Curves.bounceOut.flipped);

      final Animation<double> opacityAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInExpo.flipped);

      return SizeTransition(
        sizeFactor: sizeAnimation,
        axis: Axis.vertical,
        child: Opacity(
          opacity: opacityAnimation.value,
          child: child,
        ),
      );
    }
  }
}
