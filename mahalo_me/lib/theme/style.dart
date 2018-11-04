import 'package:flutter/material.dart';

ThemeData loginTheme =
    new ThemeData(hintColor: Colors.white, cursorColor: Colors.white);

ThemeData homeTheme = new ThemeData(
    primaryIconTheme: new IconThemeData(color: Colors.white),
    primaryTextTheme: new TextTheme(
        title: new TextStyle(color: Colors.white),
        subhead: new TextStyle(color: Colors.white),
        headline: new TextStyle(color: Colors.white),
        body1: new TextStyle(color: Colors.white),
        body2: new TextStyle(color: Colors.white),
        button: new TextStyle(color: Colors.white),
        caption: new TextStyle(color: Colors.white),
        display1: new TextStyle(color: Colors.white),
        display2: new TextStyle(color: Colors.white),
        display3: new TextStyle(color: Colors.white),
        display4: new TextStyle(color: Colors.white)),
    primaryColor: ThemeColors.cyan,
    accentColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme());

TextStyle buttonTextStyle = const TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 0.8),
    fontSize: 14.0,
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle textStyle = const TextStyle(
    color: const Color(0XFFFFFFFF),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

class ThemeColors {
  const ThemeColors();

  static const Color lightPurple = const Color(0xFFfee7f4);
  static const Color cyan = const Color(0xFF1CD9F9);
  static const Color purple = const Color(0xFFF638A8);
  static const Color lighterPurple = const Color(0xFFf86dbe);

  static const primaryGradient = const LinearGradient(
    colors: const [lightPurple, cyan],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
