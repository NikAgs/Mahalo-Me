import 'package:flutter/material.dart';
import '../../theme/style.dart' as Theme;
import 'received.dart';
import 'sent.dart';

class ReportsScreen extends StatefulWidget {
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.ThemeColors.cyan,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Sent"),
                Tab(text: "Received"),
              ],
            ),
            title: Text('Reports'),
          ),
          body: TabBarView(
            children: [
              new SentReports(),
              new ReceivedReports(),
            ],
          ),
        ),
      ),
    );
  }
}
