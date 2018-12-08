import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global.dart';
import '../../components/listITem.dart';

class SentReports extends StatefulWidget {
  _SentReportsState createState() => _SentReportsState();
}

class _SentReportsState extends State<SentReports> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(firebaseUser.displayName)
            .collection('sent')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return new Text('');
          }
          return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return new CardListItem(ds.data['receiver'], ds.data['amount'].toString(),
                    ds.data['timestamp']);
              });
        },
      ),
    );
  }
}
