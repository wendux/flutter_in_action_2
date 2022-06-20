import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../common.dart';

void main() {
  //1.创建绘制记录器和Canvas
  PictureRecorder recorder = PictureRecorder();
  Canvas canvas = Canvas(recorder);
  //2.开始绘制
  var rect = Rect.fromLTWH(30, 200, 300,300 );
  drawChessboard(canvas,rect);//画棋盘
  drawPieces(canvas,rect);//画棋子
  //3.创建layer，将绘制的内容保存在layer中
  var pictureLayer = PictureLayer(rect);
  //recorder.endRecording()获取绘制产物。
  pictureLayer.picture = recorder.endRecording();
  var rootLayer = OffsetLayer();
  rootLayer.append(pictureLayer);
  //4.上屏，即将绘制的内容显示在屏幕上。
  final SceneBuilder builder = SceneBuilder();
  final Scene scene = rootLayer.buildScene(builder);
  window.render(scene);
}
