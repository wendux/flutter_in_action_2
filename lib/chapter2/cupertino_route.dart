//导入cupertino  widget 库
import 'package:flutter/cupertino.dart';

class CupertinoTestRoute extends StatelessWidget  {
  const CupertinoTestRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Cupertino Demo"),
      ),
      child: Center(
        child: CupertinoButton(
            color: CupertinoColors.activeBlue,
            child: const Text("Press"),
            onPressed: () {}
        ),
      ),
    );
  }
}