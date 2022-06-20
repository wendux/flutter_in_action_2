import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class ScrollViewConfiguration extends StatefulWidget {
  const ScrollViewConfiguration({Key? key}) : super(key: key);

  @override
  _ScrollViewConfigurationState createState() =>
      _ScrollViewConfigurationState();
}

class _ScrollViewConfigurationState extends State<ScrollViewConfiguration> {
  bool reverse = false;
  bool vertical = true;
  ScrollPhysics physics = const ScrollPhysics();

  @override
  Widget build(BuildContext context) {
    Widget list = ListView.builder(
      reverse: reverse,
      scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
      // controller:  ,
      //physics:  ObserveOverscrollPhysics((e)=>print(e)),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('$index',textScaleFactor: 2,)),
        );
      },
    );

    return Column(children: [
      Expanded(child: list),
      wConfigurationPanel(),
    ]);
  }

  Widget wConfigurationPanel() {
    return ListView(
      shrinkWrap: true,
      children: [
        CheckboxListTile(
          value: reverse,
          title: const Text('反向'),
          onChanged: (v) => setState(() => reverse = v!),
        ),
        CheckboxListTile(
          value: vertical,
          title: const Text('Vertical(滚动方向)'),
          onChanged: (v) => setState(() => vertical = v!),
        ),
      ],
    );
  }
}



