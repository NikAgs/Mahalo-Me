import 'package:flutter/material.dart';
import 'screens/Login/index.dart';
import 'screens/SignUp/index.dart';
import 'screens/Home/index.dart';
import 'theme/style.dart';

void main() {
  var routes = <String, WidgetBuilder>{
    "/SignUp": (BuildContext context) => new SignUpScreen(),
    "/HomePage": (BuildContext context) => new HomeScreen()
  };

  runApp(new MaterialApp(
    title: "Flutter Flat App",
    home: new LoginScreen(),
    theme: appTheme,
    routes: routes,
  ));
}
