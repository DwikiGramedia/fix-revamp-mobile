import 'dart:io' as change_password_view;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Library/product_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/user_cubit.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';

class ChangePasswordView extends StatefulWidget {
  static const routeName = '/changePassword';
  ChangePasswordView({Key? key, this.isDark}) : super(key: key);

  int? isDark;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePasswordViewState();
  }
}

class ChangePasswordViewState extends State<ChangePasswordView> {
  bool isPasswordShowed = false;
  bool isNewPasswordShowed = false;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool isButtonEnabled = false;
  Widget textFormField({
    required String labelText,
    String? validatorText,
    required String hintText,
    required String prefixImage,
    required TextEditingController controller,
    Widget? suffixWidget,
    bool? isObscuredText = false,
    bool isEnabled = false,
    Function(String)? onChanged,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Platform.isAndroid
          ? TextFormField(
              enabled: isEnabled,
              onChanged: onChanged,
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              obscureText: isObscuredText!,
              validator: (name) =>
                  name != null && name.length < 10 ? validatorText : null,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                floatingLabelStyle: const TextStyle(color: Colors.transparent),
                prefixIcon: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  height: 20,
                  width: 20,
                  child: Image.asset(
                    prefixImage,
                    fit: BoxFit.contain,
                  ),
                ),
                suffixIcon: suffixWidget,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : CupertinoTextFormFieldRow(
              enabled: isEnabled,
              controller: controller,
              obscureText: isObscuredText!,
              placeholder: hintText,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyText1,
              validator: (name) =>
                  name != null && name.length < 10 ? validatorText : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              prefix: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                height: 20,
                width: 20,
                child: Image.asset(
                  prefixImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    final bool isDark = widget.isDark == 1;
    final localization = AppLocalizations.of(context)!;

    Widget saveChange() {
      return BlocConsumer<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Button(
            color: primaryColor,
            title: localization.saveChanges,
            onTap: () {
              if (currentPasswordController.text ==
                  newPasswordController.text) {
                if (Platform.isIOS) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialogNative(
                        title: Text(localization.passwordCannotSame),
                        content: Text(localization.changeNewPassword),
                        action: [
                          CupertinoDialogAction(
                            child: Text(localization.close),
                            onPressed: () {
                              Navigator.pop(context);
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
                          title: Text(localization.changeNewPassword),
                          content: Text(localization.changeNewPassword),
                          action: [
                            Button(
                              title: localization.close,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              radius: 12,
                              style: h6Title,
                              color: primaryColor,
                            )
                          ],
                        );
                      });
                }
              } else {
                context.read<UserCubit>().change(
                      currentPassword: currentPasswordController.text.trim(),
                      newPassword: newPasswordController.text.trim(),
                      context: context,
                    );
              }
            },
            radius: 12,
            style: h4Title.copyWith(color: Colors.white),
          );
        },
        listener: (context, state) {
          if (state is UserChangePasswordSuccess) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialogNative(
                    title: const Text("Success"),
                    content: const Text("Please Sign in"),
                    action: [
                      Button(
                        title: localization.close,
                        onTap: () {
                          context.read<UserCubit>().logout();
                          context.read<ProductCubit>().urlProduct = "";
                          context.read<ProductCubit>().catalogTitle = "";
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            SignInUIForm.routeName,
                            (route) => false,
                          );
                        },
                        radius: 12,
                        style: h6Title,
                        color: primaryColor,
                      )
                    ],
                  );
                });
          } else if (state is UserFailed) {
            change_password_view.Platform.isAndroid
                ? showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialogNative(
                        title: const Text("Failed"),
                        content: Text(state.error),
                        action: [
                          Button(
                            title: localization.close,
                            onTap: () => Navigator.pop(context),
                            radius: 12,
                            style: h6Title,
                            color: primaryColor,
                          )
                        ],
                      );
                    },
                  )
                : showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(localization.failed),
                        content: Text(state.error),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(localization.close),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      );
                    },
                  );
          }
        },
      );
    }

    return WillPopScope(
        onWillPop: () async {
          context.read<UserCubit>().getDataUser(context);
          Navigator.pop(context);
          return false;
        },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Platform.isIOS
              ? Theme.of(context).cardColor
              : const Color(0xFF091A33),
          backgroundColor: Platform.isIOS
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.transparent,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.changePassword,
            style: h3Title.apply(color: isDark ? Colors.white : Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              context.read<UserCubit>().getDataUser(context);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left),
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        body: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  textFormField(
                    isEnabled: true,
                    isObscuredText: !isPasswordShowed,
                    suffixWidget: SizedBox(
                      width: 20,
                      height: 20,
                      child: GestureDetector(
                        child: (isPasswordShowed)
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                        onTap: () => setState(() {
                          isPasswordShowed = !isPasswordShowed;
                        }),
                      ),
                    ),
                    controller: currentPasswordController,
                    labelText: localization.enterCurrentPassword,
                    hintText: localization.enterCurrentPassword,
                    prefixImage: 'assets/icon_assets/ic_lock.png',
                    onChanged: (String text) {
                      setState(() {
                        isButtonEnabled = newPasswordController.text.isNotEmpty &&
                            currentPasswordController.text.isNotEmpty &&
                            currentPasswordController.text.length >= 6;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  textFormField(
                    isEnabled: true,
                    isObscuredText: !isNewPasswordShowed,
                    suffixWidget: SizedBox(
                      width: 20,
                      height: 20,
                      child: GestureDetector(
                        child: (isNewPasswordShowed)
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                        onTap: () => setState(() {
                          isNewPasswordShowed = !isNewPasswordShowed;
                        }),
                      ),
                    ),
                    controller: newPasswordController,
                    labelText: localization.enterNewPassword,
                    hintText: localization.enterNewPassword,
                    prefixImage: 'assets/icon_assets/ic_lock.png',
                    onChanged: (String text) {
                      setState(() {
                        isButtonEnabled = newPasswordController.text.isNotEmpty &&
                            currentPasswordController.text.isNotEmpty &&
                            currentPasswordController.text.length >= 6;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    child: Image.asset('assets/images/changePasswordImage.png'),
                  ),
                  SizedBox(
                    height: size.height * 0.18,
                  ),
                  SizedBox(width: size.width, height: 48, child: saveChange())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
