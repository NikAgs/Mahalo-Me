import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../theme/style.dart' as Theme;
import '../../global.dart';
import '../../services/payment.dart';
import '../loading.dart';

class PaymentMethodsScreen extends StatefulWidget {
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var cards; // maintains the number of credit cards the user has
  var tokens; // maintains the number of tokens the user has

  void loadWheel() {
    if (this.mounted) {
      setState(() {
        paymentProcessing = true;
      });
    }
  }

  void killWheel() {
    if (this.mounted) {
      setState(() {
        paymentProcessing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Dialogue for adding card successfully
    Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('sources')
        .snapshots()
        .listen((snap) {
      if (cards != null) {
        if (snap.documents.length > cards) {
          killWheel();
        } else if (snap.documents.length < cards) {
          killWheel();
        }
      }
      cards = snap.documents.length;
    });

    // Dialogue for adding card unsuccessfully
    Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('tokens')
        .snapshots()
        .listen((snap) {
      if (tokens != null) {
        snap.documentChanges.forEach((doc) {
          if (doc.document.data.containsKey("error")) {
            setState(() {
              paymentProcessing = false;
            });
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("There was a problem with your card")));
          }
        });
      }
      tokens = snap.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: new Padding(
          padding: EdgeInsets.only(right: 30.0, bottom: 30.0),
          child: new FloatingActionButton(
            backgroundColor: Theme.ThemeColors.purple,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/AddCard');
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.ThemeColors.cyan,
          title: Text('Payment'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: paymentProcessing
            ? new ColorLoader(
                colors: [Theme.ThemeColors.cyan, Theme.ThemeColors.purple],
                duration: new Duration(milliseconds: 1200))
            : new StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(firebaseUser.displayName)
                    .collection('sources')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Text('');
                  }
                  return new ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return new CardListItem(
                            ds.data['last4'],
                            ds.data["customer"],
                            ds.data["id"],
                            _scaffoldKey,
                            loadWheel);
                      });
                }));
  }
}

class CardListItem extends StatelessWidget {
  final String _last4;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final String _customer;
  final String _id;
  final VoidCallback _load;

  CardListItem(
      this._last4, this._customer, this._id, this._scaffoldKey, this._load);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Container(
            child: new ListTile(
                contentPadding: EdgeInsets.all(20.0),
                leading: new Icon(Icons.credit_card, size: 30.0),
                title: new Text(
                  '  ---' + _last4,
                  style: new TextStyle(color: Colors.black54, fontSize: 22.0),
                ),
                trailing: new IconButton(
                  icon: new Icon(Icons.close, size: 30.0),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                content: Text(
                                    'Are you sure you want to delete the card ending in ' +
                                        _last4 +
                                        '?'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  FlatButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        _load();
                                        Navigator.pop(context);
                                        deleteCreditCard(_customer, _id);
                                      })
                                ]));
                  },
                )),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(color: Colors.black12)))));
  }
}
