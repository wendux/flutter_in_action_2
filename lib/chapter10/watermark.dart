import 'package:flutter/material.dart' hide Page;
import '../common.dart';

class WatermarkRoute extends StatelessWidget {
  const WatermarkRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListPage(children: [
      Page('测量文本宽高', wTextPainterTest(), showLog: true),
      Page('文本水印', wTextWaterMark(context), padding: false),
      Page('交错文本水印', wStaggerTextWaterMark(), padding: false),
      Page('水印指定偏移', wTextWaterMarkWithOffset(), padding: false),
      Page('UnconstrainedBox,水印偏移后会溢出', wTextWaterMarkWithUnconstrainedBox(),
          padding: false),
      Page('水印偏移-FittedBox', wTextWaterMarkWithFittedBox(), padding: false),
      Page('水印指定-OverflowBox', wTextWaterMarkWithOverflowBox(), padding: false),
    ]);
  }

  Widget wTextPainterTest() {
    // 我们想提前知道 Text 组件的大小
    Text text = const Text('flutter@wendux', style: const TextStyle(fontSize: 18));
    // 使用 TextPainter 来测量
    TextPainter painter =TextPainter(textDirection: TextDirection.ltr);
    // 将 Text 组件文本和样式透传给TextPainter
    painter.text = TextSpan(text: text.data,style:text.style);
    // 开始布局测量，调用 layout 后就能获取文本大小了
    painter.layout();
    // 自定义组件 AfterLayout 可以在布局结束后获取子组件的大小，我们用它来验证一下
    // TextPainter 测量的宽高是否正确
    return AfterLayout(
      callback: (RenderAfterLayout value) {
        // 输出日志
        print('text size(painter): ${painter.size}');
        print('text size(after layout): ${value.size}');
      },
      child: text,
    );
  }

  Widget wTextWaterMark(context) {
    const TextStyle();
    return Stack(
      children: [
        wPage(),
        IgnorePointer(
          child: WaterMark(
            painter: TextWaterMarkPainter(
              text: 'Flutter 中国 @wendux',
              padding: const EdgeInsets.only(top: 18),
              textStyle: const TextStyle(
                color: Colors.black,
              ),
              //rotate: -20,
            ),
          ),
        ),
      ],
    );
  }

  Widget wStaggerTextWaterMark() {
    return Stack(
      children: [
        wPage(),
        IgnorePointer(
          child: WaterMark(
            painter: StaggerTextWaterMarkPainter(
              text: '《Flutter实战》',
              text2: 'wendux',
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black38,
              ),
              padding2: const EdgeInsets.only(left: 40),
              rotate: -10,
            ),
          ),
        ),
      ],
    );
  }

  Widget wTextWaterMarkWithOffset() {
    return Stack(
      children: [
        wPage(),
        IgnorePointer(
          child: LayoutBuilder(builder: (context, constraints) {
            print(constraints);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Transform.translate(
                offset: const Offset(-30, 0),
                child: SizedBox(
                  // constraints.maxWidth 为屏幕宽度，+30 像素
                  width: constraints.maxWidth + 30,
                  height: constraints.maxHeight,
                  child: WaterMark(
                    painter: TextWaterMarkPainter(
                      text: 'Flutter 中国 @wendux',
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                      rotate: -20,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget wTextWaterMarkWithOverflowBox() {
    Future.delayed(const Duration(milliseconds: 200),()=>print('dd'));
    return Stack(
      children: [
        wPage(),
        IgnorePointer(
          child: TranslateWithExpandedPaintingArea(
            offset: const Offset(-30, 0),
            child: WaterMark(
              painter: TextWaterMarkPainter(
                text: 'Flutter 中国 @wendux',
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black38,
                ),
                rotate: -20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget wTextWaterMarkWithUnconstrainedBox() {
    return Stack(
      children: [
        wPage(),
        IgnorePointer(
          child: LayoutBuilder(
            builder: (_, constraints) {
              return UnconstrainedBox(
                // 取消父组件对子组件大小的约束
                alignment: Alignment.topRight,
                child: SizedBox(
                  //指定 WaterMark 宽度比屏幕长 30 像素
                  width: constraints.maxWidth + 30,
                  height: constraints.maxHeight,
                  child: WaterMark(
                    painter: TextWaterMarkPainter(
                      text: 'Flutter 中国 @wendux',
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                      rotate: -20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget wTextWaterMarkWithFittedBox() {
    return Stack(
      children: [
        wPage(),
        IgnorePointer(
          child: LayoutBuilder(
            builder: (_, constraints) {
              return FittedBox(
                // FittedBox会取消父组件对子组件的约束
                alignment: Alignment.topRight, // 通过对齐方式来实现平移效果
                fit: BoxFit.none, //不进行任何适配处理
                child: SizedBox(
                  //指定 WaterMark 宽度比屏幕长 30 像素
                  width: constraints.maxWidth + 30,
                  height: constraints.maxHeight,
                  child: WaterMark(
                    painter: TextWaterMarkPainter(
                      text: 'Flutter 中国 @wendux',
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                      rotate: -20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget wPage() {
    return Center(
      child: ElevatedButton(
        child: const Text('按钮'),
        onPressed: () => print('tab'),
      ),
    );
  }
}
