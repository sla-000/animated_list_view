import 'package:animated_list_view/animated_list_view.dart';
import 'package:example/add_delete_logic.dart';
import 'package:example/item.dart';
import 'package:example/one_item_widget.dart';
import 'package:flutter/material.dart';

class VerticalAnimatedListWidget extends StatefulWidget {
  const VerticalAnimatedListWidget({
    Key key,
    @required this.items,
  }) : super(key: key);

  final List<Item> items;

  @override
  _VerticalAnimatedListWidgetState createState() =>
      _VerticalAnimatedListWidgetState();
}

class _VerticalAnimatedListWidgetState
    extends State<VerticalAnimatedListWidget> {
  List<Widget> _widgets;
  final AddDeleteLogic addDelete = AddDeleteLogic();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _widgets = widget.items
        .map((Item item) => OneItemWidget(
              key: ValueKey<int>(item.number),
              number: item.number,
              color: item.color,
              vertical: true,
              onDelete: () {
                addDelete.delete(widget.items, item.number);
                setState(() {});
              },
              onAddAfter: () {
                addDelete.addAfter(widget.items, item.number);
                setState(() {});
              },
              onAddBefore: () {
                addDelete.addBefore(widget.items, item.number);
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
