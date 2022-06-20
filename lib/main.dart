import 'dart:async';
import 'package:flutter/material.dart' hide Page;
import 'package:webview_flutter/webview_flutter.dart';
import 'common.dart';
import 'routes.dart';
import 'chapter14/draw_main.dart' as custom;
import 'package:flukit/flukit.dart';

void main() {
  // custom.main();
  runZoned(
    () => runApp(const MyApp()),
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        parent.print(zone, line);
        // Intercept `print` function and redirect log.
        logEmitter.value = LogInfo(false, line);
      },
      handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone,
          Object error, StackTrace stackTrace) {
        parent.print(zone, '${error.toString()} $stackTrace');
        // Redirect error log event when error.
        logEmitter.value = LogInfo(true, error.toString());
      },
    ),
  );

  var onError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    onError?.call(details);
    // Redirect error log event when error.
    logEmitter.value = LogInfo(true, details.toString());
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //platform: TargetPlatform.android,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _generateItem(BuildContext context, List<Page> children) {
    return children.map<Widget>((page) {
      return ListTile(
        title: Text(page.title),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () => page.openPage(context),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter实战'),
        ),
        body: ListView(
          children: <Widget>[
            ExpansionTile(
              title: const Text("第一个Flutter应用"),
              children: _generateItem(context, [
                Page("计数器", const CounterRoute(), withScaffold: false),
                Page("路由传值", const RouterTestRoute()),
                Page("State生命周期", const StateLifecycleTest()),
                Page("子树中获取State对象", const GetStateObjectRoute(),
                    withScaffold: false),
                Page("Cupertino Demo", const CupertinoTestRoute(),
                    withScaffold: false),
              ]),
            ),
            ExpansionTile(
              title: const Text("基础组件"),
              children: _generateItem(context, [
                // PageInfo("Context测试",  ContextRoute(), withScaffold: false),
                // PageInfo("Widget树中获取State对象",  RetrieveStateRoute(), withScaffold: false),
                Page("文本、字体样式", const TextRoute()),
                Page("按钮", const ButtonRoute()),
                Page("图片伸缩", const ImageAndIconRoute()),
                Page("ICON fonts", const IconFontsRoute()),
                Page("单选开关和复选框", const SwitchAndCheckBoxRoute()),
                Page("输入框", const FocusTestRoute(), showLog: false),
                Page("Form", const FormTestRoute(), showLog: false),
                Page("进度条", const ProgressRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("布局类组件"),
              children: _generateItem(context, [
                Page(
                  "约束",
                  const SizeConstraintsRoute(),
                  withScaffold: false,
                ),
                Page("Column居中", const CenterColumnRoute()),
                Page("流式布局", const WrapAndFlowRoute()),
                Page("层叠布局", const StackRoute()),
                Page("表格布局", const TableRoute()),
                Page("对齐及相对定位", const AlignRoute()),
                Page("LayoutBuilder", const LayoutBuilderRoute(), padding: false),
                Page("AfterLayout", const AfterLayoutRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("容器类组件"),
              children: _generateItem(context, [
                Page("填充Padding", const PaddingTestRoute()),
                Page("DecoratedBox", const DecoratedBoxRoute()),
                Page("变换", const TransformRoute()),
                Page("Container", const ContainerRoute()),
                Page("FittedBox", const FittedBoxRoute()),
                Page("剪裁", const ClipRoute()),
                Page(
                  "Scaffold、TabBar、底部导航",
                  const ScaffoldRoute(),
                  withScaffold: false,
                ),
              ]),
            ),
            ExpansionTile(
              title: const Text("可滚动组件"),
              children: _generateItem(context, [
                Page(
                  "SingleChildScrollView",
                  const SingleChildScrollViewTestRoute(),
                  padding: false,
                ),
                Page("InfiniteListView", const InfiniteListView(), padding: false),
                Page("可滚动组件的通用配置", const ScrollViewConfiguration()),
                Page("列表项固定高度列表", const FixedExtentList(), padding: false),
                Page("AnimatedList", const AnimatedListRoute(), padding: false),
                Page("InfiniteGridView", const InfiniteGridView(), padding: false),
                Page("PageView", const PageViewTest(), padding: false),
                Page("KeepAlive Test", const KeepAliveTest(), padding: false),
                Page("TabBarView", const TabViewRoute()),
                Page("滚动监听", const ScrollNotificationTestRoute(), padding: false),
                Page(
                  "CustomScrollView",
                  const CustomScrollViewTestRoute(),
                  padding: false,
                  showLog: false,
                ),
                Page(
                  "PersistentHeaderRoute",
                  const PersistentHeaderRoute(),
                  padding: false,
                  showLog: false,
                ),
                Page("SliverPersistentHeaderToBox",
                    const SliverPersistentHeaderToBoxRoute(),
                    padding: false),
                Page("SliverFlexibleHeader", const SliverFlexibleHeaderRoute(),
                    padding: false),
                Page("NestedScrollView", const NestedScrollViewRoute(),
                    padding: false),
                Page(
                  "PullRefresh",
                  const PullRefreshTestRoute(),
                  padding: false,
                ),
                Page(
                  "CustomPullRefresh",
                  const PullRefreshBoxRoute(),
                  padding: false,
                ),
                //PageInfo("pullrefresh",  PullRefreshRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("功能性组件"),
              children: _generateItem(context, [
                Page("导航返回拦截", const WillPopScopeTestRoute()),
                Page("数据共享(inheritedWidget)", const InheritedWidgetTestRoute()),
                Page("跨组件状态管理(Provider)", const ProviderRoute()),
                Page("颜色和MaterialColor", const ColorRoute(), withScaffold: false),
                Page("主题-Theme", const ThemeTestRoute(), withScaffold: false),
                Page("ValueListenableBuilder", const ValueListenableRoute(),
                    withScaffold: false),
                Page("FutureBuilder和StreamBuilder",
                    const FutureAndStreamBuilderRoute()),
                Page("对话框", const DialogTestRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("事件处理与通知"),
              children: _generateItem(context, [
                Page("原生指针事件", const PointerRoute(), padding: false),
                Page("手势识别", const GestureRoute(), padding: false),
                Page("PointerDownListener", const PointerDownListenerRoute()),
                Page("Stack 点击测试", const StackEventTest(),
                    padding: false, showLog: false),
                Page("通知(Notification)", const NotificationRoute()),
                Page("事件冲突", const EventConflictTest()),
              ]),
            ),
            ExpansionTile(
              title: const Text("动画"),
              children: _generateItem(context, [
                Page("放大动画-原始版", const ScaleAnimationRoute()),
                Page("放大动画-AnimatedWidget版", const ScaleAnimationRoute1()),
                Page("放大动画-AnimatedBuilder版", const ScaleAnimationRoute2()),
                Page("放大动画-GrowTransition版", const GrowTransitionRoute()),
                Page("Hero动画", const HeroAnimationRoute(), padding: false),
                Page("交织动画(Stagger Animation)", const StaggerRoute()),
                Page(
                    "动画切换组件(AnimatedSwitcher)", const AnimatedSwitcherCounterRoute()),
                Page("动画切换组件高级用法", const AnimatedSwitcherRoute()),
                Page("动画过渡组件", const AnimatedWidgetsTest()),
              ]),
            ),
            ExpansionTile(
              title: const Text("自定义组件"),
              children: _generateItem(context, [
                Page("GradientButton", const GradientButtonRoute()),
                Page("Material APP", const ScaffoldRoute(), withScaffold: false),
                Page("旋转容器：TurnBox", const TurnBoxRoute()),
                Page("CustomPaint", const CustomPaintRoute()),
                Page("自绘控件：圆形渐变进度条", const GradientCircularProgressRoute()),
                Page("自绘带动画控件：CustomCheckBox", const CustomCheckboxTest()),
                Page("自绘带动画控件：DoneWidget", const DoneWidgetTestRoute()),
                Page("水印", const WatermarkRoute(),
                    padding: false, showLog: false),
              ]),
            ),
            ExpansionTile(
              title: const Text("文件与网络"),
              children: _generateItem(context, [
                Page("文件操作", FileOperationRoute(), withScaffold: false),
                Page("Http请求", HttpTestRoute()),
                Page("WebSocket", WebSocketRoute(), withScaffold: false),
                Page("Socket", const SocketRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("其它"),
              children: _generateItem(context, [
                Page(
                  "WebView",
                  const WebViewTest(),
                  padding: false,
                  withScaffold: false,
                  //showLog: false,
                ),
              ]),
            ),
            ExpansionTile(
              title: const Text("Flutter原理"),
              children: _generateItem(context, [
                Page("图片加载原理与缓存", ImageInternalTestRoute()),
                Page("CustomCenter", const MyCenterRoute()),
                Page("LeftRightBox", const LeftRightBoxTestRoute()),
                Page("约束详解", const ConstraintsTest(), withScaffold: false),
                Page("AccurateSizedBox", const AccurateSizedBoxRoute()),
                Page("StateChangeTest", const StateChangeTest()),
                Page("RepaintBoundary", const RepaintBoundaryTest()),
                Page("CompositingBits Test", const CustomRotatedBoxTest()),
                Page("Paint原理", const PaintTest()),
              ]),
            ),

            // ExpansionTile(
            //   title: Text("包与插件"),
            //   children: _generateItem(context, [
            //     PageInfo("相机",  CameraExampleHome(),
            //         withScaffold: false),
            //     PageInfo(
            //         "PlatformView示例（webview）",  PlatformViewRoute(),
            //         padding: false),
            //   ]),
            // ),
          ],
        ));
  }
}
