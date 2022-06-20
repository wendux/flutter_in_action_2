import 'dart:ui';

import 'package:flutter/material.dart';
import '../routes.dart';
import 'dart:math' as math;

class PageViewTest extends StatefulWidget {
  const PageViewTest({Key? key}) : super(key: key);

  @override
  _PageViewTestState createState() => _PageViewTestState();
}

class _PageViewTestState extends State<PageViewTest> {
  PageController pageController = PageController();

  int buildType = 1;
  Axis scrollDirection = Axis.horizontal;
  bool reverse = false;
  bool pageSnapping = true;
  bool withPageStorageKey = false;
  bool wrapWithKeepAliveWrapper = false;
  bool allowImplicitScrolling = false;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    print("build");

    for (int i = 0; i < 6; ++i) {
      Widget child = Page(
        key: withPageStorageKey ? PageStorageKey('$i') : null,
        text: '$i',
        buildType: buildType,
      );
      if (wrapWithKeepAliveWrapper) child = KeepAliveWrapper(child: child);
      children.add(child);
    }

    return PageView(
      controller: pageController,
      pageSnapping: pageSnapping,
      scrollDirection: scrollDirection,
      reverse: reverse,
      allowImplicitScrolling: allowImplicitScrolling,
      children: [buildConfigPage(context), ...children],
    );
  }

  Widget buildConfigPage(context) {
    var size = MediaQueryData.fromWindow(window).size;
    // return LayoutBuilder(builder: (context,constraints){
    //   print(constraints);
    //   return Text("");
    // });
    return FittedBox(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width),
        child: Column(
          children: [
            ExpansionTile(
              title: const Text("页面类型"),
              initiallyExpanded: true,
              children: [
                RadioListTile(
                  value: 1,
                  title: const Text('数字'),
                  groupValue: buildType,
                  onChanged: buildTypeChange,
                ),
                RadioListTile(
                  value: 2,
                  title: const Text('别表'),
                  groupValue: buildType,
                  onChanged: buildTypeChange,
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("滑动方向"),
              initiallyExpanded: true,
              children: [
                RadioListTile(
                  value: Axis.horizontal,
                  title: const Text('水平'),
                  groupValue: scrollDirection,
                  onChanged: scrollDirectionChange,
                ),
                RadioListTile(
                  value: Axis.vertical,
                  title: const Text('垂直'),
                  groupValue: scrollDirection,
                  onChanged: scrollDirectionChange,
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("其它配置"),
              initiallyExpanded: true,
              children: [
                CheckboxListTile(
                  value: reverse,
                  title: const Text('reverse'),
                  onChanged: (v) => setState(() => reverse = v!),
                ),
                CheckboxListTile(
                  value: pageSnapping,
                  title: const Text('pageSnapping'),
                  onChanged: (v) => setState(() => pageSnapping = v!),
                ),
                CheckboxListTile(
                  value: withPageStorageKey,
                  title: const Text('添加PageStorageKey'),
                  onChanged: (v) => setState(() => withPageStorageKey = v!),
                ),
                CheckboxListTile(
                  value: wrapWithKeepAliveWrapper,
                  title: const Text('KeepAlive'),
                  onChanged: (v) {
                    setState(() {
                      wrapWithKeepAliveWrapper = v!;
                      if (wrapWithKeepAliveWrapper) {
                        allowImplicitScrolling = false;
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  value: allowImplicitScrolling,
                  title: const Text('allowImplicitScrolling'),
                  onChanged: (v) {
                    setState(() {
                      allowImplicitScrolling = v!;
                      if (allowImplicitScrolling) {
                        wrapWithKeepAliveWrapper = false;
                      }
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text("打开新路由页"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PageScaffold(
                        title: 'xx',
                        body: const Center(child: Text('xx')),
                      );
                    }));
                  },
                ),
              ],
            ),
            // ExpansionTile(
            //   title: Text("其它配置"),
            //   initiallyExpanded: true,
            //   children: [
            //     CheckboxListTile(
            //       value: reverse,
            //       title: Text('reverse'),
            //       onChanged: (v) => setState(() => reverse = v!),
            //     ),
            //     CheckboxListTile(
            //       value: pageSnapping,
            //       title: Text('pageSnapping'),
            //       onChanged: (v) => setState(() => pageSnapping = v!),
            //     ),
            //     CheckboxListTile(
            //       value: withPageStorageKey,
            //       title: Text('添加PageStorageKey'),
            //       onChanged: (v) => setState(() => withPageStorageKey = v!),
            //     ),
            //     CheckboxListTile(
            //       value: wrapWithKeepAliveWrapper,
            //       title: Text('KeepAlive'),
            //       onChanged: (v) => setState(() => wrapWithKeepAliveWrapper = v!),
            //     ),
            //   ],
            // ),
            // ExpansionTile(
            //   title: Text("其它配置"),
            //   initiallyExpanded: true,
            //   children: [
            //     CheckboxListTile(
            //       value: reverse,
            //       title: Text('reverse'),
            //       onChanged: (v) => setState(() => reverse = v!),
            //     ),
            //     CheckboxListTile(
            //       value: pageSnapping,
            //       title: Text('pageSnapping'),
            //       onChanged: (v) => setState(() => pageSnapping = v!),
            //     ),
            //     CheckboxListTile(
            //       value: withPageStorageKey,
            //       title: Text('添加PageStorageKey'),
            //       onChanged: (v) => setState(() => withPageStorageKey = v!),
            //     ),
            //     CheckboxListTile(
            //       value: wrapWithKeepAliveWrapper,
            //       title: Text('KeepAlive'),
            //       onChanged: (v) => setState(() => wrapWithKeepAliveWrapper = v!),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  buildTypeChange(int? v) {
    setState(() {
      buildType = v!;
      if (buildType == 2) {
        scrollDirection = Axis.horizontal;
      }
    });
  }

  scrollDirectionChange(Axis? v) {
    setState(() {
      scrollDirection = v!;
      if (scrollDirection == Axis.vertical) {
        buildType = 1;
      }
    });
  }
}

class Page extends StatefulWidget {
  const Page({
    Key? key,
    required this.text,
    required this.buildType,
  }) : super(key: key);

  final String text;
  final int buildType;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  void initState() {
    super.initState();
    print("initState ${widget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("build ${widget.text}");
    return widget.buildType == 1 ? buildNumber() : buildList();
  }

  Widget buildList() {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(title: Text('$index')),
    );
  }

  Widget buildNumber() {
    return Center(child: Text(widget.text, textScaleFactor: 5));
  }
//
// @override
// bool get wantKeepAlive => true;
}

class Page1 extends StatefulWidget {
  const Page1({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  ScrollController controller = ScrollController();
  int index = 1;

  @override
  Widget build(BuildContext context) {
    var img = const Image(
      image: AssetImage("imgs/sea.png"),
      alignment: Alignment.bottomCenter,
      fit: BoxFit.cover,
    );

    var children = <Widget>[];
    for (int i = 0; i < 6; i++) {
      children.add(Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        child: img,
      ));
    }
    Widget list = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 60,
        child: ListView(
          physics: ObserveOverscrollPhysics((offset) {
            widget.pageController.jumpTo(widget.pageController.offset + offset);
          }),
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: children,
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          list,
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("xxx" * 3000),
          )
        ],
      ),
    );
  }
}

//BouncingScrollPhysics b;

class ObserveOverscrollPhysics extends AlwaysScrollableScrollPhysics {
  const ObserveOverscrollPhysics(this.onOverscrollChanged, {ScrollPhysics? parent})
      : super(parent: parent);

  final ValueChanged<double> onOverscrollChanged;

  // @override
  // double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
  //   bool isOverscroll =
  //       (position.pixels >= position.maxScrollExtent && offset < 0) ||
  //           (position.pixels <= position.minScrollExtent && offset > 0);
  //   if (isOverscroll) {
  //     onOverscrollChanged(-offset);
  //   }
  //   if (parent is BouncingScrollPhysics) {
  //     return isOverscroll ? 0 : offset;
  //   } else {
  //     return super.applyPhysicsToUserOffset(position, offset);
  //   }
  // }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    final double overscrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast =
        math.max(overscrollPastStart, overscrollPastEnd);

    print(overscrollPast);

    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  ObserveOverscrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ObserveOverscrollPhysics(
      onOverscrollChanged,
      parent: buildParent(ancestor),
    );
  }
}
