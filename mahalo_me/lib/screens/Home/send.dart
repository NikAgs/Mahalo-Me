import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:barcode_scan/barcode_scan.dart';

class SendMoney extends StatefulWidget {
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return new SingleChildScrollView(
        child: new Container(
            height: screenSize.height < 500 ? 500.0 : screenSize.height - 140.0,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Scan a MahaloMe QR code",
                      style:
                          new TextStyle(color: Colors.black54, fontSize: 19.0)),
                  new SizedBox(height: 50.0),
                  new Container(
                      width: 200.0,
                      height: 200.0,
                      child: new RaisedButton(
                          onPressed: scan,
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
                      keyboardType: TextInputType.text,
                      onSaved: (String value) {},
                      validator: (input) {
                        return input;
                      },
                    ),
                  )
                ])));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
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
}
