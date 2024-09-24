/// Generated, built and configurated privately for Gramedia Asri Media projects
/// Any use of this content without permission will be a legal violation
/// ============================================================================
/// @author Samuel O R Napitupulu
/// @email samuel.napitupulu@gramedia.id
/// @create date 2022-03-26 23:20:56
/// @modify date 2022-03-30 02:38:20
/// @desc ePerpus Login Page and Functions
/// ============================================================================
/// Copyrigthed Gramedia Asri Media 2022
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Cubit/Auth/forgot_password_cubit.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/ui_helper.dart';

class ForgotPasswordView extends StatefulWidget {
  static const routeName = '/forgot_password';

  const ForgotPasswordView({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  bool isButtonDisable = true;

  onForgotPasswordButtonClicked() {}

  @override
  void initState() {
    super.initState();
    getLoginInfoCache();
  }

  Map<String, dynamic>? loginInfo;

  Future<void> getLoginInfoCache() async {
    String? loginInfoAsString = await getLoginInfo();
    if (loginInfoAsString != null) {
      loginInfo = json.decode(loginInfoAsString);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  void onListen() => setState(() {});

  Widget textFormField({
    required String labelText,
    String? validatorText,
    required String hintText,
    required String prefixImage,
    required TextEditingController controller,
    Widget? suffixWidget,
    bool? isObscuredText = false,
    Function(String)? onChanged,
    FocusNode? focusNode,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Platform.isAndroid
          ? TextFormField(
              focusNode: focusNode,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : CupertinoTextFormFieldRow(
              controller: controller,
              obscureText: isObscuredText!,
              placeholder: hintText,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyLarge,
              validator: (name) =>
                  name != null && name.length < 10 ? validatorText : null,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              prefix: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  bool isButtonEnable = false;

  Widget sendButton(AppLocalizations localization) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        if (state is ForgotPasswordLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return TextButton(
          onPressed: isButtonEnable
              ? () async {
            setState(() {
              isButtonEnable = false;
            });
            emailFocusNode.unfocus();
            UIHelper.showLoadingDialog(
                context, localization.forgotPasswordLoading);

            await context.read<ForgotPasswordCubit>().sendForgotPassword(
              context: context,
              username: emailController.text.trim(),
            );
            Future.delayed(const Duration(seconds: 1), () async {
              setState(() {
                isButtonEnable = true;
              });
            });
          }
              : null,
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            backgroundColor: isButtonEnable ? primaryColor : lightBlue,
            minimumSize: const Size(1000, 47),
          ),
          child: Text(
            localization.send,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
      listener: (context, state) async {
        if (state is ForgotPasswordSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          await Future.delayed(const Duration(seconds: 1), () {});

          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInUIForm.routeName,
                (Route<dynamic> route) => false,
          );
        } else if (state is ForgotPasswordError) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildEmailTextForm(AppLocalizations localization) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // ANCHOR - Email and Password TextFormField
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                textFormField(
                  focusNode: emailFocusNode,
                  controller: emailController,
                  labelText: 'Email',
                  hintText: AppLocalizations.of(context)!.enterEmail,
                  prefixImage: 'assets/icon_assets/ic_mail.png',
                  onChanged: (String text) {
                    setState(() {
                      isButtonEnable = emailController.text.isNotEmpty;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // ANCHOR - Sign In Button
          buildSendButton(localization),
        ],
      ),
    );
  }

  Widget buildSendButton(AppLocalizations localization) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: sendButton(localization),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // ANCHOR - Welcome Logo and Title
              Column(
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 67,
                    width: 151,
                    child: Image.asset(
                      "${ApiClient.instance.clientAssets}app_logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 72),
                  Text(
                    AppLocalizations.of(context)!.forgotPasswordTitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                  Text(
                    localization.forgotPasswordSubs,
                    style: paragraph4.apply(color: lightBlue),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // ANCHOR - Sign In Form
              buildEmailTextForm(localization),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
