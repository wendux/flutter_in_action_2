import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StateChangeTest extends StatefulWidget {
  const StateChangeTest({Key? key}) : super(key: key);

  @override
  _StateChangeTestState createState() => _StateChangeTestState();
}

class _StateChangeTestState extends State<StateChangeTest> {
  int index = 0;

  void update(VoidCallback fn) {
    final schedulerPhase = SchedulerBinding.instance.schedulerPhase;
    if (schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(fn);
      });
    } else {
      setState(fn);
    }
    // if (schedulerPhase == SchedulerPhase.idle ||
    //     schedulerPhase == SchedulerPhase.postFrameCallbacks) {
    //   setState(fn);
    // } else {
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     setState(fn);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    // 下面代码不会报错，因为在build时当前组件的dirty为true,而setState中
    // 会先判断当前dirty值，如果为true会直接返回
    setState(() {
      ++index;
    });
    return Text('$index');
    // //build阶段不能调用setState
    // return LayoutBuilder(
    //   builder: (context, c) {
    //     print(SchedulerBinding.instance.schedulerPhase);
    //     setState(() {
    //       ++index;
    //     });
    //     return Text('xx');
    //   },
    // );
  }
}
