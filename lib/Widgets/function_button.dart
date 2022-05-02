import 'package:flutter/material.dart';
import 'package:kahit_saan/Constants/constants.dart';

class FunctionButton extends StatelessWidget {
  FunctionButton(
      {required this.text, required this.onPressed, required this.icon});

  final Icon icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kbeige,
          onPrimary: kbrown,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: kfunctionButton,
              textAlign: TextAlign.center,
            ),
          ]
        ),
        onPressed: onPressed,
      ),
    );
  }
}
