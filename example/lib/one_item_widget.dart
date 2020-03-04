import 'package:flutter/material.dart';

class OneItemWidget extends StatelessWidget {
  const OneItemWidget({
    Key key,
    @required this.number,
    @required this.color,
    @required this.onAddBefore,
    @required this.onAddAfter,
    @required this.onDelete,
    this.vertical = true,
  }) : super(key: key);

  final int number;
  final Color color;
  final bool vertical;

  final void Function() onAddBefore;
  final void Function() onAddAfter;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? double.infinity : 120,
      height: vertical ? 100 : double.infinity,
      color: color,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text("Tile #$number"),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.plus_one),
              onPressed: onAddBefore,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: onDelete,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.plus_one),
              onPressed: onAddAfter,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
