import 'package:flutter/material.dart';
import '../common.dart';

class CustomPaintRoute extends StatelessWidget {
  const CustomPaintRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              size: const Size(300, 300), //指定画布大小
              painter: MyPainter(),
            ),
          ),
          RepaintBoundary(
              child: ElevatedButton(
            onPressed: () {},
            child: const Text("刷新"),
          ))
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('paint');
    var rect = Offset.zero & size;
    //画棋盘
    drawChessboard(canvas, rect);
    //画棋子
    drawPieces(canvas, rect);
  }

  // 在实际场景中正确使用此方法可以避免重绘开销，我们简单的返回false
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
