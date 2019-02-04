import 'package:flutter/material.dart';
import "../../components/Buttons/roundedButton.dart";

import "../../theme/style.dart";

class WithdrawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text("Withdraw Funds"),
              backgroundColor: ThemeColors.cyan,
            ),
            body: new Container(
              width: screenSize.width,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(height: 50.0),
                  new Container(
                    width: screenSize.width - 50.0,
                    child: new Text(
                        "How much do you want to transfer to your account?",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: new Color(0xFF808080), fontSize: 18.0)),
                  ),
                  new SizedBox(height: 30.0),
                  new Theme(
                      data: homeTheme,
                      child: new Container(
                        width: 300.0,
                        child: new TextFormField(
                          onFieldSubmitted: (id) {},
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              icon: Icon(Icons.attach_money),
                              hintText: "0.00"),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                        ),
                      )),
                  new SizedBox(
                    height: 50.0,
                  ),
                  new RoundedButton(
                    buttonName: "Withdraw",
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                  content: Text("Do you want to withdraw " +
                                      // value
                                      " from your MahaloMe account?"),
                                  actions: <Widget>[
                                    FlatButton(
                                        textColor: ThemeColors.cyan,
                                        child: const Text("NO"),
                                        onPressed: () {}),
                                    FlatButton(
                                        textColor: ThemeColors.cyan,
                                        child: const Text("YES"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          // TODO: Make the withdrawal
                                        })
                                  ]));
                    },
                    width: 150.0,
                    height: 45.0,
                    bottomMargin: 0.0,
                    borderWidth: 0.0,
                    buttonColor: ThemeColors.cyan,
                    borderRadius: 10.0,
                  )
                ],
              ),
            )));
  }
}
