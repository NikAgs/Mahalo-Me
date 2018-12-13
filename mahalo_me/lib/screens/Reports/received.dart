import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global.dart';
import '../../components/listITem.dart';

class ReceivedReports extends StatefulWidget {
  _ReceivedReportsState createState() => _ReceivedReportsState();
}

class _ReceivedReportsState extends State<ReceivedReports> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(firebaseUser.displayName)
            .collection('received')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return new Text('');
          }
          return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                 if (!ds.data.containsKey("error")) {
                  return new CardListItem(ds.data['sender'],
                      ds.data['amount'].toString(), ds.data['timestamp']);
                }
              });
        },
      ),
    );
  }
}
