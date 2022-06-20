import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CodeHighlight extends _BaseWidget {
  const CodeHighlight({
    Key? key,
    String? code,
    bool lineNumber = false,
    Brightness? brightness,
    WebViewCreatedCallback? onRendered,
    HighlightTheme? theme,
    String? baseUrl,
  }) : super(
          key: key,
          content: code,
          lineNumber: lineNumber,
          brightness: brightness,
          onRendered: onRendered,
          theme: theme,
          baseUrl: baseUrl,
        );

  @override
  _CodeHighlightState createState() => _CodeHighlightState();
}

class _CodeHighlightState extends _BaseState<CodeHighlight> {
  @override
  String render({
    required String style,
    required String js,
    String content = '',
    String baseUrl = '',
    bool lineNumber = false,
  }) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport"
          content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <style>$style</style>
</head>
<body id='body'>

<pre id='pre' style='display:none'><code id='code'>$content
</code></pre>
<script>$js</script>
</body>
<script>
  if($lineNumber) {
    \$('pre code').each(function () {
      \$(this).addClass('has-numbering');
      var lines = \$(this).text().split('\\n').length;
      var \$numbering = \$('<ul/>').addClass('line-no fonts hljs').before(this);
      for (var i = 1; i < lines; i++) {
        \$numbering.append(\$('<li/>').text(i));
      }
    });
  }
  hljs.highlightElement(document.getElementById('code'));
  document.getElementById('pre').style.display='block';
</script>
</html>
  ''';
  }
}

class MarkdownWidget extends _BaseWidget {
  const MarkdownWidget({
    Key? key,
    String? content,
    bool lineNumber = false,
    String? baseUrl,
    Brightness? brightness,
    HighlightTheme? theme,
    WebViewCreatedCallback? onRendered,
    NavigationDelegate? navigationDelegate,
    Set<JavascriptChannel>? javascriptChannels,
  }) : super(
          key: key,
          content: content,
          lineNumber: lineNumber,
          baseUrl: baseUrl,
          brightness: brightness,
          onRendered: onRendered,
          navigationDelegate: navigationDelegate,
          javascriptChannels: javascriptChannels,
          theme: theme,
        );

  @override
  _MarkdownWidgetState createState() => _MarkdownWidgetState();
}

class _MarkdownWidgetState extends _BaseState<MarkdownWidget> {
  @override
  Future<String> get jsFuture {
    return Future.wait([
      super.jsFuture,
      loadAsset('marked.js'),
    ]).then((list) => list.join('\r\n'));
  }

  @override
  Future<String> get cssFuture async {
    String str = await super.cssFuture;
    str += _markdownTheme.common;
    str += (isLight ? _markdownTheme.light : _markdownTheme.dark);
    return str;
  }

  @override
  String render({
    required String style,
    required String js,
    String content = '',
    String baseUrl = '',
    bool lineNumber = false,
  }) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport"
          content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <base href="$baseUrl" />
    <style>$style</style>
</head>
<body>
<div id="markdown" style="display: none">$content</div>
<div id="body"></div>
<script>$js</script>
</body>
<script>
  marked.setOptions({
    renderer: new marked.Renderer(),
    highlight: function (code, lang) {
      var language = hljs.getLanguage(lang) ? lang : 'js';
      return hljs.highlight(code, {language}).value;
    },
    langPrefix: 'hljs language-',
    pedantic: false,
    gfm: true,
    breaks: false,
    smartLists: true,
    smartypants: false,
    xhtml: false
  });
  
  marked.use({
   renderer:{
      image:function (href,title,text){
        return '<div class="img"><img src="'+href+'"/><div class="img-text">'+text+'</div></div>'
      }
    }
  });
  var str = marked(document.getElementById('markdown').innerText);
  document.getElementById('body').innerHTML = str;
  \$('img').click(function(){
   bridge.postMessage(this.currentSrc)
  })
  if($lineNumber) {
    \$('pre code').each(function () {
      \$(this).addClass('has-numbering');
      var lines = \$(this).text().split('\\n').length;
      var \$numbering = \$('<ul/>').addClass('line-no fonts hljs').before(this);
      for (var i = 1; i < lines; i++) {
        \$numbering.append(\$('<li/>').text(i));
      }
    });
  }
</script>
</html>
  ''';
  }

  final HighlightTheme _markdownTheme = const HighlightTheme(
    common: '''
  body{
    font-size: 15px;
    line-height: 1.6;
    padding:10px 0;
  }
  
  blockquote{
   margin: 1em;
  }

  blockquote p{
    padding: 10px;
  }

  h1, h2, h3, h4, h5, h6 {
    padding: 10px;
  }

  a{
    padding: 0 2px;
  }

  p{
    line-height: 1.6;
    padding: .5em 1em;
  }

  ul{
    padding-left:35px;
  }
 
  li{
    padding:5px 1em 5px 0;
    line-height: 1.5;
  }
  .img{
    text-align: center;
  }

  .img-text{
    font-size: .8em ;
    color: #aaa;
  }

  img{
     max-width:calc(100% - 2em) ;
     padding: 1em;
  }
    table{
    border-collapse: collapse;
    margin: 1rem 0;
    display: block;
    overflow-x: auto;
  }

  tr {
    border-top: 1px solid #dfe2e5;
  }

  tr:last-child{
    border-bottom: 1px solid #dfe2e5;
  }
  
  td, th {
    border-top: 1px solid #dfe2e5;
    border-right: 1px solid #dfe2e5;
    padding: .6em .6em;
    min-width: 3em;
  }

  td:last-child, th:last-child{
    border-right:none;
  }
  ''',
    light: '''
   body {
    color: #444;
   }
   blockquote{
    border-left: #027bf3 3px solid;
   }
   blockquote p{
    color: #777;
    background: #f6f6f6
   }
   a{
    color: #027bf3;
   }
   tr:nth-child(2n) {
    background-color: #f6f8fa;
   }
  ''',
    dark: '''
   body {
    background-color: #444;
    color: #aaa;
   }
   blockquote{
    border-left: #aaa 3px solid;
   } 
   a{
    color: #ddd;
   }
  ''',
  );
}

