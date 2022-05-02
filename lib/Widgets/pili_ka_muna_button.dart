import 'package:flutter/material.dart';
import 'package:kahit_saan/Constants/constants.dart';

class PiliKaButton extends StatelessWidget {
  PiliKaButton(
      {required this.text, required this.onPressed, required this.icon});

  final Icon icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 60,
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kbeige,
          onPrimary: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            icon,
            Text(
              text,
              style: kpiliButtons,
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
