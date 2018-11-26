import 'package:flutter/material.dart';

import 'theme/style.dart';

import 'screens/Login/index.dart';
import 'screens/SignUp/index.dart';
import 'screens/Home/index.dart';
import 'screens/Payment/payments.dart';
import 'screens/Payment/card.dart';

void main() {
  var routes = <String, WidgetBuilder>{
    "/SignUp": (BuildContext context) => new SignUpScreen(),
    "/HomePage": (BuildContext context) => new HomeScreen(),
    "/Login": (BuildContext context) => new LoginScreen(),
    "/PaymentMethods": (BuildContext contect) => new PaymentMethodsScreen(),
    "/AddCard": (BuildContext context) => new AddCardScreen()
  };

  runApp(new MaterialApp(
    title: "Outside theme",
    home: new LoginScreen(),
    theme: loginTheme,
    routes: routes,
  ));
}
