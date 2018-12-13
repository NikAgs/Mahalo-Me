import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:barcode_scan/barcode_scan.dart';
import '../../services/validations.dart';
import '../../global.dart';
import '../../services/payment.dart';
import '../../theme/style.dart';

class SendMoney extends StatefulWidget {
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  String barcode = "";
  bool _autovalidate = false;
  final _formKey = GlobalKey<FormState>();
  Validations validations = new Validations();
  final myController = TextEditingController();
  var _transfers;

  void loadWheel() {
    if (this.mounted) {
      setState(() {
        sendingMoney = true;
      });
    }
  }

  void killWheel() {
    if (this.mounted) {
      setState(() {
        sendingMoney = false;
      });
    }
  }

  @override
  initState() {
    super.initState();

    // Listener for status of transfer
    Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('sent')
        .snapshots()
        .listen((snap) {
      if (_transfers != null) {
        snap.documentChanges.forEach((doc) {
          var data = doc.document.data;
          if (data.length == 2)
            return; // this catches the transfer initially created by the client
          killWheel();
          print(data);
          print("\n");
          if (data.containsKey("error")) {
            scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text(data['error'])));
          } else {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text('Successfully sent ' +
                    '\$' +
                    data['amount'].toString() +
                    ' to user: ' +
                    data['receiver'])));
          }
        });
      }
      _transfers = snap.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    void confirmSend(receiver) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  content: Text('\$' +
                      myController.text +
                      ' will be taken out of your MahaloMe balance'),
                  actions: <Widget>[
                    FlatButton(
                        textColor: ThemeColors.cyan,
                        child: const Text("CANCEL"),
                        onPressed: () {
                          myController.clear();
                          Navigator.pop(context);
                        }),
                    FlatButton(
                        textColor: ThemeColors.cyan,
                        child: const Text("SUBMIT"),
                        onPressed: () async {
                          Navigator.pop(context);
                          loadWheel();
                          sendMoney(int.tryParse(myController.text), receiver);
                          myController.clear();
                          _autovalidate = false;
                        })
                  ]));
    }

    _showDialog(receiver) async {
      await showDialog<String>(
          context: context,
          builder: (context) {
            return new AlertDialog(
                contentPadding: const EdgeInsets.all(25.0),
                title: new Text(
                  'Send money to MahaloMe user with ID: ' + receiver,
                  style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54),
                ),
                content: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: Theme(
                      data: homeTheme,
                      child: new TextField(
                        onSubmitted: (text) {
                          Navigator.pop(context);
                          confirmSend(receiver);
                        },
                        controller: myController,
                        textAlign: TextAlign.right,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.attach_money),
                        ),
                      ),
                    ))
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text(
                        'CANCEL',
                        style: new TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child: new Text(
                        'SEND',
                        style: new TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (int.tryParse(myController.text) == null) {
                          scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content:
                                  new Text("Please enter a valid amount")));
                          myController.clear();
                        } else {
                          confirmSend(receiver);
                        }
                      })
                ]);
          });
    }

    Future scan() async {
      try {
        String barcode = await BarcodeScanner.scan();

        String validate = validations.validateMahaloMeID(barcode);
        if (validate != null) {
          scaffoldKey.currentState
              .showSnackBar(new SnackBar(content: new Text(validate)));
        } else {
          // open up dialogue to get amount
          _showDialog(barcode.toUpperCase());
          print("UpperCased input: " + barcode.toUpperCase());
        }
        setState(() => this.barcode = barcode);
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
          setState(() {
            this.barcode = 'The user did not grant the camera permission!';
          });
        } else {
          setState(() => this.barcode = 'Unknown error: $e');
        }
      } on FormatException {
        setState(() => this.barcode =
            'null (User returned using the "back"-button before scanning anything. Result)');
      } catch (e) {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }

    return sendingMoney
        ? loader
        : new SingleChildScrollView(
            child: new Container(
                height:
                    screenSize.height < 500 ? 500.0 : screenSize.height - 140.0,
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Scan a MahaloMe QR code",
                          style: new TextStyle(
                              color: Colors.black54, fontSize: 19.0)),
                      new SizedBox(height: 50.0),
                      new Container(
                          width: 200.0,
                          height: 200.0,
                          child: new RaisedButton(
                              onPressed: scan,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0)),
                              color: Colors.white,
                              child: new Center(
                                child: new Icon(
                                  Icons.camera_alt,
                                  size: 100.0,
                                  color: Colors.grey,
                                ),
                              ))),
                      new SizedBox(height: 70.0),
                      new Container(
                          width: 300.0,
                          child: new Form(
                            key: _formKey,
                            child: new TextFormField(
                              onFieldSubmitted: (id) {
                                _autovalidate = true;
                                if (_formKey.currentState.validate()) {
                                  // open up dialogue to get amount
                                  _showDialog(id.toUpperCase());
                                  print("Attempting to send money to" +
                                      id.toUpperCase());
                                }
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.input),
                                labelText: 'MahaloMe ID',
                              ),
                              keyboardType: TextInputType.text,
                              autovalidate: _autovalidate,
                              validator: validations.validateMahaloMeID,
                            ),
                          ))
                    ])));
  }
}
