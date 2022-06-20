import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class SocketRoute extends StatelessWidget {
  const SocketRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _request(),
      builder: (context, snapShot) {
        return Text(snapShot.data.toString());
      },
    );
  }

  _request() async {
    //建立连接
    var socket = await Socket.connect("baidu.com", 80);
    //根据http协议，发送请求头
    socket.writeln("GET / HTTP/1.1");
    socket.writeln("Host:baidu.com");
    socket.writeln("Connection:close");
    socket.writeln();
    await socket.flush(); //发送
    //读取返回内容，按照utf8解码为字符串
    String _response = await utf8.decoder.bind(socket).join();
    await socket.close();
    return _response;
  }
}
