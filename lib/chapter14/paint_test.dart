import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_in_action_2/common.dart';

class PaintTest extends StatefulWidget {
  const PaintTest({Key? key}) : super(key: key);

  @override
  State<PaintTest> createState() => _PaintTestState();
}

class _PaintTestState extends State<PaintTest> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ChessWidget(),
          ElevatedButton(
            onPressed: () {
              setState(() => null);
            },
            child: const Text("setState"),
          ),
        ],
      ),
    );
  }
}

class ChessWidget extends LeafRenderObjectWidget {
  const ChessWidget({Key? key}) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderChess();
  }
}

class RenderChess extends RenderBox {
  final layerHandle = LayerHandle<PictureLayer>();

  @override
  void performLayout() {
    size = constraints.constrain(
      constraints.isTight ? Size.infinite : const Size(150, 150),
    );
  }

  // @override
  // get isRepaintBoundary => true;

  //保存之前的棋盘大小
  Rect _rect = Rect.zero;

  _checkIfChessboardNeedsUpdate(Rect rect) {
    // 如果绘制区域大小没发生变化，则无需重绘棋盘
    if (_rect == rect) return;
    _rect = rect;
    print("paint chessboard");
    //新建一个PictureLayer，用于缓存棋盘的绘制结果，并添加到layer中
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    drawChessboard(canvas, rect);
    layerHandle.layer = PictureLayer(Rect.zero)
      ..picture = recorder.endRecording();
  }


  @override
  void paint(PaintingContext context, Offset offset) {
    Rect rect = offset & size;
    //检查棋盘大小是否需要变化，如果变化，则需要重新绘制棋盘并缓存
    _checkIfChessboardNeedsUpdate(rect);
    //将缓存棋盘的layer添加到context中
    context.addLayer(layerHandle.layer!);
    //再画棋子
    print("paint pieces");
    drawPieces(context.canvas, rect);
  }

  @override
  void dispose() {
    //layer通过引用计数的方式来跟踪自身是否还被layerHandle持有，
    //如果不被持有则会释放资源，所以我们必须手动置空，该set操作会
    //解除layerHandle对layer的持有。
    layerHandle.layer = null;
    super.dispose();
  }
}

