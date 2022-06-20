import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';


class CustomRotatedBoxTest extends StatelessWidget {
  const CustomRotatedBoxTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("tt");

    // return Center(
    //   child: CustomRotatedBox(
    //     child: Text(
    //       "A",
    //       textScaleFactor: 5,
    //     ),
    //   ),
    // );


    return const Center(
      child:  RepaintBoundary(
        child: Text(
          "A",
          textScaleFactor: 5,
        ),
      ),
    );
    
    // return const Center(
    //   child: const RotatedBox(
    //     quarterTurns: 2,
    //     child: const CustomRotatedBox(
    //       child: Center(
    //         child: Text(
    //           "A",
    //           textScaleFactor: 5,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class CustomRotatedBox extends SingleChildRenderObjectWidget {
  const CustomRotatedBox({Key? key, Widget? child}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRenderRotatedBox();
  }
}

// class CustomRenderRotatedBox extends RenderBox
//     with RenderObjectWithChildMixin<RenderBox> {
//   Matrix4? _paintTransform;
//
//   @override
//   void performLayout() {
//     _paintTransform = null;
//     if (child != null) {
//       child!.layout(constraints, parentUsesSize: true);
//       size = child!.size;
//       //根据子组件大小计算出旋转矩阵
//       _paintTransform = Matrix4.identity()
//         ..translate(size.width / 2.0, size.height / 2.0)
//         ..rotateZ(math.pi / 2)
//         ..translate(-child!.size.width / 2.0, -child!.size.height / 2.0);
//     } else {
//       size = constraints.smallest;
//     }
//   }
//
//   final LayerHandle<TransformLayer> _transformLayer =
//       LayerHandle<TransformLayer>();
//
//   void _paintChild(PaintingContext context, Offset offset) {
//     print("paint child");
//     context.paintChild(child!, offset);
//   }
//
//   @override
//   void paint(PaintingContext context, Offset offset) {
//     if (child != null) {
//       _transformLayer.layer = context.pushTransform(
//         needsCompositing, // pipelineOwner.flushCompositingBits(); 执行后这个值就能确定
//         offset,
//         _paintTransform!,
//         _paintChild,
//         oldLayer: _transformLayer.layer,
//       );
//     } else {
//       _transformLayer.layer = null;
//     }
//   }
//
//   @override
//   void dispose() {
//     _transformLayer.layer = null;
//     super.dispose();
//   }
//
//   @override
//   void applyPaintTransform(RenderBox child, Matrix4 transform) {
//     if (_paintTransform != null) transform.multiply(_paintTransform!);
//     super.applyPaintTransform(child, transform);
//   }
//
//   @override
//   bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
//     assert(_paintTransform != null || debugNeedsLayout || child == null);
//     if (child == null || _paintTransform == null) return false;
//     return result.addWithPaintTransform(
//       transform: _paintTransform,
//       position: position,
//       hitTest: (BoxHitTestResult result, Offset? position) {
//         return child!.hitTest(result, position: position!);
//       },
//     );
//   }
// }

class CustomRenderRotatedBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  Matrix4? _paintTransform;

  @override
  void performLayout() {
    _paintTransform = null;
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
      //根据子组件大小计算出旋转矩阵
      _paintTransform = Matrix4.identity()
        ..translate(size.width / 2.0, size.height / 2.0)
        ..rotateZ(math.pi / 2)
        ..translate(-child!.size.width / 2.0, -child!.size.height / 2.0);
    } else {
      size = constraints.smallest;
    }
  }

  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>(TransformLayer());

  void _paintChild(PaintingContext context, Offset offset) {
    print("paint child");
    context.paintChild(child!, offset);
  }


  //子树中递归查找是否存在绘制边界
  needCompositing() {
    bool result = false;
    _visit(RenderObject child) {
      if (child.isRepaintBoundary) {
        result = true;
        return ;
      } else {
        child.visitChildren(_visit);
      }
    }
    visitChildren(_visit);
    return result;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.pushTransform(
        needCompositing(),
        offset,
        _paintTransform!,
        _paintChild,
        oldLayer: _transformLayer.layer,
      );
    } else {
      _transformLayer.layer = null;
    }
  }


  @override
  void dispose() {
    _transformLayer.layer = null;
    super.dispose();
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    if (_paintTransform != null) transform.multiply(_paintTransform!);
    super.applyPaintTransform(child, transform);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    assert(_paintTransform != null || debugNeedsLayout || child == null);
    if (child == null || _paintTransform == null) return false;
    return result.addWithPaintTransform(
      transform: _paintTransform,
      position: position,
      hitTest: (BoxHitTestResult result, Offset? position) {
        return child!.hitTest(result, position: position!);
      },
    );
  }
}

// class CustomRotatedBox2 extends SingleChildRenderObjectWidget {
//   CustomRotatedBox2({Key? key, Widget? child}) : super(key: key, child: child);
//
//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return CustomRenderRotatedBox2();
//   }
// }
//
// class CustomRenderRotatedBox2 extends CustomRenderRotatedBox{
//   @override
//   needCompositing() => true;
//   //
//   // @override
//   // bool get alwaysNeedsCompositing => true;
// }
