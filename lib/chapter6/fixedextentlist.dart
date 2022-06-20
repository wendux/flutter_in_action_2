import 'package:flutter/material.dart';
import 'package:flutter_in_action_2/routes.dart';

class FixedExtentList extends StatelessWidget {
  const FixedExtentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // itemExtent: 56,
      //prototypeItem: ListTile(title: Text("1")),
      itemBuilder: (context, index) {
        return LayoutLogPrint(
          tag: index,
          child: ListTile(title: Text("$index")),
        );
      },
    );
  }
}
