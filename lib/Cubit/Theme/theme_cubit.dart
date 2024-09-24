import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revamp_eperpus_mobile/Helpers/app_theme.dart';
import 'package:revamp_eperpus_mobile/Helpers/app_theme_pref.dart';
import 'package:revamp_eperpus_mobile/Helpers/util_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Service/user_service.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  Future<void> setDarkMode() async {
    final int appTheme =
        await getAppTheme() == lightAppTheme ? darkAppTheme : lightAppTheme;
    setAppTheme(appTheme);
    getDarkMode();
  }

  void setLocale(String codeLang) async {
    Locale dataLocale = Locale(codeLang);
    await UserService().setLocale(dataLocale);
  }

  void getLocale() async {
    final int appTheme =
        await getAppTheme() == lightAppTheme ? darkAppTheme : lightAppTheme;
    final bool isSwitchDarkMode = appTheme == lightAppTheme;
    final ThemeData? _appThemeData = isSwitchDarkMode
        ? AppThemes.appThemeData[AppTheme.darkTheme]
        : AppThemes.appThemeData[AppTheme.lightTheme];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString("codeLanguage") ?? "id";
    emit(
      ChangeThemeAppSuccess(
          darkAppTheme: isSwitchDarkMode,
          appThemeData: _appThemeData!,
          locale: Locale(data)),
    );
  }

  Future<void> getDarkMode() async {
    final int appTheme =
        await getAppTheme() == lightAppTheme ? darkAppTheme : lightAppTheme;
    final bool isSwitchDarkMode = appTheme == lightAppTheme;
    final ThemeData? appThemeData = isSwitchDarkMode
        ? AppThemes.appThemeData[AppTheme.darkTheme]
        : AppThemes.appThemeData[AppTheme.lightTheme];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString("codeLanguage") ?? "id";
    emit(
      ChangeThemeAppSuccess(
          darkAppTheme: isSwitchDarkMode,
          appThemeData: appThemeData!,
          locale: Locale(data)),
    );
  }
}
