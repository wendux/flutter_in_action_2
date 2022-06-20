import 'package:flutter/material.dart' hide Page;
import '../common.dart';

class NestedScrollViewRoute extends StatelessWidget {
  const NestedScrollViewRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListPage(children: [
      Page('嵌套 ListView', const NestedListView(), withScaffold: false),
      Page('Snap 效果的AppBar(bug版)', const SnapAppBarWithBug(), withScaffold: false),
      Page('Snap 效果的AppBar（无bug）', const SnapAppBar2(), withScaffold: false),
      Page('嵌套 TabBarView', const NestedTabBarView1(), withScaffold: false),
      Page('复杂的嵌套 TabBarView', const NestedTabBarView2(), withScaffold: false),
    ]);
  }
}

class NestedListView extends StatelessWidget {
  const NestedListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // 返回一个 Sliver 数组
          return <Widget>[
            SliverAppBar(
              title: const Text('嵌套ListView'),
              pinned: true,
              forceElevated: innerBoxIsScrolled,
            ),
            buildSliverList(), //构建一个 sliverList
          ];
        },
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          physics: const ClampingScrollPhysics(), //重要
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 50,
              child: Center(child: Text('Item $index')),
            );
          },
        ),
      ),
    );
  }
}

class SnapAppBarWithBug extends StatelessWidget {
  const SnapAppBarWithBug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "./imgs/sea.png",
                  fit: BoxFit.cover,
                ),
              ),
              forceElevated: innerBoxIsScrolled,
            )
          ];
        },
        body: Builder(builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[buildSliverList(100)],
          );
        }),
      ),
    );
  }
}

class SnapAppBar2 extends StatefulWidget {
  const SnapAppBar2({Key? key}) : super(key: key);

  @override
  State<SnapAppBar2> createState() => _SnapAppBar2State();
}

class _SnapAppBar2State extends State<SnapAppBar2> {
  late SliverOverlapAbsorberHandle handle;

  void onOverlapChanged() {
    // 打印 overlap length
    print(handle.layoutExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          handle = NestedScrollView.sliverOverlapAbsorberHandleFor(context);
          handle.removeListener(onOverlapChanged);
          handle.addListener(onOverlapChanged);
          return <Widget>[
            SliverOverlapAbsorber(
              handle: handle,
              sliver: SliverAppBar(
                floating: true,
                snap: true,
                // pinned: true,  // 放开注释，然后看日志
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "./imgs/sea.png",
                    fit: BoxFit.cover,
                  ),
                ),
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: LayoutBuilder(builder: (BuildContext context, cons) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(handle: handle),
              buildSliverList(100)
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    // 移除监听器
    handle.removeListener(onOverlapChanged);
    super.dispose();
  }
}

class NestedTabBarView1 extends StatelessWidget {
  const NestedTabBarView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tabs = <String>['猜你喜欢', '今日特价', '发现更多'];
    // 构建 tabBar
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // SliverOverlapAbsorber(
              //   handle:
              //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              //   sliver: SliverAppBar(
              //     title: const Text('商城'),
              //     // floating: true,
              //     // snap: true,
              //     pinned: true,
              //     forceElevated: true,
              //     bottom: TabBar(
              //       tabs: _tabs.map((String name) => Tab(text: name)).toList(),
              //     ),
              //   ),
              // ),

              SliverAppBar(
                title: const Text('商城'),
                // floating: true,
                // snap: true,
                pinned: true,
                forceElevated: true,
                bottom: TabBar(
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      // SliverOverlapInjector(
                      //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      //       context),
                      // ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: buildSliverList(50),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class NestedTabBarView2 extends StatelessWidget {
  const NestedTabBarView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tabs = <String>['猜你喜欢', '今日特价', '发现更多'];
    // 构建 tabBar
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Theme(
        data: Theme.of(context).copyWith(brightness: Brightness.dark),
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                const SliverAppBar(
                  title: Text('Floating Nested SliverAppBar'),
                  pinned: true,
                  elevation: 0,
                  //forceElevated: innerBoxIsScrolled,
                ),
                buildSliverList(5),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate.builder(
                    maxHeight: 56,
                    minHeight: 56,
                    builder: (BuildContext context, double shrinkOffset,
                        bool overlapsContent) {
                      return Material(
                        child: Container(
                          color: overlapsContent
                              ? Colors.white
                              : Theme.of(context).canvasColor,
                          child: buildTabBar(_tabs),
                        ),
                        elevation: overlapsContent ? 4 : 0,
                        shadowColor: Theme.of(context).appBarTheme.shadowColor,
                      );
                    },
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: _tabs.map((String name) {
                return Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      physics: const ClampingScrollPhysics(),
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: buildSliverList(30),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabBar(List<String> tabs) {
    return TabBar(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black38,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: Colors.blue),
        insets: EdgeInsets.only(bottom: 10),
      ),
      tabs: tabs.map((String name) => Tab(text: name)).toList(),
    );
  }
}
