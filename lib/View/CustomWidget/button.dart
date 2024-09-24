import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String title;
  Function()? onTap;
  double radius;
  TextStyle style;
  Color color;
  Size? minimumSize;
  Button({
    Key? key,
    required this.title,
    required this.onTap,
    required this.radius,
    required this.style,
    required this.color,
    this.minimumSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              minimumSize: minimumSize,
            ),
            onPressed: onTap,
            child: Text(title, textAlign: TextAlign.center, style: style),
          );
  }
}
