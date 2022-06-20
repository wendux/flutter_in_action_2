import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullRefreshTestRoute extends StatelessWidget {
  const PullRefreshTestRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(
          builder: builder,
          onRefresh: () => Future.delayed(const Duration(seconds: 2)),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => ListTile(
              title: Text('$index'),
            ),
          ),
        )
      ],
    );
  }

  Widget builder(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    Widget widget;
    double width = min(25, pulledExtent);
    if (refreshState == RefreshIndicatorMode.refresh) {
      widget = SizedBox(
        child: const CircularProgressIndicator(strokeWidth: 2),
        width: width,
        height: width,
      );
    } else {
      widget = Transform.rotate(
        angle: pulledExtent / 80 * 6.28,
        child: const CircularProgressIndicator(
          value: .85,
          strokeWidth: 2,
        ),
      );
    }
    return Center(
      child: SizedBox(
        width: width,
        height: width,
        child: Padding(padding: const EdgeInsets.all(2.0), child: widget),
      ),
    );
  }
}
