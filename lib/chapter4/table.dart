import 'package:flutter/material.dart';

class TableRoute extends StatelessWidget {
  const TableRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Table(
          border: TableBorder.all(color: Colors.grey[400]!),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: _addPadding(
                [
                  const Text("姓名"),
                  const Text("性别"),
                  const Text("备注"),
                ],
              ),
            ),
            TableRow(
              children: _addPadding([
                const Text("张三"),
                const Text("男"),
                Text("我和李四不是兄弟" * 2),
              ]),
            ),
            TableRow(
              children: _addPadding([
                const Text("李四"),
                const Text("男"),
                const Text("不予置评"),
              ]),
            ),
          ],
        ),
        DataTable(
          sortColumnIndex: 0,
          sortAscending: true,
          rows: const <DataRow>[
            DataRow(
              cells: [
                DataCell(Text("1")),
                DataCell(Text("28.5")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("2")),
                DataCell(Text("27.5")),
              ],
            ),
          ],
          columns: <DataColumn>[
            DataColumn(
                label: const Text("Id"),
                numeric: true,
                onSort: (a, b) => print("$a $b")),
            const DataColumn(label: Text("价格￥"), numeric: true)
          ],
        ),
      ],
    );
  }

  _addPadding(List<Widget> w) {
    return w
        .map((e) => Padding(
              padding: const EdgeInsets.all(6),
              child: e,
            ))
        .toList();
  }
}
