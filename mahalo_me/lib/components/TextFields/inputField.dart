import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  double bottomMargin;
  TextStyle textStyle, hintStyle;
  var validateFunction;
  var onSaved;
  Key key;
  TextEditingController controller;

  //passing props in the Constructor.
  InputField(
      {this.key,
      this.hintText,
      this.obscureText,
      this.textInputType,
      this.textFieldColor,
      this.icon,
      this.iconColor,
      this.bottomMargin,
      this.textStyle,
      this.validateFunction,
      this.onSaved,
      this.hintStyle,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin),
        child: new DecoratedBox(
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                color: textFieldColor),
            child: new Container(
              height: 45.0,
              child: new TextFormField(
                controller: controller,
                style: textStyle,
                key: key,
                obscureText: obscureText,
                keyboardType: textInputType,
                validator: validateFunction,
                onSaved: onSaved,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: hintStyle,
                    icon: new Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: new Icon(
                        icon,
                        color: iconColor,
                      ),
                    )),
              ),
            ))));
  }
}
