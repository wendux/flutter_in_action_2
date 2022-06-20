import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTest extends StatefulWidget {
  const WebViewTest({Key? key}) : super(key: key);

  @override
  State<WebViewTest> createState() => _WebViewTestState();
}

class _WebViewTestState extends State<WebViewTest> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://m.baidu.com',
        onWebViewCreated: (controller) => _controller = controller,
        onProgress: (progress) => print(progress),
        onPageStarted: (url) => print('start loading: $url'),
        onPageFinished: (url) => print('load finished:$url'),
        onWebResourceError: (err)=>print(err.description),
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}
