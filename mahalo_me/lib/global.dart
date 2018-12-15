import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> loginScaffoldKey;
FirebaseUser firebaseUser;

String email;

bool paymentProcessing = false;
bool chargeProcessing = false;
bool sendingMoney = false;

final flutterWebViewPlugin = FlutterWebviewPlugin();