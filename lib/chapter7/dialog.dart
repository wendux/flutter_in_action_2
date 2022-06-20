import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogTestRoute extends StatefulWidget {
  const DialogTestRoute({Key? key}) : super(key: key);

  @override
  _DialogTestRouteState createState() => _DialogTestRouteState();
}

class _DialogTestRouteState extends State<DialogTestRoute> {
  bool withTree = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            child: const Text("对话框1"),
            onPressed: () async {
              bool? deleteTree = await showDeleteConfirmDialog1();
              if (deleteTree == null) {
                print("取消删除");
              } else {
                print("已确认删除");
              }
            },
          ),
          ElevatedButton(
            child: const Text("对话框2"),
            onPressed: () async {
              bool? delete = await showDeleteConfirmDialog2();
              if (delete == null) {
                print("取消删除");
              } else {
                print("同时删除子目录: $delete");
              }
            },
          ),
          ElevatedButton(
            child: const Text("话框3（复选框可点击）"),
            onPressed: () async {
              bool? deleteTree = await showDeleteConfirmDialog3();
              if (deleteTree == null) {
                print("取消删除");
              } else {
                print("同时删除子目录: $deleteTree");
              }
            },
          ),
          ElevatedButton(
            child: const Text("话框3x（复选框可点击）"),
            onPressed: () async {
              bool? deleteTree = await showDeleteConfirmDialog3x();
              if (deleteTree == null) {
                print("取消删除");
              } else {
                print("同时删除子目录: $deleteTree");
              }
            },
          ),
          ElevatedButton(
            child: const Text("对话框4（复选框可点击）"),
            onPressed: () async {
              bool? deleteTree = await showDeleteConfirmDialog4();
              if (deleteTree == null) {
                print("取消删除");
              } else {
                print("同时删除子目录: $deleteTree");
              }
            },
          ),
          ElevatedButton(
            child: const Text("选择语言"),
            onPressed: () {
              changeLanguage();
            },
          ),
          ElevatedButton(
            child: const Text("显示列表对话框"),
            onPressed: () {
              showListDialog();
            },
          ),
          ElevatedButton(
            child: const Text("自定义对话框"),
            onPressed: () async {
              bool? deleteTree = await showDeleteConfirmDialog5();
              if (deleteTree == null) {
                print("取消删除");
              } else {
                print("已确认删除");
              }
            },
          ),
          ElevatedButton(
            child: const Text("显示底部菜单列表(模态)"),
            onPressed: () async {
              int? type = await _showModalBottomSheet();
              print(type);
            },
          ),
          ElevatedButton(
            child: const Text("显示Loading框"),
            onPressed: () async {
              showLoadingDialog();
            },
          ),
          ElevatedButton(
            child: const Text("打开Material风格的日历选择框"),
            onPressed: () async {
              _showDatePicker1();
            },
          ),
          ElevatedButton(
            child: const Text("打开iOS风格的日历选择框"),
            onPressed: () async {
              _showDatePicker2();
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("您确定要删除当前文件吗?"),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("删除"),
              onPressed: () {
                // 执行删除操作
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> changeLanguage() async {
    int? i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('请选择语言'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('中文简体'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('美国英语'),
                ),
              ),
            ],
          );
        });

    if (i != null) {
      print("选择了：${i == 1 ? "中文简体" : "美国英语"}");
    }
  }

  Future<void> showListDialog() async {
    int? index = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        var child = Column(
          children: <Widget>[
            const ListTile(title: Text("请选择")),
            Expanded(
                child: ListView.builder(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("$index"),
                  onTap: () => Navigator.of(context).pop(index),
                );
              },
            )),
          ],
        );
        //使用AlertDialog会报错
        //return AlertDialog(content: child);
        return Dialog(child: child);
      },
    );
    if (index != null) {
      print("点击了：$index");
    }
  }

  Future<bool?> showDeleteConfirmDialog2() {
    withTree = false;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("您确定要删除当前文件吗?"),
              Row(
                children: <Widget>[
                  const Text("同时删除子目录？"),
                  Checkbox(
                    value: withTree,
                    onChanged: (bool? value) {
                      setState(() {
                        withTree = !withTree;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("删除"),
              onPressed: () {
                // 执行删除操作
                Navigator.of(context).pop(withTree);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showDeleteConfirmDialog3() {
    bool _withTree = false; //记录复选框是否选中
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("您确定要删除当前文件吗?"),
              Row(
                children: <Widget>[
                  const Text("同时删除子目录？"),
                  DialogCheckbox(
                    value: _withTree, //默认不选中
                    onChanged: (bool? value) {
                      //更新选中状态
                      _withTree = !_withTree;
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("删除"),
              onPressed: () {
                // 将选中状态返回
                Navigator.of(context).pop(_withTree);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showDeleteConfirmDialog3x() {
    bool _withTree = false; //记录复选框是否选中
    //TargetPlatform.iOS;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("您确定要删除当前文件吗?"),
              Row(
                children: <Widget>[
                  const Text("同时删除子目录？"),
                  StatefulBuilder(
                    builder: (context, _setState) {
                      return Checkbox(
                        value: _withTree, //默认不选中
                        onChanged: (bool? value) {
                          _setState(() {
                            //更新选中状态
                            _withTree = !_withTree;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("删除"),
              onPressed: () {
                // 将选中状态返回
                Navigator.of(context).pop(_withTree);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showDeleteConfirmDialog4() {
    bool _withTree = false;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("您确定要删除当前文件吗?"),
              Row(
                children: <Widget>[
                  const Text("同时删除子目录？"),
                  Builder(
                    builder: (BuildContext context) {
                      return Checkbox(
                        value: _withTree,
                        onChanged: (bool? value) {
                          (context as Element).markNeedsBuild();
                          _withTree = !_withTree;
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("删除"),
              onPressed: () {
                // 执行删除操作
                Navigator.of(context).pop(_withTree);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showDeleteConfirmDialog5() {
    return showCustomDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("您确定要删除当前文件吗?"),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("删除"),
              onPressed: () {
                // 执行删除操作
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<int?> _showModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("$index"),
              onTap: () => Navigator.of(context).pop(index),
            );
          },
        );
      },
    );
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      //barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 26.0),
                    child: Text("正在加载，请稍后..."),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker1() {
    var date = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: date.add(
        const Duration(days: 30),
      ),
    );
  }

  Future<DateTime?> _showDatePicker2() {
    var date = DateTime.now();
    return showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: date,
            maximumDate: date.add(
              const Duration(days: 30),
            ),
            maximumYear: date.year + 1,
            onDateTimeChanged: (DateTime value) {
              print(value);
            },
          ),
        );
      },
    );
  }

  Future<T?> showCustomDialog<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    required WidgetBuilder builder,
    ThemeData? theme,
  }) {
    return showGeneralDialog<T>(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return Theme(data: theme ?? Theme.of(context), child: pageChild);
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}

// 单独封装一个内部管理选中状态的复选框组件
class DialogCheckbox extends StatefulWidget {
  const DialogCheckbox({
    Key? key,
    this.value,
    required this.onChanged,
  }):super(key:key);

  final ValueChanged<bool?> onChanged;
  final bool? value;

  @override
  _DialogCheckboxState createState() => _DialogCheckboxState();
}

class _DialogCheckboxState extends State<DialogCheckbox> {
  bool? value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (v) {
        //将选中状态通过事件的形式抛出
        widget.onChanged(v);
        setState(() {
          //更新自身选中状态
          value = v;
        });
      },
    );
  }
}
