import 'package:flutter/material.dart';
import "../../components/Buttons/roundedButton.dart";

import '../../services/payment.dart';

import "../../theme/style.dart";
import "../../global.dart";
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawScreen extends StatefulWidget {
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final myController = TextEditingController();
  StreamSubscription<QuerySnapshot> _listener;
  var _withdraws;

  void loadWheel() {
    if (this.mounted) {
      setState(() {
        withdrawingMoney = true;
      });
    }
  }

  void killWheel() {
    if (this.mounted) {
      setState(() {
        withdrawingMoney = false;
      });
    }
  }

  @override
  initState() {
    super.initState();

    // Listener for status of transfer
    _listener = Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('withdraws')
        .snapshots()
        .listen((snap) {
      if (_withdraws != null) {
        snap.documentChanges.forEach((doc) {
          var data = doc.document.data;
          if (data.length == 1)
            return; // this catches the withdraw initially created by the client
          killWheel();
          print(data);
          print("\n");
          if (data.containsKey("error")) {
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(data['error'])));
          } else {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text('Successfully withdrew ' +
                    '\$' +
                    data['amount'].toString() +
                    ' from MahaloMe account')));
          }
        });
      }
      _withdraws = snap.documents.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
    withdrawingMoney = false;
    _listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              title: new Text("Withdraw Funds"),
              backgroundColor: ThemeColors.cyan,
            ),
            body: withdrawingMoney
                ? loader
                : new Container(
                    width: screenSize.width,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new SizedBox(height: 50.0),
                        new Container(
                          width: screenSize.width - 50.0,
                          child: new Text(
                              "How much do you want to transfer to your bank account?",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: new Color(0xFF808080),
                                  fontSize: 18.0)),
                        ),
                        new SizedBox(height: 30.0),
                        new Theme(
                            data: homeTheme,
                            child: new Container(
                              width: 300.0,
                              child: new TextFormField(
                                  onFieldSubmitted: (id) {},
                                  decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      icon: Icon(Icons.attach_money),
                                      hintText: "0"),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  controller: myController),
                            )),
                        new SizedBox(
                          height: 50.0,
                        ),
                        new RoundedButton(
                          buttonName: "Withdraw",
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                        content: Text(
                                            "Do you want to withdraw " +
                                                '\$' +
                                                myController.text +
                                                " from your MahaloMe account?"),
                                        actions: <Widget>[
                                          FlatButton(
                                              textColor: ThemeColors.cyan,
                                              child: const Text("NO"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                          FlatButton(
                                              textColor: ThemeColors.cyan,
                                              child: const Text("YES"),
                                              onPressed: () async {
                                                if (int.tryParse(
                                                        myController.text) ==
                                                    null) {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(new SnackBar(
                                                          content: new Text(
                                                              "Please enter a valid amount")));
                                                  myController.clear();
                                                } else {
                                                  loadWheel();
                                                  withdrawMoney(int.tryParse(
                                                      myController.text));
                                                }
                                                Navigator.pop(context);
                                              })
                                        ]));
                          },
                          width: 150.0,
                          height: 45.0,
                          bottomMargin: 0.0,
                          borderWidth: 0.0,
                          buttonColor: ThemeColors.cyan,
                          borderRadius: 10.0,
                        )
                      ],
                    ),
                  )));
  }
}
