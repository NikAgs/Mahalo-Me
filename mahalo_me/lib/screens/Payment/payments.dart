import 'package:flutter/material.dart';

import '../../theme/style.dart' as Theme;

class PaymentMethodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: new Padding(
          padding: EdgeInsets.only(right: 30.0, bottom: 30.0),
          child: new FloatingActionButton(
            backgroundColor: Theme.ThemeColors.purple,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed("/AddCard");
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.ThemeColors.cyan,
          title: Text("Payment"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView());
  }
}
