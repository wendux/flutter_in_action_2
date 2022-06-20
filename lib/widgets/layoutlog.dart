import 'package:flutter/widgets.dart';

class LayoutLogPrint<T> extends StatelessWidget {
  const LayoutLogPrint({
    Key? key,
    this.tag,
    this.debugPrint = print,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Function(Object? object) debugPrint;
  final T? tag;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      assert(() {
        debugPrint('${tag ?? key ?? child.runtimeType}: $constraints');
        return true;
      }());
      return child;
    });
  }
}


