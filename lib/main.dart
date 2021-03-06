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
          title: const Text('Flutter??????'),
        ),
        body: ListView(
          children: <Widget>[
            ExpansionTile(
              title: const Text("?????????Flutter??????"),
              children: _generateItem(context, [
                Page("?????????", const CounterRoute(), withScaffold: false),
                Page("????????????", const RouterTestRoute()),
                Page("State????????????", const StateLifecycleTest()),
                Page("???????????????State??????", const GetStateObjectRoute(),
                    withScaffold: false),
                Page("Cupertino Demo", const CupertinoTestRoute(),
                    withScaffold: false),
              ]),
            ),
            ExpansionTile(
              title: const Text("????????????"),
              children: _generateItem(context, [
                // PageInfo("Context??????",  ContextRoute(), withScaffold: false),
                // PageInfo("Widget????????????State??????",  RetrieveStateRoute(), withScaffold: false),
                Page("?????????????????????", const TextRoute()),
                Page("??????", const ButtonRoute()),
                Page("????????????", const ImageAndIconRoute()),
                Page("ICON fonts", const IconFontsRoute()),
                Page("????????????????????????", const SwitchAndCheckBoxRoute()),
                Page("?????????", const FocusTestRoute(), showLog: false),
                Page("Form", const FormTestRoute(), showLog: false),
                Page("?????????", const ProgressRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("???????????????"),
              children: _generateItem(context, [
                Page(
                  "??????",
                  const SizeConstraintsRoute(),
                  withScaffold: false,
                ),
                Page("Column??????", const CenterColumnRoute()),
                Page("????????????", const WrapAndFlowRoute()),
                Page("????????????", const StackRoute()),
                Page("????????????", const TableRoute()),
                Page("?????????????????????", const AlignRoute()),
                Page("LayoutBuilder", const LayoutBuilderRoute(), padding: false),
                Page("AfterLayout", const AfterLayoutRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("???????????????"),
              children: _generateItem(context, [
                Page("??????Padding", const PaddingTestRoute()),
                Page("DecoratedBox", const DecoratedBoxRoute()),
                Page("??????", const TransformRoute()),
                Page("Container", const ContainerRoute()),
                Page("FittedBox", const FittedBoxRoute()),
                Page("??????", const ClipRoute()),
                Page(
                  "Scaffold???TabBar???????????????",
                  const ScaffoldRoute(),
                  withScaffold: false,
                ),
              ]),
            ),
            ExpansionTile(
              title: const Text("???????????????"),
              children: _generateItem(context, [
                Page(
                  "SingleChildScrollView",
                  const SingleChildScrollViewTestRoute(),
                  padding: false,
                ),
                Page("InfiniteListView", const InfiniteListView(), padding: false),
                Page("??????????????????????????????", const ScrollViewConfiguration()),
                Page("???????????????????????????", const FixedExtentList(), padding: false),
                Page("AnimatedList", const AnimatedListRoute(), padding: false),
                Page("InfiniteGridView", const InfiniteGridView(), padding: false),
                Page("PageView", const PageViewTest(), padding: false),
                Page("KeepAlive Test", const KeepAliveTest(), padding: false),
                Page("TabBarView", const TabViewRoute()),
                Page("????????????", const ScrollNotificationTestRoute(), padding: false),
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
              title: const Text("???????????????"),
              children: _generateItem(context, [
                Page("??????????????????", const WillPopScopeTestRoute()),
                Page("????????????(inheritedWidget)", const InheritedWidgetTestRoute()),
                Page("?????????????????????(Provider)", const ProviderRoute()),
                Page("?????????MaterialColor", const ColorRoute(), withScaffold: false),
                Page("??????-Theme", const ThemeTestRoute(), withScaffold: false),
                Page("ValueListenableBuilder", const ValueListenableRoute(),
                    withScaffold: false),
                Page("FutureBuilder???StreamBuilder",
                    const FutureAndStreamBuilderRoute()),
                Page("?????????", const DialogTestRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("?????????????????????"),
              children: _generateItem(context, [
                Page("??????????????????", const PointerRoute(), padding: false),
                Page("????????????", const GestureRoute(), padding: false),
                Page("PointerDownListener", const PointerDownListenerRoute()),
                Page("Stack ????????????", const StackEventTest(),
                    padding: false, showLog: false),
                Page("??????(Notification)", const NotificationRoute()),
                Page("????????????", const EventConflictTest()),
              ]),
            ),
            ExpansionTile(
              title: const Text("??????"),
              children: _generateItem(context, [
                Page("????????????-?????????", const ScaleAnimationRoute()),
                Page("????????????-AnimatedWidget???", const ScaleAnimationRoute1()),
                Page("????????????-AnimatedBuilder???", const ScaleAnimationRoute2()),
                Page("????????????-GrowTransition???", const GrowTransitionRoute()),
                Page("Hero??????", const HeroAnimationRoute(), padding: false),
                Page("????????????(Stagger Animation)", const StaggerRoute()),
                Page(
                    "??????????????????(AnimatedSwitcher)", const AnimatedSwitcherCounterRoute()),
                Page("??????????????????????????????", const AnimatedSwitcherRoute()),
                Page("??????????????????", const AnimatedWidgetsTest()),
              ]),
            ),
            ExpansionTile(
              title: const Text("???????????????"),
              children: _generateItem(context, [
                Page("GradientButton", const GradientButtonRoute()),
                Page("Material APP", const ScaffoldRoute(), withScaffold: false),
                Page("???????????????TurnBox", const TurnBoxRoute()),
                Page("CustomPaint", const CustomPaintRoute()),
                Page("????????????????????????????????????", const GradientCircularProgressRoute()),
                Page("????????????????????????CustomCheckBox", const CustomCheckboxTest()),
                Page("????????????????????????DoneWidget", const DoneWidgetTestRoute()),
                Page("??????", const WatermarkRoute(),
                    padding: false, showLog: false),
              ]),
            ),
            ExpansionTile(
              title: const Text("???????????????"),
              children: _generateItem(context, [
                Page("????????????", FileOperationRoute(), withScaffold: false),
                Page("Http??????", HttpTestRoute()),
                Page("WebSocket", WebSocketRoute(), withScaffold: false),
                Page("Socket", const SocketRoute()),
              ]),
            ),
            ExpansionTile(
              title: const Text("??????"),
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
              title: const Text("Flutter??????"),
              children: _generateItem(context, [
                Page("???????????????????????????", ImageInternalTestRoute()),
                Page("CustomCenter", const MyCenterRoute()),
                Page("LeftRightBox", const LeftRightBoxTestRoute()),
                Page("????????????", const ConstraintsTest(), withScaffold: false),
                Page("AccurateSizedBox", const AccurateSizedBoxRoute()),
                Page("StateChangeTest", const StateChangeTest()),
                Page("RepaintBoundary", const RepaintBoundaryTest()),
                Page("CompositingBits Test", const CustomRotatedBoxTest()),
                Page("Paint??????", const PaintTest()),
              ]),
            ),

            // ExpansionTile(
            //   title: Text("????????????"),
            //   children: _generateItem(context, [
            //     PageInfo("??????",  CameraExampleHome(),
            //         withScaffold: false),
            //     PageInfo(
            //         "PlatformView?????????webview???",  PlatformViewRoute(),
            //         padding: false),
            //   ]),
            // ),
          ],
        ));
  }
}
