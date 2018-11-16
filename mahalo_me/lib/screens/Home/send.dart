import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';

class SendMoney extends StatefulWidget {
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {

  String _platformVersion = 'Unknown';
  String barcode = "";

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

   initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SimplePermissions.platformVersion;
    } catch(e) {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

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
              keyboardType: TextInputType.phone,
              onSaved: (String value) {},
              validator: (input) {
                return input;
              },
            ),
          )
        ]));
  }

  
  Future scan() async {
    Permission cameraPermission = Permission.Camera;

    bool res = await SimplePermissions.checkPermission(cameraPermission);
    print("permission is " + res.toString());

    if (!res) {
      final res = await SimplePermissions.requestPermission(cameraPermission);
      print("permission request result is " + res.toString());
    }

    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }
  }
}

