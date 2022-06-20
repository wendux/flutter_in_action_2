import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class CustomCenter1 extends SingleChildRenderObjectWidget {
  const CustomCenter1({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomCenter1();
  }
}

//RenderShiftedBox a;
class RenderCustomCenter1 extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout() {
    //子组件进行layout，随后获取它的size
    child!.layout(
      constraints.loosen(),
      parentUsesSize: true, // 因为我们接下来要使用child的size,所以不能为false
    );

    size = constraints.constrain(Size(
      constraints.maxWidth == double.infinity
          ? child!.size.width
          : double.infinity,
      constraints.maxHeight == double.infinity
          ? child!.size.height
          : double.infinity,
    ));

    BoxParentData parentData = child!.parentData as BoxParentData;
    // 居中显示
    parentData.offset = ((size - child!.size) as Offset) / 2;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    return result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset? transformed) {
        return child!.hitTest(result, position: transformed!);
      },
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    BoxParentData parentData = child!.parentData as BoxParentData;
    // 绘制子组件
    context.paintChild(child!, offset + parentData.offset);
  }
}

class CustomCenter2 extends SingleChildRenderObjectWidget {
  const CustomCenter2({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomCenter2();
  }
}

class RenderCustomCenter2 extends RenderShiftedBox {
  RenderCustomCenter2({RenderBox? child}) : super(child);

  @override
  void performLayout() {
    //子组件进行layout，随后获取它的size
    child!.layout(
      constraints.loosen(),
      parentUsesSize: true, // 因为我们接下来要使用child的size,所以不能为false
    );
    // 防止size宽高无穷大
    size = constraints.constrain(Size(
      constraints.maxWidth == double.infinity
          ? child!.size.width
          : double.infinity,
      constraints.maxHeight == double.infinity
          ? child!.size.height
          : double.infinity,
    ));

    BoxParentData parentData = child!.parentData as BoxParentData;
    // 居中显示
    parentData.offset = ((size - child!.size) as Offset) / 2;
  }
}

/// 思考题：能否使用CustomSingleChildLayout 来实现Center呢

class MyCenterRoute extends StatefulWidget {
  const MyCenterRoute({Key? key}) : super(key: key);

  @override
  State<MyCenterRoute> createState() => _MyCenterRouteState();
}

class _MyCenterRouteState extends State<MyCenterRoute> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCenter1(
          child: GestureDetector(
            onTap: () {
              setState(() {
                print("tap");
              });
            },
            child: Container(width: 50, height: 50, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
