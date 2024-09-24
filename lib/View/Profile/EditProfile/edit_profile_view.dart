import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Cubit/user_cubit.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Profile/ChangePassword/ChangePasswordView.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/model/User/user_model.dart';

class EditProfileView extends StatefulWidget {
  static const routeName = '/editProfile';
  EditProfileView({Key? key, this.userProfile, this.isDark}) : super(key: key);
  GetDataUserResponse? userProfile;
  int? isDark;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final birthdateController = TextEditingController();
  final emailController = TextEditingController();
  int selectedGender = 0;
  bool isDeleteButtonShown = false;

  @override
  void initState() {
    setShowDeleteButton();
    context.read<UserCubit>().initEditProfile(widget.userProfile!);
    fullNameController.text = widget.userProfile!.firstName.isNotEmpty ||
            widget.userProfile!.lastName.isNotEmpty
        ? "${widget.userProfile!.firstName} ${widget.userProfile!.lastName}"
        : widget.userProfile!.username;
    super.initState();
  }

  Future<void> setShowDeleteButton() async {
    final value = await getIsOpenRegis();
    setState(() {
      isDeleteButtonShown = value;
    });
  }

  Map<String, dynamic> getUnlinkBody() {
    List<Map<String, dynamic>> _organizations = [];
    widget.userProfile!.organizations!.forEach((element) {
      _organizations.add({"id": element.id, "name": element.name});
    });
    return {
      "email": widget.userProfile!.email,
      "first_name": widget.userProfile!.firstName,
      "id": widget.userProfile!.id,
      "is_active": true,
      "last_active": "-",
      "last_name": widget.userProfile!.lastName,
      "level": widget.userProfile!.level,
      "note": null,
      "organizations": _organizations,
      "organizations_name": widget.userProfile!.organizations!.first.name,
      "signup_date": DateTime.now().toString(),
      "username": widget.userProfile!.username
    };
  }

  void showDeleteAccountAlert(AppLocalizations localization) {
    int? organizationId;
    widget.userProfile!.organizations!.forEach((element) {
      if(element.appname == ApiClient.instance.appname){
        organizationId = element.id;
      }
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogNative(
          title: Text(
            localization.deleteAccountTitle,
            style: h4Title,
          ),
          content: Text(
            localization.deleteAccountSubTitle,
            style: subhead2,
          ),
          action: [
            Button(
              title: localization.deleteAccount,
              onTap: () async {
                Navigator.pop(context);
                context.read<UserCubit>().deleteAccountCubit(
                      userId: widget.userProfile!.id,
                      payload: getUnlinkBody(),
                      organizationId: organizationId!,
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
          ],
        );
      },
    );
  }

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
        child: TextFormField(
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        ));
  }

  Widget buildEditActionButton(
    Size size,
    VoidCallback onTap,
    Icon icon,
    String title,
    TextStyle titleStyle, {
    Color? color,
  }) {
    color = color ?? Theme.of(context).canvasColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  title,
                  style: titleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isButtonSignInEnabled = false;
  Widget selfInformation(Size size, AppLocalizations localization) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          );
        }
        if (state is DeleteUserSuccess) {
          return const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetDataUserSuccess) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: size.width,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.personalInfo,
                    style: h6Title.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 12),
                  textFormField(
                    validatorText: "Your name is not valid",
                    controller: fullNameController,
                    labelText: 'Fullname',
                    hintText: 'Enter your fullname',
                    prefixImage: 'assets/icon_assets/ic_user.png',
                    onChanged: (String text) {},
                  ),
                  const SizedBox(height: 20),
                  buildEditActionButton(
                    size,
                    () {},
                    const Icon(Icons.email),
                    state.user.email,
                    Theme.of(context).textTheme.bodyLarge!,
                  ),
                  const SizedBox(height: 20),
                  buildEditActionButton(
                    size,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordView(
                            isDark: widget.isDark,
                          ),
                        ),
                      );
                    },
                    const Icon(
                      Icons.lock,
                      color: Colors.deepOrange,
                    ),
                    AppLocalizations.of(context)!.changePassword,
                    h5Title.copyWith(color: Colors.deepOrange),
                  ),
                  Visibility(
                    visible: isDeleteButtonShown!,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: buildEditActionButton(
                        size,
                        () {
                          showDeleteAccountAlert(localization);
                        },
                        const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                        AppLocalizations.of(context)!.deleteAccount,
                        h5Title.copyWith(color: Colors.white),
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
        return const Text("Error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final bool isDark = widget.isDark == 1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        foregroundColor: Platform.isIOS
            ? Theme.of(context).cardColor
            : const Color(0xFF091A33),
        backgroundColor: Platform.isIOS
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.editProfile,
          style: h3Title.apply(color: isDark ? Colors.white : Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: SizedBox(
              width: size.width,
              child: Column(
                children: [
                  // const SizedBox(height: 24),
                  // addPictureImage(size),
                  const SizedBox(height: 24),
                  selfInformation(size, localization),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is DeleteUserError) {
            context.read<UserCubit>().initEditProfile(widget.userProfile!);
          }
          if (state is DeleteUserSuccess) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return AlertDialogNative(
                    title: const Text("Force Logout"),
                    content: Text(localization.loginSessionOver),
                    action: [
                      CupertinoDialogAction(
                        child: Text(AppLocalizations.of(context)!.close),
                        onPressed: () {
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
                    title: Text(localization.accountDeleted),
                    content: Text(localization.accountDeletedConfirmation),
                    action: [
                      Button(
                        title: AppLocalizations.of(context)!.close,
                        onTap: () {
                          context.read<UserCubit>().logout();
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
        },
      ),
    );
  }
}
