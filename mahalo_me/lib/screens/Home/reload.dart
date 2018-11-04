import "package:flutter/material.dart";

import "../../global.dart";

import "../../theme/style.dart" as Theme;

import "../../components/Buttons/formSelection.dart";
import "../../components/Buttons/roundedButton.dart";

class ReloadMoney extends StatefulWidget {
  final String _value;

  ReloadMoney(this._value);

  _ReloadMoneyState createState() => _ReloadMoneyState(_value);
}

class _ReloadMoneyState extends State<ReloadMoney> {
  String _value;

  _ReloadMoneyState(this._value);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> moneys = [];

    for (var i = 5; i <= 100; i += 5) {
      String text = "\$" + i.toString();
      moneys.add(new DropdownMenuItem(
          value: text,
          child: new Container(
            width: 150.0,
            child: new Text(
              text,
              textAlign: TextAlign.center,
            ),
          )));
    }

    return Container(
      child: new Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        new Text("How much do you want to add?",
            style: new TextStyle(color: new Color(0xFF808080), fontSize: 17.0)),
        new SizedBox(height: 50.0),
        new FormSelection("\$10", () {
          setState(() {
            _value = "\$10";
          });
        }, _value),
        new SizedBox(height: 13.0),
        new FormSelection("\$25", () {
          setState(() {
            _value = "\$25";
          });
        }, _value),
        new SizedBox(height: 13.0),
        new FormSelection("\$50", () {
          setState(() {
            _value = "\$50";
          });
        }, _value),
        new SizedBox(height: 13.0),
        new DropdownButton(
            onChanged: (selected) {
              setState(() {
                _value = selected;
              });
            },
            items: moneys,
            value: ["\$10", "\$25", "\$50"].contains(_value) ? null : _value,
            hint: new Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: new Text("Other amounts"))),
        new SizedBox(height: 50.0),
        new RoundedButton(
          buttonName: "Do it",
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        content: Text("Do you want to deposit " +
                            _value +
                            " in your MahaloMe account?"),
                        actions: <Widget>[
                          FlatButton(
                              child: const Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          FlatButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                Navigator.pop(context);
                                scaffoldKey.currentState
                                    .showSnackBar(new SnackBar(
                                        content: new Text(
                                  _value + " has been successfully added!",
                                  textAlign: TextAlign.center,
                                )));
                              })
                        ]));
          },
          width: 150.0,
          height: 45.0,
          bottomMargin: 10.0,
          borderWidth: 0.0,
          buttonColor: Theme.ThemeColors.cyan,
          borderRadius: 10.0,
        )
      ]),
    );
  }
}
