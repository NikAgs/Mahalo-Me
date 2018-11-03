import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(
    color: const Color(0XFFFFFFFF),
    fontSize: 16.0,
    fontWeight: FontWeight.normal);

ThemeData appTheme = new ThemeData(
  hintColor: Colors.white,
);

Color textFieldColor = const Color.fromRGBO(255, 255, 255, 0.1);

Color primaryColor = const Color(0xFFf63ca8);

TextStyle buttonTextStyle = const TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 0.8),
    fontSize: 14.0,
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);



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