import 'package:flutter/material.dart';

class AnimatedSwitcherRoute extends StatefulWidget {
  const AnimatedSwitcherRoute({Key? key}) : super(key: key);

  @override
  _AnimatedSwitcherRouteState createState() => _AnimatedSwitcherRouteState();
}

class _AnimatedSwitcherRouteState extends State<AnimatedSwitcherRoute> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // 旧页面屏幕中向左侧平移退出，新页面重屏幕右侧平移进入
                var tween = Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: const Offset(0, 0),
                );
                return MySlideTransition(
                  child: child,
                  position: tween.animate(animation),
                );
              },
              child: Text(
                "$_count",
                key: ValueKey<int>(_count),
                textScaleFactor: 3,
              ),
            ),
          ),
          ClipRect(child: wSwitcher(AxisDirection.down)),
          ClipRect(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: wSwitcher(AxisDirection.down),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ClipRect(child: wSwitcher(AxisDirection.left)),
          ),
          ClipRect(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: wSwitcher(AxisDirection.left),
            ),
          ),
          ElevatedButton(
            child: const Text(
              'Increment',
            ),
            onPressed: () {
              setState(() {
                _count += 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget wSwitcher(AxisDirection direction) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransitionX(
          child: FadeTransition(child: child, opacity: animation),
          direction: direction,
          position: animation,
        );
      },
      child: Text(
        "$_count",
        key: ValueKey<int>(_count),
        textScaleFactor: 3,
      ),
    );
  }
}

class MySlideTransition extends AnimatedWidget {
  const MySlideTransition({
    Key? key,
    required Animation<Offset> position,
    this.transformHitTests = true,
    required this.child,
  }) : super(key: key, listenable: position);

  final bool transformHitTests;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final position = listenable as Animation<Offset>;
    Offset offset = position.value;
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class SlideTransitionX extends AnimatedWidget {
  SlideTransitionX({
    Key? key,
    required Animation<double> position,
    this.transformHitTests = true,
    this.direction = AxisDirection.down,
    required this.child,
  }) : super(key: key, listenable: position) {
    switch (direction) {
      case AxisDirection.up:
        _tween = Tween(begin: const Offset(0, 1), end: const Offset(0, 0));
        break;
      case AxisDirection.right:
        _tween = Tween(begin: const Offset(-1, 0), end: const Offset(0, 0));
        break;
      case AxisDirection.down:
        _tween = Tween(begin: const Offset(0, -1), end: const Offset(0, 0));
        break;
      case AxisDirection.left:
        _tween = Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
        break;
    }
  }

  final bool transformHitTests;

  final Widget child;

  final AxisDirection direction;

  late final Tween<Offset> _tween;

  @override
  Widget build(BuildContext context) {
    final position = listenable as Animation<double>;
    Offset offset = _tween.evaluate(position);
    if (position.status == AnimationStatus.reverse) {
      switch (direction) {
        case AxisDirection.up:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.right:
          offset = Offset(-offset.dx, offset.dy);
          break;
        case AxisDirection.down:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.left:
          offset = Offset(-offset.dx, offset.dy);
          break;
      }
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}
