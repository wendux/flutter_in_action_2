import 'package:flutter/material.dart';

import 'custom_checkbox.dart';
import 'custom_checkbox_2.dart';

class CustomCheckboxTest extends StatefulWidget {
  const CustomCheckboxTest({Key? key}) : super(key: key);

  @override
  State<CustomCheckboxTest> createState() => _CustomCheckboxTestState();
}

class _CustomCheckboxTestState extends State<CustomCheckboxTest> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCheckbox2(
            value: _checked,
            onChanged: _onChange,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CustomCheckbox(
                strokeWidth: 1,
                radius: 1,
                value: _checked,
                onChanged: _onChange,
              ),
            ),
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: CustomCheckbox(
              strokeWidth: 3,
              radius: 3,
              value: _checked,
              onChanged: _onChange,
            ),
          ),
        ],
      ),
    );
  }

  void _onChange(value) {
    setState(() => _checked = value);
  }
}
