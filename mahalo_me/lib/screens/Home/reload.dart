import "package:flutter/material.dart";

import "../../global.dart";
import "../../services/payment.dart";

import "../../theme/style.dart" as Theme;

import "../../components/Buttons/formSelection.dart";
import "../../components/Buttons/roundedButton.dart";

import 'package:cloud_firestore/cloud_firestore.dart';

class ReloadMoney extends StatefulWidget {
  final String _value;

  ReloadMoney(this._value);

  _ReloadMoneyState createState() => _ReloadMoneyState(_value);
}

class _ReloadMoneyState extends State<ReloadMoney> {
  String _value;
  var _charges;

  _ReloadMoneyState(this._value);

  void loadWheel() {
    if (this.mounted) {
      setState(() {
        chargeProcessing = true;
      });
    }
  }

  void killWheel() {
    if (this.mounted) {
      setState(() {
        chargeProcessing = false;
      });
    }
  }

  String translateAmount(int amount) {
    return '\$' + (amount / 100).round().toString();
  }

  @override
  void initState() {
    super.initState();

    // Listener for status of charging card
    Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('charges')
        .snapshots()
        .listen((snap) {
      if (_charges != null) {
        snap.documentChanges.forEach((doc) {
          var data = doc.document.data;
          if (data.length == 2)
            return; // this catches the charge initially created by the client
          killWheel();
          if (data.containsKey("error")) {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("There was a problem charging your card")));
          } else {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text('Successfully added ' +
                    translateAmount(data['amount']) +
                    ' to your account')));
          }
        });
      }
      _charges = snap.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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

    return chargeProcessing
        ? Theme.loader
        : new SingleChildScrollView(
            child: new Container(
                height:
                    screenSize.height < 500 ? 500.0 : screenSize.height - 140.0,
                child: new Container(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text("How much do you want to add?",
                            style: new TextStyle(
                                color: new Color(0xFF808080), fontSize: 17.0)),
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
                            value: ["\$10", "\$25", "\$50"].contains(_value)
                                ? null
                                : _value,
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
                                        content: Text(
                                            "Do you want to deposit " +
                                                _value +
                                                " in your MahaloMe account?"),
                                        actions: <Widget>[
                                          FlatButton(
                                              textColor: Theme.ThemeColors.cyan,
                                              child: const Text("NO"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                          FlatButton(
                                              textColor: Theme.ThemeColors.cyan,
                                              child: const Text("YES"),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                // Charge the card here
                                                loadWheel();
                                                chargeCard(
                                                    _value.substring(1) + "00",
                                                    killWheel);
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
                )));
  }
}
