import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class AccurateSizedBox extends SingleChildRenderObjectWidget {
  const AccurateSizedBox({
    Key? key,
    this.width = 0,
    this.height = 0,
    required Widget child,
  }) : super(key: key, child: child);

  final double width;
  final double height;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAccurateSizedBox(width, height);
  }

  @override
  void updateRenderObject(context, RenderAccurateSizedBox renderObject) {
    renderObject
      ..width = width
      ..height = height;
  }
}

class RenderAccurateSizedBox extends RenderProxyBoxWithHitTestBehavior {
  RenderAccurateSizedBox(this.width, this.height);

  double width;
  double height;

  // 当前组件的大小只取决于父组件传递的约束
  @override
  bool get sizedByParent => true;


  // performResize 中会调用
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    //设置当前元素宽高，遵守父组件的约束
    return constraints.constrain(Size(width, height));
  }

  // @override
  // void performResize() {
  //   // default behavior for subclasses that have sizedByParent = true
  //   size = computeDryLayout(constraints);
  //   assert(size.isFinite);
  // }

  @override
  void performLayout() {
    child!.layout(
      BoxConstraints.tight(
          Size(min(size.width, width), min(size.height, height))),
      // 父容器是固定大小，子元素大小改变时不影响父元素
      // parentUseSize为false时，子组件的布局边界会是它自身，子组件布局发生变化后不会影响当前组件
      parentUsesSize: false,
    );
  }
}

class AccurateSizedBoxRoute extends StatelessWidget {
  const AccurateSizedBoxRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: () => print("tap"),
      child: Container(width: 300, height: 300, color: Colors.red),
    );
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tight(Size(100, 100)),
          child: SizedBox(
            width: 50,
            height: 50,
            child: child,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(100, 100)),
            child: AccurateSizedBox(
              width: 50,
              height: 50,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
