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

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:revamp_eperpus_mobile/Cubit/user_cubit.dart';
import 'package:revamp_eperpus_mobile/Service/watermark_service.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/ForgotPassword/forgot_password_view.dart';
import 'package:revamp_eperpus_mobile/View/SignUp/signup_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/apptracking_helper.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/route_helper.dart';
import 'package:revamp_eperpus_mobile/Helpers/ui_helper.dart';
import 'package:revamp_eperpus_mobile/home_view.dart';
import 'package:revamp_eperpus_mobile/model/Analytic/OpenAppAnalyticModel.dart';
import 'package:revamp_eperpus_mobile/model/Watermark/WatermarkResponse.dart';
import 'package:upgrader/upgrader.dart';

class SignInUIForm extends StatefulWidget {
  static const routeName = '/signin';
  const SignInUIForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInUIForm> createState() => _SignInUIFormState();
}

class _SignInUIFormState extends State<SignInUIForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  bool isOpenRegis = false;

  bool isPasswordShowed = false;
  bool isButtonDisable = true;

  onSignInButtonClicked() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      UIHelper.showLoadingDialog(context, 'Authenticating your account');

      await Future.delayed(const Duration(seconds: 4), () {});

      Navigator.pop(context);

      await Future.delayed(const Duration(seconds: 1), () {});

      Navigator.pushAndRemoveUntil(
        context,
        RouteHelper.createRoute(const HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> initPlatformSite() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    // Import package

// Show tracking authorization dialog and ask for permission
    AppTrackingHelper().requestTracking();
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': '',
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  void onForgotPasswordButtonClicked() {
    Navigator.pushNamed(
      context,
      ForgotPasswordView.routeName,
    );
  }

  Future<void> passwordFocusNodeListener() async {
    if (passwordFocusNode.hasFocus) {
      await debugLog('TextField got the focus');
    } else {
      await debugLog('TextField lost the focus');
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformSite();
    context.read<UserCubit>().getOpenRegistration();
    emailController.addListener(onListen);
    passwordFocusNode.addListener(passwordFocusNodeListener);
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
    emailController.removeListener(onListen);
    passwordFocusNode.removeListener(passwordFocusNodeListener);
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
              style: Theme.of(context).textTheme.bodyText1,
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

  @override
  Widget build(BuildContext context) {
    Widget setupArea(Widget child) {
      if (Platform.isIOS) {
        return child;
      } else {
        return SafeArea(child: child);
      }
    }

    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: Platform.isIOS ? SystemUiOverlayStyle.dark : null,
      ),
      body: BlocConsumer<UserCubit, UserState>(
        builder: (context, state) {
          return setupArea(SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // ANCHOR - Welcome Logo and Title
                Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: FlavorConfig.instance.values.isLogoStretch!
                          ? 64
                          : 151,
                      width: 151,
                      child: Image.asset(
                        logoImage(
                          organization: ApiClient.instance.baseOrganizationId,
                        ),
                        fit: FlavorConfig.instance.values.isLogoStretch!
                            ? BoxFit.cover
                            : BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      AppLocalizations.of(context)!.titleLogin,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                    Text(
                      localization.signInToContinue,
                      style: paragraph4.apply(color: lightBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ANCHOR - Sign In Form
                signInForm(localization),

                // ANCHOR - Sign Up Button and Prompt
                const SizedBox(height: 12),
                Visibility(
                  visible: isOpenRegis,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: RichText(
                      text: TextSpan(
                        style: paragraph4.apply(color: ashBlue),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "${AppLocalizations.of(context)!.dontHaveAccount}  "),
                          TextSpan(
                            text: AppLocalizations.of(context)!.register,
                            style: paragraph4.copyWith(
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  SignUpPage.routeName,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ));
        },
        listener: (context, state) {
          if (state is UserNeedVerification) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialogNative(
                  title: Text(
                    localization.loginUnVerifiedTitle,
                    style: h4Title,
                  ),
                  content: Text(
                    localization.loginUnVerifiedSubTitle,
                    style: subhead2,
                  ),
                  action: [
                    Visibility(
                      visible: state.errorCode != null,
                      child: Button(
                        title: localization.resendVerify,
                        onTap: () async {
                          Navigator.pop(context);

                          await context.read<UserCubit>().resendVerification(
                                context: context,
                                username: emailController.text.trim(),
                              );
                        },
                        radius: 12,
                        style: h6Title.copyWith(color: primaryColor),
                        color: Colors.transparent,
                      ),
                    ),
                    Button(
                      title: localization.close,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      radius: 12,
                      style: h6Title.copyWith(color: Colors.red),
                      color: Colors.transparent,
                    ),
                  ],
                );
              },
            );
          }
          if (state is IsUserRegistrationShown) {
            setState(() {
              isOpenRegis = state.content.isActive;
              setIsOpenRegis(isOpenRegis);
            });
          }
          if (state is IsGetUserQuotaSuccess) {
            Navigator.pushNamed(
              context,
              SignUpPage.routeName,
            );
          }
          if (state is IsGetUserQuotaError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialogNative(
                  title: Text(AppLocalizations.of(context)!.unauthorized),
                  content: Text(AppLocalizations.of(context)!.unauthorizedText),
                  action: [
                    Button(
                      title: AppLocalizations.of(context)!.close,
                      onTap: () {
                        Navigator.pop(context);
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
        },
      ),
    );
  }

  Widget buttonDeAuthorize(AppLocalizations localization) {
    return BlocConsumer<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Platform.isAndroid
          ? Button(
              title: AppLocalizations.of(context)!.remove,
              onTap: () {
                context.read<UserCubit>().deauthorize(
                      username: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      versionOS: Platform.isIOS
                          ? _deviceData['systemVersion'] ?? ""
                          : _deviceData['version.codename'] ?? "",
                      modelDevice: _deviceData['model'],
                    );
                setState(() {
                  isButtonSignInEnabled = true;
                });
              },
              radius: 8,
              style: h6Title,
              color: Colors.red,
            )
          : CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.remove),
              onPressed: () {
                context.read<UserCubit>().deauthorize(
                      username: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      versionOS: Platform.isIOS
                          ? _deviceData['systemVersion'] ?? ""
                          : _deviceData['version.codename'] ?? "",
                      modelDevice: _deviceData['model'],
                    );
              },
            );
    }, listener: (context, state) {
      if (state is UserDeauthorized) {
        isButtonSignInEnabled = true;
        Navigator.pop(context);
      } else if (state is UserFailed) {
        final String titleText = state.error.contains("host")
            ? localization.offlineLogin
            : state.error;
        final String infoText = state.error.contains("host")
            ? localization.offlineLoginInfo
            : state.error;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialogNative(
              title: Text(
                titleText,
                style: h4Title,
              ),
              content: Text(
                infoText,
                style: subhead2,
              ),
              action: [
                Button(
                  title: localization.close,
                  onTap: () => Navigator.pop(context),
                  radius: 12,
                  style: h6Title.copyWith(color: Colors.red),
                  color: Colors.transparent,
                )
              ],
            );
          },
        );
      }
    });
  }

  Future<void> getWatermarkData(String userEmail) async {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyy');
    String formattedDate = formatter.format(now);
    String watermarkCode = "";
    try {
      WatermarkResponse watermark = await WatermarkService().getWatermark();
      debugPrint("WATERMARK from ENDPOINT: ${watermark.toJson().toString()}");
      watermarkCode = "$userEmail/$formattedDate/${watermark.code}";

      debugPrint("WATERMARK: $watermarkCode");
      await setWatermark(watermarkCode);
    } catch (e, s) {
      debugPrint("WATERMARK EXCEPTION: $e");
      debugPrint("WATERMARK STACKTRACE: $s");

      watermarkCode =
          "$userEmail/$formattedDate/${ApiClient.instance.watermark}";
      await setWatermark(watermarkCode);
    }
  }

  void onLoginPressed({IosDeviceInfo? iosInfo}) {
    context.read<UserCubit>().login(
          context,
          username: emailController.text.trim(),
          password: passwordController.text.trim(),
          clientId: "${ApiClient.instance.clientId}",
          deviceId:
              "${Platform.isIOS ? iosInfo?.identifierForVendor : _deviceData['id'] ?? ""}",
          versionOS: Platform.isIOS
              ? iosInfo?.systemVersion
              : _deviceData['version.codename'] ?? "",
          modelDevice: _deviceData['model'] ?? "",
        );
  }

  bool isButtonSignInEnabled = false;
  Widget buttonSignIn(AppLocalizations localization) {
    return BlocConsumer<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return TextButton(
          onPressed: isButtonSignInEnabled
              ? () async {
                  setState(() {
                    isButtonSignInEnabled = false;
                  });
                  passwordFocusNode.unfocus();
                  if (formKey.currentState!.validate()) {
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    IosDeviceInfo? iosInfo;
                    if (Platform.isIOS) {
                      iosInfo = await deviceInfo.iosInfo;
                    }
                    onLoginPressed(iosInfo: iosInfo);
                  }
                  Future.delayed(const Duration(seconds: 1), () async {
                    setState(() {
                      isButtonSignInEnabled = true;
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
            backgroundColor: isButtonSignInEnabled ? primaryColor : lightBlue,
            minimumSize: const Size(1000, 47),
          ),
          child: Text(
            AppLocalizations.of(context)!.login,
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
        if (state is UserLoginSuccess) {
          //Navigator.pop(context);
          //String ipAddress = await AnalyticService().getIpAddress();
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          IosDeviceInfo? iosInfo;
          if (Platform.isIOS) {
            iosInfo = await deviceInfo.iosInfo;
          }
          var date =
              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
          OpenAppAnalytic data = OpenAppAnalytic(
              sessionName: date,
              ipAddresss: "192.0.1.2",
              deviceModel: _deviceData['model'] ?? "model",
              dateTime: date.toString(),
              clientVersion: "3.0.0",
              deviceId:
                  "${Platform.isIOS ? iosInfo?.identifierForVendor : _deviceData['id'] ?? ""}",
              userId: state.user.id ?? 0,
              organizationId: ApiClient.instance.baseOrganizationId,
              clientId: ApiClient.instance.clientId,
              catalogId: ApiClient.instance.baseCatalogId,
              osVersion: Platform.isIOS
                  ? iosInfo?.systemVersion ?? ""
                  : _deviceData['version.codename'] ?? "");

          List<OpenAppAnalytic> analyticPayloads = [];
          analyticPayloads.add(data);
          try {
            OpenAppAnalyticModel(data: analyticPayloads);
          } catch (e, s) {
            await FirebaseCrashlytics.instance
                .recordError(e, s, reason: e.toString())
                .whenComplete(
                  () => {
                    if (e.toString() == "Token invalidation")
                      {
                        if (Platform.isAndroid)
                          {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialogNative(
                                  title: const Text("Token Invalid"),
                                  content: const Text("Please sign out"),
                                  action: [
                                    Button(
                                        title: "Token invalid",
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        radius: 12,
                                        style: h6Title,
                                        color: Colors.red)
                                  ],
                                );
                              },
                            )
                          }
                        else
                          {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialogNative(
                                  title: const Text("Token Invalid"),
                                  content: const Text("Please sign out"),
                                  action: [
                                    CupertinoDialogAction(
                                      child: Text("Logout"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              },
                            )
                          }
                      }
                  },
                );
          }
          await getWatermarkData(state.user.email!).whenComplete(
            () => Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.routeName,
              (route) => false,
            ),
          );
        } else if (state is UserProgressDeauthorized) {
          Platform.isAndroid
              ? showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogNative(
                      title: Text(
                        AppLocalizations.of(context)!.userDeauthorize,
                        style: h4Title,
                      ),
                      content: Text(
                        AppLocalizations.of(context)!.informationDeauthorize,
                        style: paragraph4,
                      ),
                      action: [
                        Button(
                            title: AppLocalizations.of(context)!.close,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            radius: 8,
                            style: h6Title,
                            color: Colors.grey),
                        buttonDeAuthorize(localization)
                      ],
                    );
                  },
                )
              : showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(
                        AppLocalizations.of(context)!.userDeauthorize,
                        style: h4Title,
                      ),
                      content: Text(
                        AppLocalizations.of(context)!.informationDeauthorize,
                        style: paragraph4,
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(AppLocalizations.of(context)!.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        buttonDeAuthorize(localization)
                      ],
                    );
                  },
                );
        } else if (state is UserCantAccess) {
          if (Platform.isIOS) {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return AlertDialogNative(
                  title: Text(AppLocalizations.of(context)!.userCantAccess),
                  content:
                      Text(AppLocalizations.of(context)!.userMessageCantAccess),
                  action: [
                    CupertinoDialogAction(
                      child: Text(AppLocalizations.of(context)!.close),
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
                  title: Text(AppLocalizations.of(context)!.userCantAccess),
                  content:
                      Text(AppLocalizations.of(context)!.userMessageCantAccess),
                  action: [
                    Button(
                      title: AppLocalizations.of(context)!.close,
                      onTap: () {
                        Navigator.pop(context);
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
        } else if (state is UserFailed) {
          print("UserProgressDeauthorized");
          final String titleText = state.error.contains("host")
              ? localization.offlineLogin
              : "Failed Login";
          final String infoText = state.error.contains("host")
              ? localization.offlineLoginInfo
              : state.error;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialogNative(
                title: Text(
                  titleText,
                  style: h4Title,
                ),
                content: Text(
                  infoText,
                  style: subhead2,
                ),
                action: state.errorCode != null
                    ? [
                        Button(
                          title: localization.resendVerify,
                          onTap: () async {
                            Navigator.pop(context);

                            await context.read<UserCubit>().resendVerification(
                                  context: context,
                                  username: emailController.text.trim(),
                                );
                          },
                          radius: 12,
                          style: h6Title.copyWith(color: primaryColor),
                          color: Colors.transparent,
                        ),
                        Button(
                          title: localization.close,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          radius: 12,
                          style: h6Title.copyWith(color: Colors.red),
                          color: Colors.transparent,
                        ),
                      ]
                    : [
                        Button(
                          title: localization.close,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          radius: 12,
                          style: h6Title.copyWith(color: Colors.red),
                          color: Colors.transparent,
                        ),
                      ],
              );
            },
          );
        } else if (state is UserResendVerificationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message == "204"
                    ? AppLocalizations.of(context)!.resendVerifySuccess
                    : state.message,
              ),
            ),
          );
        } else if (state is UserResendVerificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(state.message),
            ),
          );
        }
      },
    );
  }

  bool isRememberMe = false;
  Widget signInForm(AppLocalizations localization) {
    final bool isShowEmail = FlavorConfig.instance.values.isShowLoginEmail!;
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
                  controller: emailController,
                  labelText: isShowEmail
                      ? AppLocalizations.of(context)!.email
                      : AppLocalizations.of(context)!.username,
                  hintText: isShowEmail
                      ? AppLocalizations.of(context)!.enterEmail
                      : AppLocalizations.of(context)!.enterUsername,
                  prefixImage: isShowEmail
                      ? 'assets/icon_assets/ic_mail.png'
                      : 'assets/icon_assets/ic_user.png',
                  onChanged: (String text) {
                    setState(() {
                      isButtonSignInEnabled = emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          passwordController.text.length >= 6;
                    });
                  },
                ),
                const SizedBox(height: 32),
                textFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  labelText: localization.signUpPasswordLabel,
                  hintText: AppLocalizations.of(context)!.enterPassword,
                  prefixImage: 'assets/icon_assets/ic_lock.png',
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
                  onChanged: (String text) {
                    setState(() {
                      isButtonSignInEnabled = emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          passwordController.text.length >= 6;
                    });
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: true,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.bottomRight,
              color: Colors.transparent,
              child: TextButton(
                onPressed: () => onForgotPasswordButtonClicked(),
                child: const Text('Forgot Password'),
              ),
            ),
          ),
          // ANCHOR - Sign In Button
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: isOpenRegis! ? 0 : 24,
            ),
            child: buttonSignIn(localization),
          ),
        ],
      ),
    );
  }
}
