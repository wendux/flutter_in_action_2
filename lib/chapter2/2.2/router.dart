import 'package:flutter/material.dart';

class RouterTestRoute extends StatelessWidget {
  const RouterTestRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("打开提示页"),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TipRoute(
                  text: "我是提示xxxx",
                );
              },
            ),
          );
          print("路由返回值: $result");
        },
      ),
    );
  }
}

class TipRoute extends StatelessWidget {
  const TipRoute({
    Key? key,
    required this.text, // 接收一个text参数
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("提示"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: const Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
