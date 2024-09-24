import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/home_view.dart';

void showUnauthorizedDialog(
  BuildContext context,
  AppLocalizations localization,
) {
  void navigateSignIn() {
    print("context: $context");
    print("localization: $localization");
    Navigator.pop(context);
    Navigator.pushReplacementNamed(
      context,
      SignInUIForm.routeName,
    );
  }

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialogNative(
          title: Text(localization.unauthorized),
          content: Text(localization.unauthorizedText),
          action: [
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () async {
                await UserService().logout();
                print("context: $context");
                print("localization: $localization");
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  SignInUIForm.routeName,
                );
              },
            )
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogNative(
          title: Text(localization.forceLogout),
          content: Text(localization.unauthorizedText),
          action: [
            Button(
              title: AppLocalizations.of(context)!.close,
              onTap: () async {
                await UserService().logout();
                print("context: $context");
                print("localization: $localization");
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  SignInUIForm.routeName,
                );
              },
              radius: 12,
              color: Colors.green,
              style: h6Title,
            )
          ],
        );
      },
    );
  }
}
