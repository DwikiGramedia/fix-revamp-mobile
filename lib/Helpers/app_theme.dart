import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
}



class AppThemes {
  static final appThemeData = {
    AppTheme.lightTheme: ThemeData(
      
      primaryColor: Colors.black,
      fontFamily: "Nunito",
      cardColor: Colors.white,
      canvasColor: Colors.white,
      shadowColor: Color.fromARGB(15, 0, 0, 0),
      splashColor: Color.fromARGB(15, 0, 0, 0),
      highlightColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      backgroundColor: const Color(0xFFFAFAFA),
      brightness: Brightness.light,
      textTheme: TextTheme(
        bodyText1: paragraph1.copyWith(color: Colors.black),
      ),
      textSelectionTheme:
          const TextSelectionThemeData(selectionColor: Colors.blue),
    ),
    AppTheme.darkTheme: ThemeData(
      primaryColor: Colors.white,
      
      fontFamily: "Nunito",
      cardColor: Colors.grey,
      canvasColor: Colors.grey,
      splashColor: Colors.grey,
      scaffoldBackgroundColor: const Color(0xFF121212),
      highlightColor: Colors.black,
      backgroundColor: const Color(0xFF121212),
      brightness: Brightness.dark,
      textTheme: TextTheme(
        bodyText1: paragraph1.copyWith(color: Colors.white),
      ),
      textSelectionTheme:
          const TextSelectionThemeData(selectionColor: Colors.blue),
    ),
  };
}
