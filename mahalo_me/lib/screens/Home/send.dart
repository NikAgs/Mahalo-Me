import 'package:flutter/material.dart';

class SendMoney extends StatefulWidget {
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          new GestureDetector(
            onTap: () {
              print("trynna take a pic?");
            },
            child: new Container(
                width: 250.0,
                height: 250.0,
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(20.0),
                    border: new Border.all(color: Colors.grey)),
                child: new Center(
                  child: new Icon(
                    Icons.camera_alt,
                    size: 100.0,
                    color: Colors.grey,
                  ),
                )),
          ),
          new Container(
              width: 300.0,
              child: new Theme(
                data: new ThemeData(
                    inputDecorationTheme: new InputDecorationTheme()),
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.input),
                    labelText: 'MahaloMe Code',
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (String value) {},
                  validator: (input) {
                    return input;
                  },
                  // TextInputFormatters are applied in sequence.
                ),
              ))
        ]));
  }
}
