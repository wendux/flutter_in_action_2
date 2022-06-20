import 'package:flutter/material.dart';

class DecoratedBoxRoute extends StatelessWidget {
  const DecoratedBoxRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.red, Colors.orange.shade700]),
              //背景渐变
              borderRadius: BorderRadius.circular(3.0),
              //3像素圆角
              boxShadow: const [
                //阴影
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0)
              ]),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 80.0,
              vertical: 18.0,
            ),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              image: const DecorationImage(
                image: AssetImage("imgs/avatar.png"),
                //alignment: Alignment.topLeft
              ),
            ),
          ),
        )
      ],
    );
  }
}
