import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> loginScaffoldKey;
FirebaseUser firebaseUser;

String email;

bool paymentProcessing = false;
bool chargeProcessing = false;
bool sendingMoney = false;