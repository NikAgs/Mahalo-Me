import "package:flutter/material.dart";
import "../../theme/style.dart" as Theme;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.ThemeColors.cyan,
          bottom: TabBar(
            tabs: [
              Tab(text: "Send"),
              Tab(text: "Receive"),
              Tab(text: "Reload"),
            ],
          ),
          title: Text('MahaloMe'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the Drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              new Container(
                height: 125.0,
                child: DrawerHeader(
                  padding: EdgeInsets.all(18.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('John Appleseed',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      Text('johnappleseed@gmail.com',
                          style: new TextStyle(color: Colors.white))
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme.ThemeColors.cyan,
                  ),
                ),
              ),
              new Container(
                  height: 40.0,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "\$50.00",
                        style: new TextStyle(
                            fontSize: 15.0, color: new Color(0xFF4d4d4d)),
                      ),
                      new SizedBox(width: 15.0, height: 0.0),
                      new Text("Balance",
                          style: new TextStyle(fontSize: 15.0, color: new Color(0xFF4d4d4d))),
                    ],
                  )),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.equalizer),
                title: Text('Reports'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Logout'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}