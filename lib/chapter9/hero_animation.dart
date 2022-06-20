import 'package:flutter/material.dart' hide Page;
import '../common.dart';

class HeroAnimationRoute extends StatelessWidget {
  const HeroAnimationRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListPage(children: [
      Page('自实现Hero动画', const CustomHeroAnimation()),
      Page('Flutter Hero动画', const HeroAnimationRouteA()),
    ]);
  }
}

// 路由A
class HeroAnimationRouteA extends StatelessWidget {
  const HeroAnimationRouteA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Hero(
              tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
              child: ClipOval(
                child: Image.asset(
                  "imgs/avatar.png",
                  width: 50.0,
                ),
              ),
            ),
            onTap: () {
              //打开B路由
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (
                  BuildContext context,
                  animation,
                  secondaryAnimation,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: Scaffold(
                      appBar: AppBar(
                        title: const Text("原图"),
                      ),
                      body: const HeroAnimationRouteB(),
                    ),
                  );
                },
              ));
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("点击头像"),
          )
        ],
      ),
    );
  }
}

class HeroAnimationRouteB extends StatelessWidget {
  const HeroAnimationRouteB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
        child: Image.asset("imgs/avatar.png"),
      ),
    );
  }
}

class CustomHeroAnimation extends StatefulWidget {
  const CustomHeroAnimation({Key? key}) : super(key: key);

  @override
  _CustomHeroAnimationState createState() => _CustomHeroAnimationState();
}

class _CustomHeroAnimationState extends State<CustomHeroAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _animating = false;
  AnimationStatus? _lastAnimationStatus;
  late Animation _animation;

  //两个组件在Stack中的rect
  Rect? child1Rect;
  Rect? child2Rect;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.addListener(() {
      if (_controller.isCompleted || _controller.isDismissed) {
        if (_animating) {
          setState(() {
            _animating = false;
          });
        }
      } else {
        _lastAnimationStatus = _controller.status;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //小头像
    final Widget child1 = wChild1();
    //大头像
    final Widget child2 = wChild2();

    //是否展示小头像；只有在动画执行时、初始状态或者刚从大图变为小图时才应该显示小头像
    bool showChild1 =
        !_animating && _lastAnimationStatus != AnimationStatus.forward;

    // 执行动画时的目标组件；如果是从小图变为大图，则目标组件是大图；反之则是小图
    Widget targetWidget;
    if (showChild1 || _controller.status == AnimationStatus.reverse) {
      targetWidget = child1;
    } else {
      targetWidget = child2;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        //我们让Stack 填满屏幕剩余空间
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            if (showChild1)
              AfterLayout(
                //获取小图在Stack中占用的Rect信息
                callback: (value) => child1Rect = _getRect(value),
                child: child1,
              ),
            if (!showChild1)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  //求出 rect 插值
                  final rect = Rect.lerp(
                    child1Rect,
                    child2Rect,
                    _animation.value,
                  );
                  // 通过 Positioned 设置组件大小和位置
                  return Positioned.fromRect(rect: rect!, child: child!);
                },
                child: targetWidget,
              ),
            // 用于测量 child2 的大小，设置为全透明并且不能响应事件
            IgnorePointer(
              child: Center(
                child: Opacity(
                  opacity: 0,
                  child: AfterLayout(
                    //获取大图在Stack中占用的Rect信息
                    callback: (value) => child2Rect = _getRect(value),
                    child: child2,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget wChild1() {
    //点击后执行正向动画
    return GestureDetector(
      onTap: () {
        setState(() {
          _animating = true;
          _controller.forward();
        });
      },
      child: SizedBox(
        width: 50,
        child: ClipOval(child: Image.asset("imgs/avatar.png")),
      ),
    );
  }

  Widget wChild2() {
    // 点击后执行反向动画
    return GestureDetector(
      onTap: () {
        setState(() {
          _animating = true;
          _controller.reverse();
        });
      },
      child: Image.asset("imgs/avatar.png", width: 400),
    );
  }

  Rect _getRect(RenderAfterLayout renderAfterLayout) {
    //我们需要获取的是AfterLayout子组件相对于Stack的Rect
    return renderAfterLayout.localToGlobal(
          Offset.zero,
          //找到Stack对应的 RenderObject 对象
          ancestor: context.findRenderObject(),
        ) &
        renderAfterLayout.size;
  }
}
