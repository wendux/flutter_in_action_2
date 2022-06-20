import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class CustomCheckbox extends LeafRenderObjectWidget {
  const CustomCheckbox({
    Key? key,
    this.strokeWidth = 2.0,
    this.value = false,
    this.strokeColor = Colors.white,
    this.fillColor = Colors.blue,
    this.radius = 2.0,
    this.onChanged,
  }) : super(key: key);

  final double strokeWidth; // “勾”的线条宽度
  final Color strokeColor; // “勾”的线条宽度
  final Color? fillColor; // 填充颜色
  final bool value; //选中状态
  final double radius; // 圆角
  final ValueChanged<bool>? onChanged; // 选中状态发生改变后的回调

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomCheckbox(
      strokeWidth,
      strokeColor,
      fillColor ?? Theme.of(context).primaryColor,
      value,
      radius,
      onChanged,
    );
  }

  @override
  void updateRenderObject(context, RenderCustomCheckbox renderObject) {
    if (renderObject.value != value) {
      renderObject.animationStatus =
          value ? AnimationStatus.forward : AnimationStatus.reverse;
    }
    renderObject
      ..strokeWidth = strokeWidth
      ..strokeColor = strokeColor
      ..fillColor = fillColor ?? Theme.of(context).primaryColor
      ..radius = radius
      ..value = value
      ..onChanged = onChanged;
  }
}

class RenderCustomCheckbox extends RenderBox {
  bool value;
  int pointerId = -1;
  double strokeWidth;
  Color strokeColor;
  Color fillColor;
  double progress = 1;
  double radius;
  ValueChanged<bool>? onChanged;

  int? _lastTimeStamp;

  Duration get duration => const Duration(milliseconds: 150);

  AnimationStatus _animationStatus = AnimationStatus.completed;

  set animationStatus(AnimationStatus v) {
    if (_animationStatus != v) {
      markNeedsPaint();
    }
    _animationStatus = v;
  }

  //背景动画时长占比（背景动画要在前40%的时间内执行完毕，之后执行打勾动画）
  final double bgAnimationInterval = .4;

  RenderCustomCheckbox(this.strokeWidth, this.strokeColor, this.fillColor,
      this.value, this.radius, this.onChanged)
      : progress = value ? 1 : 0;

  @override
  void paint(PaintingContext context, Offset offset) {
    Rect rect = offset & size;
    // 将绘制分为背景（矩形）和 前景（打勾）两部分，先画背景，再绘制'勾'
    _drawBackground(context, rect);
    _drawCheckMark(context, rect);
    // 调度动画
    _scheduleAnimation();
  }

  void _drawBackground(PaintingContext context, Rect rect) {
    Color color = value ? fillColor : Colors.grey;
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill //填充
      ..strokeWidth
      ..color = color;

    final outer = RRect.fromRectXY(rect, radius, radius);
    var rects = [
      rect.inflate(-strokeWidth),
      Rect.fromCenter(center: rect.center, width: 0, height: 0)
    ];

    var rectProgress = Rect.lerp(
      rects[0],
      rects[1],
      min(progress, bgAnimationInterval) / bgAnimationInterval,
    )!;

    final inner = RRect.fromRectXY(rectProgress, 0, 0);
    // 画背景
    context.canvas.drawDRRect(outer, inner, paint);
  }

  //画 "勾"
  void _drawCheckMark(PaintingContext context, Rect rect) {
    if (progress > bgAnimationInterval) {
      var secondOffset = Offset(
        rect.left + rect.width / 2.5,
        rect.bottom - rect.height / 4,
      );
      var lastOffset = Offset(
        rect.right - rect.width / 6,
        rect.top + rect.height / 4,
      );

      Offset _lastOffset = Offset.lerp(
        secondOffset,
        lastOffset,
        (progress - bgAnimationInterval) / (1 - bgAnimationInterval),
      )!;

      final path = Path()
        ..moveTo(rect.left + rect.width / 7, rect.top + rect.height / 2)
        ..lineTo(secondOffset.dx, secondOffset.dy)
        ..lineTo(_lastOffset.dx, _lastOffset.dy);

      final paint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..color = strokeColor
        ..strokeWidth = strokeWidth;

      context.canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    }
  }

  void _scheduleAnimation() {
    if (_animationStatus != AnimationStatus.completed) {
      // 需要在Flutter 当前frame 结束之前再执行，因为不能在绘制过程中又将组件标记为需要重绘
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (_lastTimeStamp != null) {
          double delta = (timeStamp.inMilliseconds - _lastTimeStamp!) /
              duration.inMilliseconds;
          // 如果是反向动画，则 progress值要逐渐减小
          if (_animationStatus == AnimationStatus.reverse) {
            delta = -delta;
          }
          //更新动画进度
          progress = progress + delta;

          if (progress >= 1 || progress <= 0) {
            //动画执行结束
            _animationStatus = AnimationStatus.completed;
            progress = progress.clamp(0, 1);
          }
        }
        //标记为需要重绘
        markNeedsPaint();
        _lastTimeStamp = timeStamp.inMilliseconds;
      });
    } else {
      _lastTimeStamp = null;
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(
      constraints.isTight ? Size.infinite : const Size(25, 25),
    );
  }

  // 必须置为true，否则不可以响应事件
  @override
  bool hitTestSelf(Offset position) => true;

  // 只有通过点击测试的组件才会调用本方法
  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event.down) {
      pointerId = event.pointer;
    } else if (pointerId == event.pointer) {
      // 判断手指抬起时是在组件范围内的话才触发onChange
      if(size.contains(event.localPosition)) {
        onChanged?.call(!value);
      }
    }
  }
}
