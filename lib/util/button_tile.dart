import 'package:flutter/material.dart';

class ButtonTile extends StatelessWidget {
  final String text;
  final int boxColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ButtonTile({
    super.key,
    required this.text,
    required this.boxColor,
    required this.textColor,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Color(boxColor),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 20
        ),
      ),
    );
  }
}