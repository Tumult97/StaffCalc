import 'package:flutter/material.dart';

class IconNumberInput extends StatelessWidget {

  final String labelText;
  final Function onChange;
  final Icon icon;


  IconNumberInput({this.labelText, this.onChange, this.icon});

  @override
  Widget build(BuildContext context) {
  return TextField(
    keyboardType: TextInputType.number,
      decoration: InputDecoration(
      border: OutlineInputBorder(
        gapPadding: 0,
      ),
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      icon: icon,
    ),
    onChanged: onChange,
  );
  }
}
