import 'package:flutter/material.dart';

import '../../services/formatters.dart';

import '../../theme/style.dart' as Theme;

class AddCardScreen extends StatefulWidget {
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  bool _autovalidate = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new MaterialApp(
        theme: Theme.homeTheme,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.ThemeColors.cyan,
              title: Text("Add Payment Method"),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: new SingleChildScrollView(
                child: new Container(
                    height: screenSize.height < 500
                        ? 500.0
                        : screenSize.height - 85.0,
                    child: new Container(
                        height: 700.0,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Form(
                                key: _formKey,
                                autovalidate: _autovalidate,
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: new TextFormField(
                                        inputFormatters: [
                                          MaskedTextInputFormatter(
                                            mask: 'xxxx xxxx xxxx xxxx',
                                            separator: ' ',
                                          ),
                                        ],
                                        decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            icon: Icon(Icons.credit_card),
                                            labelText: 'Card Number',
                                            hintText: '1234 5678 1234 5678'),
                                        keyboardType: TextInputType.number,
                                        onSaved: (String value) {},
                                        validator: (input) {
                                          return input;
                                        },
                                      ),
                                    ),
                                    new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: new Row(
                                          children: <Widget>[
                                            new Container(
                                              width: 125.0,
                                              child: new TextFormField(
                                                inputFormatters: [
                                                  MaskedTextInputFormatter(
                                                    mask: 'xx/xx',
                                                    separator: '/',
                                                  ),
                                                ],
                                                decoration: const InputDecoration(
                                                    border:
                                                        UnderlineInputBorder(),
                                                    labelText: 'Exp. Date',
                                                    hintText: 'MM/YY'),
                                                keyboardType:
                                                    TextInputType.number,
                                                onSaved: (String value) {},
                                                validator: (input) {
                                                  return input;
                                                },
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ))
                          ],
                        ))))));
  }
}
