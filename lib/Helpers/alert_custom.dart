import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';

void showAlertCustom(
    {required BuildContext context,
    Widget? title,
    Widget? content,
    required List<Widget> actions}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: title,
            content: content,
            actions: actions,
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: title,
            content: content,
            actions: actions,
            elevation: 2,
          );
        });
  }
}

// ignore: non_constant_identifier_names
Widget AlertButton({required Function() onTap,required Widget child}){
  if (Platform.isIOS){
    return CupertinoDialogAction(onPressed: onTap,child: child);
  } else {
    return ElevatedButton(onPressed: onTap, child: child);
  }
}
