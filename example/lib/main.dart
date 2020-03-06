import 'dart:math';

import 'package:example/horizontal_list.dart';
import 'package:example/item.dart';
import 'package:example/vertical_list.dart';
import 'package:flutter/material.dart';

void _log(String Function() buildMessage) {
  debugPrint('MyApp/${buildMessage()}');
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> _verticalItems;
  List<Item> _horizontalItems;

  @override
  void initState() {
    super.initState();

    _verticalItems = _getRandomItems();
    _horizontalItems = _getRandomItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test AnimatedListView'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 250,
                child: Scrollbar(
                  child: HorizontalAnimatedListWidget(items: _horizontalItems),
                ),
              ),
              Container(
                height: 8,
                color: Theme.of(context).dividerColor,
              ),
              Expanded(
                child: Scrollbar(
                  child: VerticalAnimatedListWidget(items: _verticalItems),
                ),
              ),
            ],
          ),
          Positioned(
            top: 55,
            left: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () {
                _horizontalItems = _getRandomItems();
                setState(() {});
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 55,
            child: FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () {
                _verticalItems = _getRandomItems();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Item> _getRandomItems() {
    final List<Item> rez = <Item>[];

    final List<int> availableNumbers = <int>[];
    for (int q = 0; q < 10; ++q) {
      availableNumbers.add(q);
    }

    const int kMaxItems = 10;
    const int kMinItems = 3;
    final int itemsNumber =
        Random.secure().nextInt(kMaxItems - kMinItems) + kMinItems;

    for (int index = 0; index < itemsNumber; ++index) {
      final int index = Random.secure().nextInt(availableNumbers.length);
      final int val = availableNumbers[index];
      availableNumbers.remove(val);

      rez.add(Item(val));
    }

    _log(() => '_getRandomItems: rez=$rez');

    return rez;
  }
}
