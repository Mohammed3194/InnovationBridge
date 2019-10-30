import 'package:flutter/material.dart';
import 'package:innovation_bridge/fragments/AnnouncementsScreen.dart';
import 'package:innovation_bridge/fragments/AttendeesScreen.dart';
import 'package:innovation_bridge/fragments/BookmarksScreen.dart';
import 'package:innovation_bridge/fragments/ExibitorsScreen.dart';
import 'package:innovation_bridge/fragments/HomeScreen.dart';
import 'package:innovation_bridge/fragments/InnovationsScreen.dart';
import 'package:innovation_bridge/fragments/MeetingsScreen.dart';
import 'package:innovation_bridge/fragments/PrivacyPolicyScreen.dart';
import 'package:innovation_bridge/fragments/ProgramScreen.dart';
import 'package:innovation_bridge/fragments/SpeedSessionScreen.dart';
import 'package:innovation_bridge/fragments/TermsConditionsScreen.dart';
import 'package:innovation_bridge/utils/Utils.dart';

class MeetingsDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard"),
    new DrawerItem("Program"),
    new DrawerItem("Exibitors"),
    new DrawerItem("Innovations"),
    new DrawerItem("Attendees"),
    new DrawerItem("Speed Session"),
    new DrawerItem("Bookmarks"),
    new DrawerItem("Announcements"),
    new DrawerItem("Privacy Policy"),
    new DrawerItem("Terms & Conditions"),
    new DrawerItem("Logout")
  ];

  @override
  _MeetingsDashboardState createState() => _MeetingsDashboardState();
}

class _MeetingsDashboardState extends State<MeetingsDashboard> {

  int _selectedDrawerIndex = 5;

  //Let's use a switch statement to return the Fragment for a selected item
  _getDrawerFragment(int pos) {
    switch (pos) {
      case 0:
        return new HomeScreen();
      case 1:
        return new ProgramScreen();
      case 2:
        return new ExibitorsScreen();
      case 3:
        return new InnovationsScreen();
      case 4:
        return new AttendeesScreen();
      case 5:
        return new SpeedSessionScreen();
      case 6:
        return new BookmarksScreen();
      case 7:
        return new AnnouncementsScreen();
      case 8:
        return new PrivacyPolicyScreen();
      case 9:
        return new TermsConditionsScreen();

      default:
        return new Text("Error");
    }
  }
  //Let's update the selectedDrawerItemIndex the close the drawer
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    //we close the drawer
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    //Let's create drawer list items. Each will have an icon and text
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          ListTile(
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }
    //Let's scaffold our homepage
    return new Scaffold(
      appBar: new AppBar(
        // We will dynamically display title of selected page
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: (){

            },
          ),

          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.filter_list),
            onPressed: (){

            },
          )
        ],
      ),
      // Let's register our Drawer to the Scaffold
      drawer: SafeArea(
        child: new Drawer(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Utils.hexToColor("#F24A1C"),
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Menu', style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ))
                      ),
                    ),
                  ),
                  new Column(children: drawerOptions)
                ],
              ),
            ),
          )
        ),
      ),
      body: MeetingsScreen(),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title);
}
