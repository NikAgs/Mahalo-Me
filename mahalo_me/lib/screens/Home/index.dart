import 'dart:async';

import "package:flutter/material.dart";
import "../../theme/style.dart" as Theme;

import "send.dart";
import "receive.dart";
import "reload.dart";

import "../../global.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _balance = "";
  StreamSubscription<DocumentSnapshot> _listener;

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('sources')
        .getDocuments()
        .then((sources) {
      if (sources.documents.length == 0) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    content: Text(
                        "We noticed you haven't added a payment source yet. Let's get you started!"),
                    actions: <Widget>[
                      FlatButton(
                          textColor: Theme.ThemeColors.cyan,
                          child: const Text("NO THANKS"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      FlatButton(
                          textColor: Theme.ThemeColors.cyan,
                          child: const Text("OK"),
                          onPressed: () async {
                            Navigator.pushReplacementNamed(context, "/AddCard");
                          })
                    ]));
      }
    });

    // Listener for updating the balance displayed
    _listener = Firestore.instance
        .collection('balances')
        .document(firebaseUser.displayName)
        .snapshots()
        .listen((snap) {
      if (this.mounted) {
        setState(() {
          _balance = '\$' + snap.data["balance"].toString() + '.00';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Inside theme",
        theme: Theme.homeTheme,
        home: new DefaultTabController(
          length: 3,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.ThemeColors.cyan,
              bottom: TabBar(
                tabs: [
                  Tab(text: "Send"),
                  Tab(text: "Receive"),
                  Tab(text: "Reload"),
                ],
              ),
              title: Text('MahaloMe'),
              centerTitle: true,
            ),
            body: TabBarView(
              children: [
                new SendMoney(),
                new ReceiveMoney(),
                new ReloadMoney("\$25"),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  new Container(
                    height: 132.0,
                    child: DrawerHeader(
                      padding: EdgeInsets.all(18.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('MahaloMe User',
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)),
                          Text(email, style: new TextStyle(color: Colors.white))
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Theme.ThemeColors.cyan,
                      ),
                    ),
                  ),
                  new Container(
                      height: 50.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            _balance,
                            style: new TextStyle(
                                fontSize: 15.0, color: new Color(0xFF4d4d4d)),
                          ),
                          new SizedBox(width: 15.0, height: 0.0),
                          new Text("Balance",
                              style: new TextStyle(
                                  fontSize: 15.0,
                                  color: new Color(0xFF4d4d4d))),
                        ],
                      )),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, "/PaymentMethods");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.equalizer),
                    title: Text('Reports'),
                    onTap: () {
                      Navigator.pushNamed(context, "/Reports");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance),
                    title: Text('Bank Info'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/Express');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Withdraw Funds'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/Withdraw');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/Login", (route) => false);
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
