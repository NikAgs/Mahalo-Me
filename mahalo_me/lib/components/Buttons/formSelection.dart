import "package:flutter/material.dart";

import "../../theme/style.dart" as Theme;

class FormSelection extends StatelessWidget {
  final String selected;
  final String value;
  final VoidCallback onPress;

  FormSelection(this.value, this.onPress, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new GestureDetector(
      child: new Container(
          decoration: new BoxDecoration(
              boxShadow: [
                new BoxShadow(
                    offset: new Offset(1.0, 1.0),
                    color: Colors.grey,
                    blurRadius: 2.0)
              ],
              color: selected == value
                  ? Theme.ThemeColors.purple
                  : Color(0xFFe6e6e6),
              borderRadius: new BorderRadius.circular(10.0)),
          width: 200.0,
          height: 40.0,
          child: new Center(
            child: new Text(
              value,
              style: selected == value
                  ? new TextStyle(color: Colors.white)
                  : new TextStyle(color: Colors.black87),
            ),
          )),
      onTap: () {
        print(value);
        onPress();
      },
    ));
  }
}
