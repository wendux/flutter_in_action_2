import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:webview_flutter/webview_flutter.dart';
import '../common.dart';

class MarkdownRoute extends StatefulWidget {
  const MarkdownRoute({Key? key}) : super(key: key);

  @override
  _MarkdownRouteState createState() => _MarkdownRouteState();
}

class _MarkdownRouteState extends State<MarkdownRoute> {
  late Future<String> _codeFuture;
  bool _isLight = true;
  bool _showLineNumber = true;

  Future<String> _loadCode() async {
    return DefaultAssetBundle.of(context).loadString('assets/test.md');
  }

  @override
  void initState() {
    _codeFuture = _loadCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLight = !_isLight;
                });
              },
              child: Text(
                '切换为${_isLight ? '深色主题' : '浅色主题'}',
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 20)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showLineNumber = !_showLineNumber;
                });
              },
              child: Text(
                '${_showLineNumber ? '代码不' : ''}显示行号',
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: _codeFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return MarkdownWidget(
                  content: snapshot.data,
                  lineNumber: _showLineNumber,
                  baseUrl: 'https://book.flutterchina.club/',
                  brightness: _isLight ? Brightness.light : Brightness.dark,
                  javascriptChannels: {
                    JavascriptChannel(
                      name: 'bridge',
                      onMessageReceived: (JavascriptMessage message) {
                        String src = message.message.toLowerCase().trim();
                        // flutter暂不支持svg图片
                        if (!src.contains('.svg')) {
                          print(src);
                          viewImage(context, message.message);
                        }
                      },
                    ),
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }

  viewImage(context, String url) {
    Page(
      '查看图片',
      ScaleView(
        child: Image.network(url),
        parentScrollableAxis: null,
      ),
      showLog: false,
      padding: false,
    ).openPage(context);
  }
}
