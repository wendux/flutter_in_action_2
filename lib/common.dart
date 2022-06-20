import 'dart:math';
import 'package:flutter/material.dart';
export 'widgets/index.dart';
import 'package:flukit/flukit.dart';

final logEmitter = ValueNotifier<LogInfo?>(null);

void drawChessboard(Canvas canvas, Rect rect) {
  //棋盘背景
  var paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill //填充
    ..color = const Color(0xFFDCC48C);
  canvas.drawRect(rect, paint);

  //画棋盘网格
  paint
    ..style = PaintingStyle.stroke //线
    ..color = Colors.black38
    ..strokeWidth = 1.0;

  //画横线
  for (int i = 0; i <= 15; ++i) {
    double dy = rect.top + rect.height / 15 * i;
    canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
  }

  for (int i = 0; i <= 15; ++i) {
    double dx = rect.left + rect.width / 15 * i;
    canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
  }
}

//画棋子
void drawPieces(Canvas canvas, Rect rect) {
  double eWidth = rect.width / 15;
  double eHeight = rect.height / 15;
  //画一个黑子
  var paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;
  //画一个黑子
  canvas.drawCircle(
    Offset(rect.center.dx - eWidth / 2, rect.center.dy - eHeight / 2),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
  //画一个白子
  paint.color = Colors.white;
  canvas.drawCircle(
    Offset(rect.center.dx + eWidth / 2, rect.center.dy - eHeight / 2),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
}

Widget buildSliverList([int count = 5]) {
  return SliverFixedExtentList(
    itemExtent: 50,
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return ListTile(title: Text('$index'), onTap: () => print(index));
      },
      childCount: count,
    ),
  );
}
