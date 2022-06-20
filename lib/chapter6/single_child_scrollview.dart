import 'package:flutter/material.dart';

class SingleChildScrollViewTestRoute extends StatelessWidget {
  const SingleChildScrollViewTestRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String str = "ABCD" * 20;
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //动态创建一个List<Widget>
            children: str
                .split("")
                //每一个字母都用一个Text显示,字体大小为原来的两倍
                .map((c) => Text(
                      c,
                      textScaleFactor: 2.0,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
