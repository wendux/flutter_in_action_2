import 'package:flutter/material.dart';

class FocusTestRoute extends StatefulWidget {
  const FocusTestRoute({Key? key}) : super(key: key);

  @override
  _FocusTestRouteState createState() => _FocusTestRouteState();
}

class _FocusTestRouteState extends State<FocusTestRoute> {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            focusNode: focusNode1, //关联focusNode1
            toolbarOptions: const ToolbarOptions(
              selectAll: true,
              copy: true,
              paste: true,
            ),
            decoration: const InputDecoration(labelText: "input1"),
          ),
          TextField(
            focusNode: focusNode2, //关联focusNode2
            decoration: const InputDecoration(labelText: "input2"),
          ),
          Builder(
            builder: (ctx) {
              return Column(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text("移动焦点"),
                    onPressed: () {
                      //将焦点从第一个TextField移到第二个TextField
                      FocusScope.of(context).requestFocus(focusNode2);
                    },
                  ),
                  ElevatedButton(
                    child: const Text("隐藏键盘"),
                    onPressed: () {
                      // 当所有编辑框都失去焦点时键盘就会收起
                      focusNode1.unfocus();
                      focusNode2.unfocus();
                    },
                  ),
                ],
              );
            },
          ),
          const Text("自定义下划线颜色"),
          const TextField(
            decoration: InputDecoration(
              labelText: "请输入用户名",
              prefixIcon: Icon(Icons.person),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
