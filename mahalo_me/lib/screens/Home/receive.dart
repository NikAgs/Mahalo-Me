import 'package:flutter/material.dart';

class ReceiveMoney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image(image: new ExactAssetImage("assets/qrcode.png"), width: 175.0),
        new SizedBox(height: 75.0),
        Text("MahaloMe ID",
            style: new TextStyle(fontSize: 18.0, color: Colors.grey)),
        new SizedBox(height: 5.0),
        Text("142A34", style: new TextStyle(fontSize: 18.0))
      ],
    ));
  }
}
