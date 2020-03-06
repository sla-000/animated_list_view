import 'package:flutter/material.dart';

void _log(String Function() buildMessage) {
//  debugPrint('ShowAnimated/${buildMessage()}');
}

typedef CustomAnimation = Widget Function({
  @required Widget child,
  @required Animation<double> animation,
  @required bool appearing,
});

class ShowAnimated extends StatefulWidget {
  const ShowAnimated({
    Key key,
    @required this.child,
    this.onAnimationComplete,
    this.appearing = true,
    Duration duration,
    @required this.customAnimation,
  })  : _duration = duration ?? const Duration(milliseconds: 500),
        super(key: key);

  final Widget child;
  final bool appearing;
  final void Function() onAnimationComplete;
  final Duration _duration;
  final CustomAnimation customAnimation;

  @override
  _ShowAnimatedState createState() => _ShowAnimatedState();
}

class _ShowAnimatedState extends State<ShowAnimated>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _log(() => 'initState: key=${widget.child.key}');

    _animationController =
        AnimationController(vsync: this, duration: widget._duration);

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _startAnimation();
  }

  @override
  void didUpdateWidget(ShowAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    _log(() =>
        'didUpdateWidget: key=${widget.child.key}, appearing=${widget.appearing}');

    _startAnimation();
  }

  void _startAnimation() {
    if (widget.appearing) {
      _animationController.forward(from: 0.0).whenCompleteOrCancel(() {
        widget.onAnimationComplete?.call();
      });
    } else {
      _animationController.reverse(from: 1.0).whenCompleteOrCancel(() {
        widget.onAnimationComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.customAnimation(
        child: widget.child,
        animation: _animation,
        appearing: widget.appearing);
  }
}
