import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LeftRightBox extends MultiChildRenderObjectWidget {
  LeftRightBox({
    Key? key,
    required List<Widget> children,
  })  : assert(children.length == 2, "只能传两个children"),
        super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLeftRight();
  }
}

class LeftRightParentData extends ContainerBoxParentData<RenderBox> {}

class RenderLeftRight extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, LeftRightParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, LeftRightParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! LeftRightParentData)
      child.parentData = LeftRightParentData();
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    RenderBox leftChild = firstChild!;
    LeftRightParentData childParentData =
        leftChild.parentData! as LeftRightParentData;
    RenderBox rightChild = childParentData.nextSibling!;

    //我们限制右孩子宽度不超过总宽度一半
    rightChild.layout(
      constraints.copyWith(maxWidth: constraints.maxWidth / 2),
      parentUsesSize: true,
    );

    //调整右子节点的offset
    childParentData = rightChild.parentData! as LeftRightParentData;
    childParentData.offset = Offset(
      constraints.maxWidth - rightChild.size.width,
      0,
    );

    print(constraints.maxWidth - rightChild.size.width);

    // layout left child
    // 左子节点的offset默认为（0，0），为了确保左子节点始终能显示，我们不修改它
    leftChild.layout(
      //左侧剩余的最大宽度
      constraints.copyWith(
        maxWidth: constraints.maxWidth - rightChild.size.width,
      ),
      parentUsesSize: true,
    );

    //设置容器的size
    size = Size(
      constraints.maxWidth,
      max(leftChild.size.height, rightChild.size.height),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

class LeftRightBoxTestRoute extends StatelessWidget {
  const LeftRightBoxTestRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LeftRightBox(children: [
      Text("国漫精选"),
      GestureDetector(onTap: () => print("点击更多"), child: Text("更多》")),
    ]);
  }
}
