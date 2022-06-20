import 'package:flutter/material.dart';

class GetStateObjectRoute extends StatefulWidget {
  const GetStateObjectRoute({Key? key}) : super(key: key);

  @override
  State<GetStateObjectRoute> createState() => _GetStateObjectRouteState();
}

class _GetStateObjectRouteState extends State<GetStateObjectRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("子树中获取State对象"),
      ),
      body: Center(
        child: Column(
          children: [
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  // 查找父级最近的Scaffold对应的ScaffoldState对象
                  ScaffoldState _state = context.findAncestorStateOfType<ScaffoldState>()!;
                  // 打开抽屉菜单
                  _state.openDrawer();
                },
                child: const Text('打开抽屉菜单1'),
              );
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  // 直接通过of静态方法来获取ScaffoldState
                  ScaffoldState _state=Scaffold.of(context);
                  // 打开抽屉菜单
                  _state.openDrawer();
                },
                child: const Text('打开抽屉菜单2'),
              );
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("我是SnackBar")),
                  );
                },
                child: const Text('显示SnackBar'),
              );
            }),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
