import 'package:flutter/material.dart' hide Page;
import '../common.dart';

class PersistentHeaderRoute extends StatelessWidget {
  const PersistentHeaderRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListPage(children: [
      Page('SliverPersistentHeader示例1', wSample1(), padding: false),
      Page('SliverPersistentHeader示例2', wSample2(context), withScaffold: false),
    ]);
  }

  Widget wSample1() {
    return CustomScrollView(
      slivers: [
        buildSliverList(),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate(
            maxHeight: 80,
            minHeight: 50,
            child: buildHeader(1),
          ),
        ),
        buildSliverList(),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate.fixedHeight(
            height: 50,
            child: buildHeader(2),
          ),
        ),
        buildSliverList(20),
      ],
    );
  }

  Widget wSample2(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ColoredBox(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                floating: true,
                delegate: SliverHeaderDelegate.fixedHeight(
                  height: 50,
                  child: const TextField(),
                ),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: const SliverAppBar(
                  title: Text('示例二'),
                  pinned: true,
                  collapsedHeight: 56,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate.fixedHeight(
                  height: 50,
                  child: buildHeader(2),
                ),
              ),
              buildSliverList(30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(int i) {
    return GestureDetector(
      key: ValueKey(i),
      onTap: () => print('header $i'),
      child: Container(
        color: Colors.lightBlue.shade200,
        alignment: Alignment.centerLeft,
        child: Text("PersistentHeader $i"),
      ),
    );
  }
}
