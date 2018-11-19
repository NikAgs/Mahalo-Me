import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';

import '../../global.dart';

class ReceiveMoney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new SingleChildScrollView(
        child: new Container(
            height: screenSize.height < 500 ? 400.0 : screenSize.height - 140.0,
            child: new Container(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: RepaintBoundary(
                    child: QrImage(
                      data: firebaseUser.email,
                      size: 200.0,
                      onError: (ex) {
                        print("[QR] ERROR - $ex");
                      },
                    ),
                  ),
                ),
                new SizedBox(height: 75.0),
                Text("MahaloMe ID",
                    style: new TextStyle(fontSize: 18.0, color: Colors.grey)),
                new SizedBox(height: 5.0),
                Text(
                    firebaseUser.displayName == null
                        ? ""
                        : firebaseUser.displayName,
                    style: new TextStyle(fontSize: 18.0))
              ],
            ))));
  }
}
