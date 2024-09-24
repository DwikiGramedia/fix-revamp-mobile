import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';

Future<dynamic> buildUnauthorizedDialog(
  BuildContext context, {
  required String title,
  required String content,
  required List<Widget> action,
}) async {
  if (Platform.isIOS) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialogNative(
            title: Text(title),
            content: Text(content),
            action: action,
          );
        });
  } else {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialogNative(
          title: Text(title),
          content: Text(content),
          action: action,
        );
      },
    );
  }
}
