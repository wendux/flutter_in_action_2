import 'package:flutter/material.dart';

class SizeConstraintsRoute extends StatelessWidget {
  const SizeConstraintsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget redBox = const DecoratedBox(
      decoration: BoxDecoration(color: Colors.red),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("约束"),
        actions: const <Widget>[
          UnconstrainedBox(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                value: .9,
                valueColor: AlwaysStoppedAnimation(Colors.white70),
              ),
            ),
          )

          // Center(
          //   child: SizedBox(
          //     width: 20,
          //     height: 20,
          //     child: CircularProgressIndicator(
          //       strokeWidth: 3,
          //       value: .9,
          //       valueColor: AlwaysStoppedAnimation(Colors.white70),
          //     ),
          //   ),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity, //宽度尽可能大
                minHeight: 50.0, //最小高度为50像素
              ),
              child: SizedBox(height: 5.0, child: redBox),
            ),
            SizedBox(width: 80.0, height: 80.0, child: redBox),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 60.0, minHeight: 60.0),
              //父
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 90.0, minHeight: 20.0),
                //子
                child: redBox,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 90.0, minHeight: 20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 60.0, minHeight: 60.0),
                child: redBox,
              ),
            ),
            UnconstrainedBox(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [Text('xx' * 30)]),
              ),
            ),

            // AspectRatio(
            //   aspectRatio: 3, //宽是高的三倍
            //   child: redBox,
            // )
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
