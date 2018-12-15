import 'package:flutter/material.dart';

import '../../services/formatters.dart';
import '../../services/validations.dart';
import '../../services/payment.dart';

import '../../theme/style.dart' as Theme;

import '../../global.dart';

class _CardData {
  String number = '';
  String expDate = '';
  String cvv = '';
  String postalCode = '';
}

class AddCardScreen extends StatefulWidget {
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  bool _autovalidate = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Validations _validations = new Validations();
  _CardData _cardData = new _CardData();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new MaterialApp(
        theme: Theme.homeTheme,
        home: Scaffold(
            key: _scaffoldKey,
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
                            new SizedBox(height: 20.0),
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
                                        onSaved: (String value) {
                                          this._cardData.number = value;
                                        },
                                        validator:
                                            _validations.validateCreditCard,
                                      ),
                                    ),
                                    new SizedBox(height: 20.0),
                                    new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                                  onSaved: (String value) {
                                                    this._cardData.expDate =
                                                        value;
                                                  },
                                                  validator: _validations
                                                      .validateExpDate),
                                            ),
                                            new Container(
                                              width: 125.0,
                                              child: new TextFormField(
                                                  inputFormatters: [
                                                    MaskedTextInputFormatter(
                                                      mask: 'xxx',
                                                      separator: '/',
                                                    ),
                                                  ],
                                                  decoration: const InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                      labelText: 'CVV',
                                                      hintText: '123'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onSaved: (String value) {
                                                    this._cardData.cvv = value;
                                                  },
                                                  validator:
                                                      _validations.validateCVV),
                                            ),
                                          ],
                                        )),
                                    new SizedBox(height: 20.0),
                                    new Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: new TextFormField(
                                          inputFormatters: [
                                            MaskedTextInputFormatter(
                                              mask: 'xxxxx',
                                              separator: ' ',
                                            ),
                                          ],
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            icon: Icon(Icons.place),
                                            labelText: 'Postal Code',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onSaved: (String value) {
                                            this._cardData.postalCode = value;
                                          },
                                          validator:
                                              _validations.validatePostalCode),
                                    ),
                                    new SizedBox(height: 40.0),
                                    new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            new RaisedButton(
                                              child: new Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            new RaisedButton(
                                              color: Theme.ThemeColors.cyan,
                                              textColor: Colors.white,
                                              child: new Text("Submit"),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _formKey.currentState.save();
                                                  await addCreditCard(
                                                      _cardData.number,
                                                      _cardData.expDate,
                                                      _cardData.cvv,
                                                      _cardData.postalCode);
                                                  paymentProcessing = true;
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          "/PaymentMethods");
                                                }
                                              },
                                            )
                                          ],
                                        )),
                                  ],
                                ))
                          ],
                        ))))));
  }
}
