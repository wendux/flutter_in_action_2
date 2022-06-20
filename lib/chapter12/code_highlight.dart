import 'package:flutter/material.dart';
import '../common.dart';

class CodeHighlightRoute extends StatefulWidget {
  const CodeHighlightRoute({Key? key}) : super(key: key);

  @override
  _CodeHighlightRouteState createState() => _CodeHighlightRouteState();
}

class _CodeHighlightRouteState extends State<CodeHighlightRoute> {
  late Future<String> _codeFuture;
  bool _isLight = true;
  bool _showLineNumber = true;

  Future<String> _loadCode() async {
    return DefaultAssetBundle.of(context)
        .loadString('assets/sliver_flexible_header.dart');
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
                '${_showLineNumber ? '不' : ''}显示行号',
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: _codeFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CodeHighlight(
                  code: snapshot.data,
                  lineNumber: _showLineNumber,
                  theme: const HighlightTheme(common: 'body{font-size:15px}'),
                  brightness: _isLight ? Brightness.light : Brightness.dark,
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}
