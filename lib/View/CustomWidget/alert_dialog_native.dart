import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AlertDialogNative extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> action;

  AlertDialogNative(
      {Key? key,
      required this.title,
      required this.content,
      required this.action,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: title,
            content: content,
            actions: action,
          )
        : AlertDialog(
            title: title,
            content: content,
            actions: action,
            elevation: 2,
          );
  }
}
