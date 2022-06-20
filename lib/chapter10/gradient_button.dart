import 'package:flutter/material.dart';
import '../widgets/index.dart';

class GradientButtonRoute extends StatefulWidget {
  const GradientButtonRoute({Key? key}) : super(key: key);

  @override
  _GradientButtonRouteState createState() => _GradientButtonRouteState();
}

class _GradientButtonRouteState extends State<GradientButtonRoute> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GradientButton(
          colors: const [Colors.orange, Colors.red],
          height: 50.0,
          child: const Text("Submit"),
          onPressed: onTap,
        ),
        GradientButton(
          height: 50.0,
          colors: [Colors.lightGreen, Colors.green.shade700],
          child: const Text("Submit"),
          onPressed: onTap,
        ),
        GradientButton(
          height: 50.0,
          //borderRadius: const BorderRadius.all(Radius.circular(5)),
          colors: [Colors.lightBlue.shade300, Colors.blueAccent],
          child: const Text("Submit"),
          onPressed: onTap,
        ),
      ],
    );
  }
  onTap() {
    print("button click");
  }
}
