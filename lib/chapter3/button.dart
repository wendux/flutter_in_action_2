import 'package:flutter/material.dart';

class ButtonRoute extends StatefulWidget {
  const ButtonRoute({Key? key}) : super(key: key);

  @override
  _ButtonRouteState createState() => _ButtonRouteState();
}

class _ButtonRouteState extends State<ButtonRoute> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: const Text("normal"),
          onPressed: () => {},
        ),
        OutlinedButton(
          child: const Text("normal"),
          onPressed: () => {},
        ),
        IconButton(
          icon: const Icon(Icons.thumb_up),
          onPressed: () => {},
        ),
        TextButton(
          child: const Text("Submit"),
          onPressed: () => {},
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text("发送"),
          onPressed: _onPressed,
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("添加"),
          onPressed: _onPressed,
        ),
        TextButton.icon(
          icon: const Icon(Icons.info),
          label: const Text("详情"),
          onPressed: _onPressed,
        ),
      ]
          .map(
              (e) => Padding(child: e, padding: const EdgeInsets.only(top: 20)))
          .toList(),
    );
  }

  void _onPressed() {
    print("button pressed");
  }
}
