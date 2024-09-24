// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-27 02:55:23
// @modify date 2022-03-27 10:01:53
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-27 02:55:23

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart' as cptn;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:revamp_eperpus_mobile/Cubit/Auth/register_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/user_cubit.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/Utils/flutter_webview.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/ui_helper.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final dateController = TextEditingController();
  final dateControllerCupertino = TextEditingController();
  final suffixController = TextEditingController();

  final emailFormFieldKey = GlobalKey<FormFieldState>();
  final usernameFormFieldKey = GlobalKey<FormFieldState>();
  final firstNameFormFieldKey = GlobalKey<FormFieldState>();
  final lastNameFormFieldKey = GlobalKey<FormFieldState>();
  final passwordFormFieldKey = GlobalKey<FormFieldState>();
  final passwordConfirmFormFieldKey = GlobalKey<FormFieldState>();
  final dateFormFieldKey = GlobalKey<FormFieldState>();
  final dateCupertinoFormFieldKey = GlobalKey<FormFieldState>();
  final suffixFormFieldKey = GlobalKey<FormFieldState>();

  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final passwordConfirmFocusNode = FocusNode();
  final dateFocusNode = FocusNode();
  final dateCupertinoFocusNode = FocusNode();
  final suffixFocusNode = FocusNode();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  int selectedGender = 1;

  bool isPasswordShowed = false;
  bool isUsernameValid = true;
  DateTime _chosenDateTime = DateTime.now();

  void onListen() => setState(() {});

  Future<void> initPlatformSite() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

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

  @override
  void initState() {
    super.initState();
    initPlatformSite();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    dateController.dispose();
    dateControllerCupertino.dispose();
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmFocusNode.dispose();
    dateFocusNode.dispose();
    dateCupertinoFocusNode.dispose();
    suffixFocusNode.dispose();
    super.dispose();
  }

  onSignUpButtonClicked(
      BuildContext context,
      AppLocalizations localization,
      ) async {
    try {
      emailFocusNode.unfocus();
      usernameFocusNode.unfocus();
      firstNameFocusNode.unfocus();
      lastNameFocusNode.unfocus();
      passwordFocusNode.unfocus();
      passwordConfirmFocusNode.unfocus();
      dateFocusNode.unfocus();
      dateCupertinoFocusNode.unfocus();
      suffixFocusNode.unfocus();
      UIHelper.showLoadingDialog(context, localization.uiHelperSignUp);
      await context.read<RegisterCubit>().registerAccount(
        context: context,
        username: usernameController.text,
        birthdate: datetime,
        gender: selectedGender,
        email: emailController.text,
        password: passwordController.text,
        deviceModel: _deviceData['model'],
        oSVersion: Platform.isIOS
            ? _deviceData['systemVersion'] ?? ""
            : _deviceData['version.codename'] ?? "",
        firstName: firstNameController.text,
        lastName: lastNameController.text,
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Widget buildTextField({
    required String labelText,
    String? Function(String?)? validator,
    required String hintText,
    required String prefixImage,
    required TextEditingController controller,
    required GlobalKey<FormFieldState> textFormFieldKey,
    required FocusNode focusNode,
    Widget? suffixWidget,
    bool? isObscuredText = false,
    bool? isEnable = true,
    bool? showPrefixIcon = true,
    String? prefixText = "",
    TextInputType? keyboardType = TextInputType.name,
  }) {
    return Material(
      elevation: 2,
      color: const Color(0xFFFAFAFA),
      borderRadius: BorderRadius.circular(8),
      child: TextFormField(
        key: textFormFieldKey,
        focusNode: focusNode,
        enabled: isEnable,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        obscureText: isObscuredText!,
        validator: validator,
        onEditingComplete: () {
          textFormFieldKey.currentState!.validate();
          focusNode.nextFocus();
        },
        onChanged: (value) {
          textFormFieldKey.currentState!.validate();
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          labelText: labelText,
          floatingLabelStyle: const TextStyle(color: Colors.transparent),
          // prefixText: prefixText,
          prefix: Text(prefixText!),
          prefixIcon: showPrefixIcon!
              ? Container(
            margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            height: 20,
            width: 20,
            child: Image.asset(
              prefixImage,
              fit: BoxFit.contain,
            ),
          )
              : null,
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
      ),
    );
  }

  Widget buildSignUpForm(AppLocalizations localization) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // ANCHOR - Register TextFormField
            buildTextField(
              textFormFieldKey: firstNameFormFieldKey,
              focusNode: firstNameFocusNode,
              controller: firstNameController,
              labelText: localization.signUpFirstNameLabel,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization.signUpFirstNameValidator;
                }
                return null;
              },
              hintText: localization.signUpFirstNameHint,
              prefixImage: 'assets/icon_assets/ic_user.png',
            ),
            const SizedBox(height: 32),
            buildTextField(
              textFormFieldKey: lastNameFormFieldKey,
              focusNode: lastNameFocusNode,
              controller: lastNameController,
              labelText: localization.signUpLastNameLabel,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization.signUpLastNameValidator;
                }
                return null;
              },
              hintText: localization.signUpLastNameHint,
              prefixImage: 'assets/icon_assets/ic_user.png',
            ),
            const SizedBox(height: 32),
            buildTextField(
              textFormFieldKey: emailFormFieldKey,
              focusNode: emailFocusNode,
              controller: emailController,
              labelText: localization.signUpEmailLabel,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !value.contains("@") ||
                    !value.contains(".")) {
                  return localization.signUpEmailValidator;
                }
                return null;
              },
              hintText: localization.signUpEmailHint,
              prefixImage: 'assets/icon_assets/ic_mail.png',
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  height: 62,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: !isUsernameValid
                      ? const EdgeInsets.only(bottom: 24)
                      : null,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    FlavorConfig.instance.values.openRegisPrefix,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: buildTextField(
                    textFormFieldKey: usernameFormFieldKey,
                    focusNode: usernameFocusNode,
                    controller: usernameController,
                    labelText: localization.signUpUsernameLabel,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          isUsernameValid = false;
                        });
                        return localization.signUpUsernameValidatorEmpty;
                      }
                      if (value.contains(" ")) {
                        setState(() {
                          isUsernameValid = false;
                        });
                        return localization.signUpUsernameValidatorContainSpace;
                      }
                      setState(() {
                        isUsernameValid = true;
                      });
                      return null;
                    },
                    hintText: localization.signUpUsernameHint,
                    prefixImage: 'assets/icon_assets/ic_user.png',
                    prefixText: "",
                    showPrefixIcon: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: Platform.isIOS
                  ? () => buildCupertinoDatePicker(context, localization)
                  : () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2050));
                onDatePickerChanged(pickedDate!);
              },
              // onTap: () => buildPickDateBottomSheet(context, localization),
              child: buildTextField(
                textFormFieldKey: dateFormFieldKey,
                focusNode: dateFocusNode,
                controller: dateController,
                labelText: localization.signUpBirthDateLabel,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.signUpBirthDateValidator;
                  }
                  return null;
                },
                hintText: localization.signUpBirthDateHint,
                prefixImage: 'assets/icon_assets/ic_calendar.png',
                isEnable: false,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 55,
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue: selectedGender,
                            onChanged: (value) => setState(
                                  () => selectedGender = value!,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              localization.male,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 55,
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 2,
                            groupValue: selectedGender,
                            onChanged: (value) => setState(
                                  () => selectedGender = value!,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              localization.female,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            buildTextField(
              textFormFieldKey: passwordFormFieldKey,
              focusNode: passwordFocusNode,
              controller: passwordController,
              labelText: localization.signUpPasswordLabel,
              hintText: localization.signUpPasswordHint,
              prefixImage: 'assets/icon_assets/ic_lock.png',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization.signUpPasswordValidatorEmpty;
                }
                if (value.length < 6) {
                  return localization.signUpPasswordValidator;
                }
                if (value.contains(" ")) {
                  return localization.signUpPasswordValidatorSpace;
                }
                return null;
              },
              suffixWidget: SizedBox(
                width: 10,
                height: 10,
                child: GestureDetector(
                  child: (isPasswordShowed)
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                  onTap: () => setState(() {
                    isPasswordShowed = !isPasswordShowed;
                  }),
                ),
              ),
              isObscuredText: !isPasswordShowed,
            ),
            const SizedBox(height: 32),
            buildTermAndCondition(localization),
            const SizedBox(height: 32),
            // ANCHOR - Sign In Button
            buildSignUpButton(localization),
          ],
        ),
      ),
    );
  }

  Widget buildSignUpButton(AppLocalizations localization) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return TextButton(
          onPressed: isButtonEnable()
              ? () {
            if (formKey.currentState!.validate()) {
              onSignUpButtonClicked(context, localization);
            }
          }
              : null,
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            backgroundColor: isButtonEnable() ? primaryColor : lightBlue,
            minimumSize: const Size(1000, 47),
          ),
          child: Text(
            localization.registerNow,
            style: h4Title.apply(color: Colors.white),
          ),
        );
      },
      listener: (context, state) async {
        if (state is RegisterSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInUIForm.routeName,
                  (Route<dynamic> route) => false,
            );
          });
        }
        if (state is RegisterError) {
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
        if (state is RegisterOutQuota) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialogNative(
                title: const Text("Error"),
                content: Text(state.message),
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
    );
  }

  bool isTermChecked = false;
  Widget buildTermAndCondition(AppLocalizations localizations) {
    TextStyle linkStyle = paragraph4.copyWith(
      fontWeight: FontWeight.w700,
      color: primaryColor,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isTermChecked = !isTermChecked;
            });
          },
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.black12),
                color: isTermChecked ? primaryColor : Colors.white,
              ),
              child: Visibility(
                visible: isTermChecked,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: RichText(
              text: TextSpan(
                style: paragraph4.apply(color: ashBlue),
                children: <TextSpan>[
                  TextSpan(text: localizations.signUpAgree + ' '),
                  TextSpan(
                    text: localizations.signUpTermAndCond,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlutterWebView(
                              title: localizations.signUpTermAndCond,
                              url: localizations.termOfServiceUrl,
                            ),
                          ),
                        );
                      },
                  ),
                  TextSpan(text: ' ${localizations.signUpAnd} '),
                  TextSpan(
                    text: localizations.signUpPrivacyPolicy,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlutterWebView(
                              title: localizations.signUpPrivacyPolicy,
                              url: localizations.privacyPolicyUrl,
                            ),
                          ),
                        );
                      },
                  ),
                  TextSpan(text: ' ${localizations.signUpFrom} ePerpus '),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isButtonEnable() {
    return isTermChecked;
  }

  String datetime = '';
  void onDatePickerChanged(DateTime birthDate) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final String date = dateFormat.format(birthDate);
    setState(() {
      datetime = birthDate.toString();
      dateController.text = date;
    });
    dateFormFieldKey.currentState!.validate();
  }

  Future<dynamic> buildCupertinoDatePicker(
      BuildContext context,
      AppLocalizations localization,
      ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (_context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 300,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 230,
                    child: cptn.CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      mode: cptn.CupertinoDatePickerMode.date,
                      onDateTimeChanged: (val) {
                        setState(() {
                          _chosenDateTime = val;
                        });
                      },
                    ),
                  ),

                  // Close the modal
                  cptn.CupertinoButton(
                      child: const Text('OK'),
                      onPressed: () {
                        onDatePickerChanged(_chosenDateTime);
                        Navigator.pop(context);
                      })
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async {
        context.read<UserCubit>().getOpenRegistration();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: BlocBuilder<RegisterCubit, RegisterState>(builder: (
            context,
            state,
            ) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 67,
                    width: 151,
                    child: Image.asset(
                      logoImage(
                        organization: ApiClient.instance.baseOrganizationId,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    localization.signUpLetsCreateAccount,
                    style: h4Title,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.signUpToExplore,
                    style: paragraph4.apply(color: lightBlue),
                  ),
                  const SizedBox(height: 32),
                  buildSignUpForm(localization),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: paragraph4.apply(color: ashBlue),
                      children: <TextSpan>[
                        TextSpan(text: localization.alreadyHaveAccount),
                        TextSpan(
                          text: localization.signIn,
                          style: paragraph4.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
