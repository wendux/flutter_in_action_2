import 'package:flutter/material.dart' hide Page;
import '../common.dart';

class StackEventTest extends StatelessWidget {
  const StackEventTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListPage(children: [
      Page('事件共享', const StickerTest()),
      Page('水印', const _WaterMarkTest(), padding: false),
      Page('HitTestBehaviorTest', const HitTestBehaviorTest(),padding: false),
      Page('所有子节点都可以响应事件', const AllChildrenCanResponseEvent()),
      Page('手势', const GestureHitTestBlockerTest()),
    ]);
  }
}

class HitTestBehaviorTest extends StatelessWidget {
  const HitTestBehaviorTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('点击屏幕空白区域');
    return Stack(
      children: [
        wChild(1),
        wChild(2),
      ],
    );
  }

  Widget wChild(int index) {
    return Listener(
      //behavior: HitTestBehavior.opaque, // 放开此行，点击只会输出 2
      behavior: HitTestBehavior.translucent, // 放开此行，点击会同时输出 2 和1
      onPointerDown: (e) => print(index),
      child: const SizedBox.expand(),
    );
  }
}

class AllChildrenCanResponseEvent extends StatelessWidget {
  const AllChildrenCanResponseEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // IgnorePointer(child: wChild(1, 200)),
        // IgnorePointer(child: wChild(2, 200)),
        HitTestBlocker(child: wChild(1, 200)),
        HitTestBlocker(child: wChild(2, 200)),
      ],
    );
  }

  Widget wChild(int index, double size) {
    return Listener(
      onPointerDown: (e) => print(index),
      child: Container(
        width: size,
        height: size,
        color: Colors.grey,
      ),
    );
  }
}

class _WaterMarkTest extends StatelessWidget {
  const _WaterMarkTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        wChild(1, Colors.white, 200),
        IgnorePointer(
          child: WaterMark(
            painter: TextWaterMarkPainter(text: 'wendux', rotate: -20),
          ),
        ),
      ],
    );
  }

  Widget wChild(int index, color, double size) {
    return Listener(
      onPointerDown: (e) => print(index),
      child: Container(
        width: size,
        height: size,
        color: Colors.grey,
      ),
    );
  }
}

class StickerTest extends StatelessWidget {
  const StickerTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        wChild(1, Colors.blue, 200),
        HitTestBlocker(child: wChild(2, Colors.red, 100)),
      ],
    );
  }

  Widget wChild(int index, color, double size) {
    return Listener(
      onPointerDown: (e) => print('$index'),
      child: Container(
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}

class GestureHitTestBlockerTest extends StatelessWidget {
  const GestureHitTestBlockerTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HitTestBlocker(child: wChild(1, 200)),
        HitTestBlocker(child: wChild(2, 200)),
      ],
    );
  }

  Widget wChild(int index, double size) {
    return GestureDetector(
      onTap: () => print('$index'),
      child: Container(
        width: size,
        height: size,
        color: Colors.grey,
      ),
    );
  }
}

