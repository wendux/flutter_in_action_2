import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'accurate_sized_box.dart';

class ConstraintsTest extends StatelessWidget {
  const ConstraintsTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var container = Container(width: 200, height: 200, color: Colors.red);
    return UnconstrainedBox(
      child: container,
    );
    // return Align(
    //   child: container,
    //   alignment: Alignment.topLeft,
    // );
    // return CustomSizedBox(
    //   width: 200,
    //   height: 200,
    //   child: Container(color: Colors.green,),
    // );
  }
}
