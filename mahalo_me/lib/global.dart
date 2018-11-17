import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

FirebaseUser firebaseUser;

String email;
