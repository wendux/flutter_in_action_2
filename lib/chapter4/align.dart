import 'package:flutter/material.dart';

class AlignRoute extends StatelessWidget {
  const AlignRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 120.0,
            width: 120.0,
            color: Colors.blue.shade50,
            child: const Align(
              alignment: Alignment.topRight,
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
          Container(
//          height: 120.0,
//          width: 120.0,
            color: Colors.blue.shade50,
            child: const Align(
              widthFactor: 2,
              heightFactor: 2,
              alignment: Alignment(2, 0.0),
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
          Container(
            height: 120.0,
            width: 120.0,
            color: Colors.blue[50],
            child: const Align(
              alignment: FractionalOffset(0.2, 0.6),
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
              child: Text("xxx"),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Text("xxx"),
            ),
          )
        ]
            .map((e) => Padding(padding: const EdgeInsets.only(top: 16), child: e))
            .toList(),
      ),
    );
  }
}
