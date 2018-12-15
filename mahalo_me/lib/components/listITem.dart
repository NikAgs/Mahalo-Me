import 'package:flutter/material.dart';

class CardListItem extends StatelessWidget {
  final String _user;
  final String _amount;
  final DateTime _timestamp;

  CardListItem(this._user, this._amount, this._timestamp);

  

  String formatTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    bool sameDay = now.day == timestamp.day &&
        now.month == timestamp.month &&
        now.year == timestamp.year;

    String amOrPM = timestamp.hour >= 12 ? ' pm' : ' am';
    String hour = (timestamp.hour % 12).toString();

    return sameDay
        ? hour + ':' + timestamp.minute.toString() + amOrPM
        : timestamp.month.toString() +
            '/' +
            timestamp.day.toString() +
            '/' +
            timestamp.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Container(
            child: new ListTile(
                contentPadding: EdgeInsets.all(20.0),
                leading: new Text(_user),
                title: new Text(
                  formatTimestamp(_timestamp),
                ),
                trailing: new Text('\$' + _amount)),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(color: Colors.black12)))));
  }
}