class HighlightTheme {
  const HighlightTheme({this.light = '', this.dark = '', this.common = ''});

  final String light;
  final String dark;
  final String common;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return (other is HighlightTheme) &&
        light == other.light &&
        dark == other.dark &&
        common == other.common;
  }

  @override
  int get hashCode => hashValues(light, dark);
}

abstract class _BaseWidget extends StatefulWidget {
  const _BaseWidget({
    Key? key,
    this.content,
    this.lineNumber = false,
    this.brightness,
    this.onRendered,
    this.navigationDelegate,
    this.theme,
    this.javascriptChannels,
    this.baseUrl,
  }) : super(key: key);

  final String? content;
  final bool lineNumber;
  final Brightness? brightness;
  final WebViewCreatedCallback? onRendered;
  final NavigationDelegate? navigationDelegate;
  final HighlightTheme? theme;
  final Set<JavascriptChannel>? javascriptChannels;
  final String? baseUrl;
}

abstract class _BaseState<T extends _BaseWidget> extends State<T> {
  WebViewController? _controller;
  final _dir = 'assets';
  bool _isLightOld = true;

  bool get _hasContent => widget.content?.isNotEmpty == true;
  int _lastX = 0;
  int _lastY = 0;

  bool get isLight =>
      (widget.brightness ?? Theme.of(context).brightness) == Brightness.light;

  Future<String> loadAsset(String key) {
    return DefaultAssetBundle.of(context).loadString('$_dir/$key');
  }

  Future<String> get cssFuture {
    return loadAsset('stackoverflow_${_isLightOld ? 'light' : 'dark'}.css')
        .then((value) => value + _codeStyle);
  }

  Future<String>? _cssFuture;

  Future<String> get jsFuture {
    return Future.wait([
      loadAsset('highlight.js'),
      loadAsset('neat.js'),
    ]).then((value) => value.join('\r\n'));
  }

  Future<String>? _jsFuture;

  _ensureAssetsLoaded(context) {
    if (_hasContent) {
      _cssFuture ??= cssFuture.then((str) {
        if (widget.theme != null) {
          str += widget.theme!.common;
          str += (isLight ? widget.theme!.light : widget.theme!.dark);
        }
        return str;
      });
      _jsFuture ??= jsFuture;
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    bool themeChanged = widget.theme != oldWidget.theme;
    bool contentChanged = widget.content != oldWidget.content;
    if (isLight != _isLightOld || themeChanged) {
      _isLightOld = isLight;
      _cssFuture = null;
    }
    if (contentChanged ||
        themeChanged ||
        widget.lineNumber != oldWidget.lineNumber ||
        widget.brightness != oldWidget.brightness) {
      _ensureAssetsLoaded(context);
      _loadUrl(!contentChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  _loadUrl([bool recoverScrollOffset = false]) async {
    final content =
        widget.content!.replaceAll('<', '&lt;').replaceAll('>', '&gt;');

    String str = render(
      style: await _cssFuture!,
      js: await _jsFuture!,
      content: content,
      baseUrl: widget.baseUrl ?? '',
      lineNumber: widget.lineNumber,
    );
    str = base64Encode(const Utf8Encoder().convert(str));
    str = 'data:text/html;base64,$str';

    if (recoverScrollOffset) {
      final result = await Future.wait([
        _controller!.getScrollX(),
        _controller!.getScrollY(),
      ]);
      _lastX = result[0];
      _lastY = result[1];
    }
    return _controller?.loadUrl(str);
  }

  String render({
    required String style,
    required String js,
    String content = '',
    String baseUrl = '',
    bool lineNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    _isLightOld = isLight;
    _ensureAssetsLoaded(context);
    if (!_hasContent) return Container();
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) async {
        _controller = controller;
        _loadUrl();
      },
      onPageFinished: (url) {
        _controller!.scrollTo(_lastX, _lastY);
        widget.onRendered?.call(_controller!);
      },
      navigationDelegate: widget.navigationDelegate,
      javascriptChannels: widget.javascriptChannels,
    );
  }

  static const String _codeStyle = '''
    body{
    font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen,Ubuntu,Cantarell,Fira Sans,Droid Sans,Helvetica Neue,sans-serif;
    -webkit-font-smoothing: antialiased;
    font-size: 15px;
    }
    
    * {
      margin: 0
    }
    
    pre {
      position: relative;
      overflow: hidden;
    }

    .fonts, code {
      font-family: source-code-pro, Menlo, Monaco, Consolas, Courier New, monospace;
      font-size: .85em;
      line-height: 1.5;
    }

    .line-no {
      float: left;
      padding: 1em 2px;
      background-size: 1px 100% !important;
      background-repeat: no-repeat !important;
      background-position: top right !important;
      background-image: linear-gradient(90deg, #C3CCD0, #C3CCD0 50%, transparent 50%) !important;
      // background-color:#ddd ;
      text-align: center;
      color: #AAA;
      margin: 0;
    }

    .line-no li {
      list-style: none;
      padding:0;
      line-height:1.5;
    }
  ''';
}
