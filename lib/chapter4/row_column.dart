import 'package:flutter/material.dart';

class CenterColumnRoute extends StatelessWidget {
  const CenterColumnRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text("hi"),
          Text("world"),
        ],
      ),
    );
  }
}
