import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/TextFields/inputField.dart';
import '../../components/Buttons/textButton.dart';
import '../../components/Buttons/roundedButton.dart';
import '../../services/validations.dart';
import '../../services/authentication.dart';
import '../../theme/style.dart' as Theme;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  SignUpScreenState createState() => new SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserData newUser = new UserData();
  UserAuth userAuth = new UserAuth();
  bool _autovalidate = false;
  Validations _validations = new Validations();

  _onPressed() {
    print("button clicked");
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      userAuth.createUser(newUser).then((onValue) {
        showInSnackBar(onValue);
      }).catchError((PlatformException onError) {
        showInSnackBar(onError.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(16.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.ThemeColors.lighterPurple,
                    Theme.ThemeColors.cyan,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // new SizedBox(height: 10.0),
                // new IconButton(icon: new Icon( Icons.arrow_back, color: Colors.white), onPressed: () {Navigator.of(context).pop();},),
                new SizedBox(
                    height: screenSize.height / 2,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text("CREATE ACCOUNT",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    )),
                new SizedBox(
                  height: screenSize.height / 2,
                  child: new Column(
                    children: <Widget>[
                      new Form(
                          key: _formKey,
                          autovalidate: _autovalidate,
                          //onWillPop: _warnUserAboutInvalidData,
                          child: new Column(
                            children: <Widget>[
                              new InputField(
                                hintText: "Username",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                textStyle: Theme.textStyle,
                                textFieldColor:
                                    const Color.fromRGBO(255, 255, 255, 0.2),
                                icon: Icons.person_outline,
                                iconColor: Colors.white,
                                bottomMargin: 25.0,
                                validateFunction: _validations.validateName,
                                onSaved: (String name) {
                                  newUser.displayName = name;
                                },
                              ),
                              new InputField(
                                  hintText: "Email",
                                  obscureText: false,
                                  textInputType: TextInputType.emailAddress,
                                  textStyle: Theme.textStyle,
                                  textFieldColor:
                                      const Color.fromRGBO(255, 255, 255, 0.2),
                                  icon: Icons.mail_outline,
                                  iconColor: Colors.white,
                                  bottomMargin: 25.0,
                                  validateFunction: _validations.validateEmail,
                                  onSaved: (String email) {
                                    newUser.email = email;
                                  }),
                              new InputField(
                                  hintText: "Password",
                                  obscureText: true,
                                  textInputType: TextInputType.text,
                                  textStyle: Theme.textStyle,
                                  textFieldColor:
                                      const Color.fromRGBO(255, 255, 255, 0.2),
                                  icon: Icons.lock_open,
                                  iconColor: Colors.white,
                                  bottomMargin: 25.0,
                                  validateFunction:
                                      _validations.validatePassword,
                                  onSaved: (String password) {
                                    newUser.password = password;
                                  }),
                              new RoundedButton(
                                buttonName: "Continue",
                                onTap: _handleSubmitted,
                                width: screenSize.width,
                                height: 50.0,
                                bottomMargin: 10.0,
                                borderWidth: 1.0,
                                borderRadius: 30.0,
                              )
                            ],
                          )),
                      new TextButton(
                        buttonName: "Terms & Condition",
                        onPressed: _onPressed,
                        buttonTextStyle: Theme.buttonTextStyle,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
