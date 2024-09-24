import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Cubit/Theme/theme_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/user_cubit.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Card/level_card.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Profile/AboutUs/about_us_view.dart';
import 'package:revamp_eperpus_mobile/View/Profile/BorrowingHistory/borrowing_history_view.dart';
import 'package:revamp_eperpus_mobile/View/Profile/EditProfile/edit_profile_view.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/app_theme_pref.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/util_constant.dart';
import 'package:revamp_eperpus_mobile/model/User/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../Cubit/Product/Library/product_cubit.dart';
import '../CustomWidget/Dialog/change_language_dialog.dart';
import 'WatchList/watch_list_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, this.onForceLogout}) : super(key: key);
  final VoidCallback? onForceLogout;

  @override
  State<StatefulWidget> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  int isDark = lightAppTheme;
  String codeLocal = "id";
  SharedPreferences? sharedPreferences;

  final GlobalKey _cardNameKey = GlobalKey();
  final GlobalKey _editProfileKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _waitingKey = GlobalKey();
  final GlobalKey _languageKey = GlobalKey();
  final GlobalKey _darkModeKey = GlobalKey();
  final GlobalKey _aboutUsKey = GlobalKey();

  @override
  void initState() {
    initStateData();
    context.read<UserCubit>().getDataUser(context);
    initShowCase();
    super.initState();
  }

  Future<void> initStateData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final int themeValue =
        await getAppTheme() == lightAppTheme ? darkAppTheme : lightAppTheme;
    setState(() {
      isDark = themeValue;
    });
  }

  bool? isFirstTime = true;
  Future<void> initShowCase() async {
    isFirstTime = await getShowCaseProfile();
    if (isFirstTime!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _cardNameKey,
          _editProfileKey,
          // _achievementKey,
          _historyKey,
          _waitingKey,
          // _digitalCardKey,
          _languageKey,
          _darkModeKey,
          _aboutUsKey,
          // _logoutKey,
        ]);

        // super.initState();
      });
      await setShowCaseProfile(false);
    }
  }

  Widget cardName(Size size, AppLocalizations localizations) {
    return BlocConsumer<UserCubit, UserState>(
      builder: (context, state) {
        if (state is GetDataUserSuccess) {
          userProfile = state.user;
          return Showcase(
            targetPadding: const EdgeInsets.all(5),
            key: _cardNameKey,
            title: localizations.profile,
            description: localizations.profileInformation,
            tooltipBackgroundColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).highlightColor,
            targetShapeBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              width: size.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   child: Text(
                  //     "C",
                  //     style: h2Title.copyWith(color: Colors.white),
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.user.firstName.isNotEmpty ||
                                state.user.lastName.isNotEmpty
                            ? "${state.user.firstName} ${state.user.lastName}"
                            : state.user.username,
                        style: h3Title,
                      ),
                      Visibility(
                        visible: false,
                        // visible: state.user.level != null,
                        child: CardLevelWidget(
                          isLittle: false,
                          level: Level.bookworm,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return Container(height: 80);
      },
      listener: (context, state) {
        if (state is GetUserForceLogout) {
          if (Platform.isIOS) {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return AlertDialogNative(
                      title: Text(AppLocalizations.of(context)!.unauthorized),
                      content:
                          Text(AppLocalizations.of(context)!.unauthorizedText),
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
                      ]);
                });
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialogNative(
                      title: Text(AppLocalizations.of(context)!.unauthorized),
                      content:
                          Text(AppLocalizations.of(context)!.unauthorizedText),
                      action: [
                        Button(
                          title: AppLocalizations.of(context)!.close,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignInUIForm.routeName,
                            );
                          },
                          radius: 12,
                          color: Colors.green,
                          style: h6Title,
                        )
                      ]);
                });
          }
        }
      },
    );
  }

  GetDataUserResponse? userProfile;
  Widget accountMenu(Size size, AppLocalizations localization) {
    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              localization.account,
              style: h6Title.copyWith(fontSize: 10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Showcase(
                  targetBorderRadius: BorderRadius.circular(10),
                  targetPadding: const EdgeInsets.all(12),
                  key: _editProfileKey,
                  title: localization.editProfile,
                  description: localization.editProfileConfirmation,
                  tooltipBackgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).highlightColor,
                  targetShapeBorder: const CircleBorder(),
                  child: SizedBox(
                    height: 48,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileView(
                              userProfile: userProfile,
                              isDark: isDark,
                            ),
                          ),
                        );
                      },
                      leading: const Icon(Icons.person_pin),
                      title: Text(
                        AppLocalizations.of(context)!.editProfile,
                        style: subhead3,
                      ),
                      subtitle: const Divider(),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
                // AccountMenuListTile(
                //   showCaseKey: _achievementKey,
                //   showCaseTitle: "Edit Profil",
                //   showCaseDescription: "Tekan untuk mengubah pengaturan profile",
                //   leading: Icons.check_circle_outline_rounded,
                //   title: AppLocalizations.of(context)!.milestones,
                //   onTap: () {},
                //   trailing: const Icon(Icons.chevron_right),
                // ),
                Showcase(
                  targetBorderRadius: BorderRadius.circular(10),
                  targetPadding: const EdgeInsets.all(12),
                  key: _historyKey,
                  title: localization.borrowedHistory,
                  description: localization.borrowedHistoryConfirmation,
                  tooltipBackgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).highlightColor,
                  targetShapeBorder: const CircleBorder(),
                  child: SizedBox(
                    height: 48,
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          BorrowingHistoryView.routeName,
                        );
                      },
                      leading: const Icon(Icons.menu_book_sharp),
                      title: Text(
                        AppLocalizations.of(context)!.borrowingHistory,
                        style: subhead3,
                      ),
                      subtitle: const Divider(),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
                Showcase(
                  targetBorderRadius: BorderRadius.circular(10),
                  targetPadding: const EdgeInsets.all(12),
                  key: _waitingKey,
                  title: localization.waitList,
                  description: localization.waitListConfirmation,
                  tooltipBackgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).highlightColor,
                  targetShapeBorder: const CircleBorder(),
                  child: SizedBox(
                    height: 48,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatchListView(
                              isDark: isDark,
                            ),
                          ),
                        );
                      },
                      leading: Icon(Icons.access_time),
                      title: Text(
                        AppLocalizations.of(context)!.waitingList,
                        style: subhead3,
                      ),
                      subtitle: const Divider(),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
                // BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                //   if (state is GetDataUserSuccess) {
                //     return AccountMenuListTile(
                //       showCaseKey: _digitalCardKey,
                //       showCaseTitle: localization.digitalCard,
                //       showCaseDescription: localization.digitalCardConfirmation,
                //       leading: Icons.badge,
                //       title: AppLocalizations.of(context)!.digitalCard,
                //       onTap: () => Navigator.pushNamed(
                //         context,
                //         DigitalCardView.routeName,
                //         arguments: DigitalCardArgs(
                //           userId: state.user.id,
                //           organizationId: ApiClient.instance.baseOrganizationId,
                //         ),
                //       ),
                //       trailing: const Icon(Icons.chevron_right),
                //     );
                //   }
                //   return Container();
                // }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget othersMenu(Size size, AppLocalizations localization) {
    return BlocConsumer<ThemeCubit, ThemeState>(
      builder: (context, state) {
        context.read<ThemeCubit>().getDarkMode();
        return SizedBox(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  localization.miscellaneous,
                  style: h6Title.copyWith(fontSize: 10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Showcase(
                      targetBorderRadius: BorderRadius.circular(10),
                      targetPadding: const EdgeInsets.all(12),
                      key: _languageKey,
                      title: localization.language,
                      description: localization.languageConfirmation,
                      tooltipBackgroundColor: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).highlightColor,
                      targetShapeBorder: const CircleBorder(),
                      child: SizedBox(
                        height: 48,
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ChangeLanguageDialog();
                              },
                            );
                          },
                          leading: Icon(Icons.language),
                          title: Text(
                            AppLocalizations.of(context)!.language,
                            style: subhead3,
                          ),
                          subtitle: const Divider(),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                    Showcase(
                      targetBorderRadius: BorderRadius.circular(10),
                      targetPadding: const EdgeInsets.all(12),
                      key: _darkModeKey,
                      title: 'Dark Mode',
                      description: localization.darkModeConfirmation,
                      tooltipBackgroundColor: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).highlightColor,
                      targetShapeBorder: const CircleBorder(),
                      child: SizedBox(
                        height: 48,
                        child: ListTile(
                          onTap: () {},
                          leading: Icon(Icons.dark_mode),
                          title: Text(
                            "Dark Mode",
                            style: subhead3,
                          ),
                          subtitle: const Divider(),
                          trailing: Switch(
                            value: state is ChangeThemeAppSuccess
                                ? state.darkAppTheme
                                : false,
                            onChanged: (bool value) {
                              context.read<ThemeCubit>().setDarkMode();
                              initStateData();
                            },
                          ),
                        ),
                      ),
                    ),
                    Showcase(
                      targetBorderRadius: BorderRadius.circular(10),
                      targetPadding: const EdgeInsets.all(12),
                      key: _aboutUsKey,
                      title: localization.aboutUs,
                      description: localization.aboutUsConfirmation,
                      tooltipBackgroundColor: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).highlightColor,
                      targetShapeBorder: const CircleBorder(),
                      child: SizedBox(
                        height: 48,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutUsView(
                                  isDark: isDark,
                                ),
                              ),
                            );
                          },
                          leading: Icon(Icons.info_outline),
                          title: Text(
                            AppLocalizations.of(context)!.aboutUs,
                            style: subhead3,
                          ),
                          subtitle: const Divider(),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      listener: (context, state) async {},
    );
  }

  Widget buttonLogout(Size size, AppLocalizations localization) {
    return BlocConsumer<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        int _isDark = lightAppTheme;
        _isDark = sharedPreferences!.getInt('themeStatus')!;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: _isDark == lightAppTheme ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.red, width: 1.2),
            ),
          ),
          onPressed: () async {
            Platform.isAndroid
                ? showGeneralDialog(
                    context: context,
                    pageBuilder: (context, animation, animation2) {
                      return AlertDialogNative(
                        title: Text(localization.logout),
                        content: Text(localization.logoutConfirmation),
                        action: [
                          Button(
                            title: localization.logoutYes,
                            style: h4Title,
                            onTap: () {
                              context.read<UserCubit>().logout();
                            },
                            color: Colors.red,
                            radius: 10,
                          ),
                          Button(
                            title: localization.logoutNo,
                            style: h4Title,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            color: Colors.grey,
                            radius: 10,
                          )
                        ],
                      );
                    },
                  )
                : showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(localization.logout),
                        content: Text(localization.logoutConfirmation),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(
                              AppLocalizations.of(context)!.close,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text(localization.logout),
                            onPressed: () {
                              context.read<UserCubit>().logout();
                            },
                          ),
                        ],
                      );
                    });
          },
          child: Text(
            AppLocalizations.of(context)!.logout,
            style: h3Title.copyWith(color: Colors.red),
          ),
        );
      },
      listener: (context, state) {
        if (state is UserLogoutSuccess) {
          //context.read<ProductCubit>().resetProductList(context, "", "", "");
          context.read<ProductCubit>().urlProduct = "";
          context.read<ProductCubit>().catalogTitle = "";
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInUIForm()),
            (Route<dynamic> route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      profilePage(
                        organization: ApiClient.instance.baseOrganizationId,
                      ),
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              cardName(size, localization),
              accountMenu(size, localization),
              const SizedBox(height: 8),
              othersMenu(size, localization),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width - 48,
                height: 48,
                child: buttonLogout(size, localization),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
