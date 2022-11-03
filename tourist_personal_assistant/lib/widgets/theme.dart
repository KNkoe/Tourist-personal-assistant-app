import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffF5F5F5),
    primaryColor: const Color(0xff0089EF),
    snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: Color(0xff0089EF),
            fontWeight: FontWeight.bold,
            fontSize: 18)));
