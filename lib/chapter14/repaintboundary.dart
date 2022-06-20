import 'package:flutter/material.dart';
import '../common.dart';

class RepaintBoundaryTest extends StatefulWidget {
  const RepaintBoundaryTest({Key? key}) : super(key: key);

  @override
  _RepaintBoundaryTestState createState() => _RepaintBoundaryTestState();
}

class _RepaintBoundaryTestState extends State<RepaintBoundaryTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: const Size(50, 50),
            painter: OutlinePainter(),
          ),
        ),
        ElevatedButton(
          onPressed: () => setState(() {}),
          child: const Text("setState"),
        )
      ],
    );
  }
}

class OutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print("paint");
    var paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.black;
    canvas.drawRect(Offset.zero & size, paint);
  }

  // 本例中，rebuild时，painter会重新构建一个新实例，返回false,
  // 表示即使Painter实例发生变化也不需要重新绘制。
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
