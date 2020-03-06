library animated_list_view;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'utils/merge.dart';
import 'widgets/animated_widget.dart';

void _log(String Function() buildMessage) {
  debugPrint('AnimatedListView/${buildMessage()}');
}

class AnimatedListView extends StatefulWidget {
  const AnimatedListView({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.children = const <Widget>[],
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.customAnimation,
    this.duration,
  }) : super(key: key);

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double cacheExtent;
  final List<Widget> children;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final CustomAnimation customAnimation;
  final Duration duration;

  @override
  _AnimatedListViewState createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView> {
  List<Widget> _currentChildren;
  final List<Key> _keysToRemove = <Key>[];
  final List<Key> _keysToAdd = <Key>[];
  CustomAnimation _customAnimation;
  List<Widget> _animatedChildren = <Widget>[];

  @override
  void initState() {
    super.initState();

    _customAnimation = widget.customAnimation ?? _defaultAnimation;

    _log(() => 'initState: children=${widget.children.map((Widget widget) {
          return widget.key;
        }).toList(growable: false)}');

    _currentChildren = widget.children;
    _animatedChildren = _warpToAnimation(_currentChildren);
  }

  List<Widget> _warpToAnimation(List<Widget> children) => children
      .map((Widget child) => _buildAnimated(child))
      .toList(growable: false);

  Widget _defaultAnimation({
    @required Widget child,
    @required Animation<double> animation,
    @required bool appearing,
  }) {
    final CurvedAnimation _curvedAnimation = appearing
        ? CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)
        : CurvedAnimation(parent: animation, curve: Curves.easeInCubic.flipped);

    return SizeTransition(
      sizeFactor: _curvedAnimation,
      axis: widget.scrollDirection,
      child: child,
    );
  }

  @override
  void didUpdateWidget(AnimatedListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _log(() => 'didUpdateWidget: '
        'was=${_currentChildren.map((Widget widget) {
          return widget.key;
        }).toList(growable: false)}, '
        'new=${widget.children.map((Widget widget) {
          return widget.key;
        }).toList(growable: false)}');

    final List<Widget> _widgetsToRemove = <Widget>[];
    final List<Widget> _widgetsToAdd = <Widget>[];

    _currentChildren = mergeChanges<Widget>(
      _currentChildren,
      widget.children,
      toRemove: _widgetsToRemove,
      toAdd: _widgetsToAdd,
      isEqual: (Widget a, Widget b) => a.key == b.key,
    );
    _animatedChildren = _warpToAnimation(_currentChildren);

    for (int q = 0; q < _widgetsToRemove.length; ++q) {
      final Key key = _widgetsToRemove[q].key;

      if (!_keysToRemove.contains(key)) {
        _keysToRemove.add(key);
      }
    }

    for (int q = 0; q < _widgetsToAdd.length; ++q) {
      final Key key = _widgetsToAdd[q].key;

      if (!_keysToAdd.contains(key)) {
        _keysToAdd.add(key);
      }
    }

    _log(() =>
        'didUpdateWidget: New _currentChildren=${_currentChildren.map((Widget widget) {
          return widget.key;
        }).toList(growable: false)}');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: widget.key,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemExtent: widget.itemExtent,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      children: _animatedChildren,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
    );
  }

  Widget _buildAnimated(Widget child) {
    final bool mustDelete = _keysToRemove.contains(child.key);
    final bool mustAdd = _keysToAdd.contains(child.key);

    if (mustDelete) {
      return ShowAnimated(
        key: child.key,
        customAnimation: _customAnimation,
        duration: widget.duration,
        appearing: false,
        onAnimationComplete: () {
          _currentChildren.remove(child);
          _keysToRemove.remove(child.key);
          _animatedChildren = _warpToAnimation(_currentChildren);
          _log(() => '_buildAnimated: Removed child=${child.key}');
          setState(() {});
        },
        child: child,
      );
    } else if (mustAdd) {
      return ShowAnimated(
        key: child.key,
        customAnimation: _customAnimation,
        duration: widget.duration,
        appearing: true,
        onAnimationComplete: () {
          _keysToAdd.remove(child.key);
          _animatedChildren = _warpToAnimation(_currentChildren);
          _log(() => '_buildAnimated: Added child=${child.key}');
          setState(() {});
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}
