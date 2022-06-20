import 'package:flutter/material.dart';
import '../common.dart';

class PullRefreshBoxRoute extends StatefulWidget {
  const PullRefreshBoxRoute({Key? key}) : super(key: key);

  @override
  State<PullRefreshBoxRoute> createState() => _PullRefreshBoxRouteState();
}

class _PullRefreshBoxRouteState extends State<PullRefreshBoxRoute> {
  int _itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return PullRefreshScope(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverPullRefreshIndicator(
            refreshTriggerPullDistance: 100.0,
            refreshIndicatorExtent: 60.0,
            onRefresh: () async {
              await Future<void>.delayed(const Duration(seconds: 2));
              setState(() => _itemCount += 10);
            },
          ),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                    title: Text('$index'), onTap: () => print(index));
              },
              childCount: _itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
