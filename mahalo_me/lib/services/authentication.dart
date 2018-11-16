import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../global.dart';

class UserData {
  String displayName;
  String email;
  String uid;
  String password;
  String confirmPassword;

  UserData({this.displayName, this.email, this.uid, this.password});
}

class UserAuth {
  String statusMsg = "Account Created Successfully";
  //To create new User
  Future<String> createUser(UserData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email, password: userData.password);

    try {
      await user.sendEmailVerification();
    } catch(e) {
      print(e);
    }
    
    return "Email verification sent to: " + userData.email;
  }

  //To verify new User
  Future<String> verifyUser(UserData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth.signInWithEmailAndPassword(
        email: userData.email, password: userData.password);

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    
    if (!user.isEmailVerified) {
      return "Please verify your email to login";
    }

    email = userData.email;
    firebaseUser = user;

    return "Login Successfull";
  }
}
