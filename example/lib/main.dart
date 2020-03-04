import 'package:example/horizontal_list.dart';
import 'package:example/vertical_list.dart';
import 'package:flutter/material.dart';

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test AnimatedListView'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 250,
            child: const Scrollbar(
              child: HorizontalAnimatedListWidget(),
            ),
          ),
          Container(
            height: 8,
            color: Theme.of(context).dividerColor,
          ),
          const Expanded(
            child: Scrollbar(
              child: VerticalAnimatedListWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
