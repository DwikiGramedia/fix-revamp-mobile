import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final String title;
  final Function() onTap;
  final double radius;
  final TextStyle style;
  final Color color;
  final Size? minimumSize;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final String? iconImage;
  const ButtonWithIcon({
    Key? key,
    required this.title,
    required this.onTap,
    required this.radius,
    required this.style,
    required this.color,
    this.minimumSize,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.iconImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            onPressed: onTap,
            child: Text(
              title,
              style: style,
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              minimumSize: minimumSize,
            ),
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: iconImage != null || icon != null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: iconImage != null
                        ? Image.asset(
                            iconImage!,
                            width: 16.67,
                            height: 16.67,
                          )
                        : Icon(
                            icon,
                            size: iconSize,
                            color: iconColor,
                          ),
                  ),
                ),
                Text(title, style: style),
              ],
            ),
          );
  }
}
