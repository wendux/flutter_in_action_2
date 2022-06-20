import 'package:flutter/material.dart';

class AnimatedListRoute extends StatefulWidget {
  const AnimatedListRoute({Key? key}) : super(key: key);

  @override
  _AnimatedListRouteState createState() => _AnimatedListRouteState();
}

class _AnimatedListRouteState extends State<AnimatedListRoute> {
  var data = <String>[];
  int counter = 5;

  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    for (var i = 0; i < counter; i++) {
      data.add('${i + 1}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedList(
          key: globalKey,
          initialItemCount: data.length,
          itemBuilder: (
            BuildContext context,
            int index,
            Animation<double> animation,
          ) {
            return FadeTransition(
              opacity: animation,
              child: buildItem(context, index),
            );
          },
        ),
        buildAddBtn(),
      ],
    );
  }

  Widget buildAddBtn() {
    return Positioned(
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          data.add('${++counter}');
          globalKey.currentState!.insertItem(data.length - 1);
          print('添加 $counter');
        },
      ),
      bottom: 30,
      left: 0,
      right: 0,
    );
  }

  Widget buildItem(context, index) {
    String char = data[index];
    return ListTile(
      // 数字不会重复，所以作为Key
      key: ValueKey(char),
      title: Text(char),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        // 点击时删除
        onPressed: () => onDelete(context, index),
      ),
    );
  }

  void onDelete(context, index) {
    setState(() {
      globalKey.currentState!.removeItem(
        index,
        (context, animation) {
          // 删除过程执行的是反向动画，animation.value 会从1变为0
          var item = buildItem(context, index);
          print('删除 ${data[index]}');
          data.removeAt(index);
          //让透明度变化的更快一些
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0),
            ),
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: 0.0,
              child: item,
            ),
          );
        },
        duration: const Duration(milliseconds: 200),
      );
    });
  }
}
