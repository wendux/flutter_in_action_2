import 'package:flutter/material.dart' hide Page;
import '../common.dart';

class PointerRoute extends StatelessWidget {
  const PointerRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListPage(children: [Page('显示移动偏移', const PointerMoveIndicator())]);
  }
}

class PointerMoveIndicator extends StatefulWidget {
  const PointerMoveIndicator({Key? key}) : super(key: key);

  @override
  _PointerMoveIndicatorState createState() => _PointerMoveIndicatorState();
}

class _PointerMoveIndicatorState extends State<PointerMoveIndicator> {
  PointerEvent? _event;


  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        width: 300.0,
        height: 150.0,
        child: Text(
          '${_event?.localPosition ?? ''}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      onPointerDown: (PointerDownEvent event) => setState(() => _event = event),
      onPointerMove: (PointerMoveEvent event) => setState(() => _event = event),
      onPointerUp: (PointerUpEvent event) => setState(() => _event = event),
    );
  }
}
