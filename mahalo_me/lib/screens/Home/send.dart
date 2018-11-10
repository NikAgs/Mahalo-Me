import 'package:flutter/material.dart';

class SendMoney extends StatefulWidget {
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Text("Scan a MahaloMe QR code",
              style: new TextStyle(color: Colors.black54, fontSize: 19.0)),
              new SizedBox(height: 50.0),
          new Container(
              width: 200.0,
              height: 200.0,
              child: new RaisedButton(
                  onPressed: () {
                    print("trynna take a pic?");
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
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
            ),
          )
        ]));
  }
}
