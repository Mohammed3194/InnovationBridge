import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/detailScreens/DeclineEventSchedule.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/MyEventSchedule.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class MyEventScheduleDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _MyEventScheduleDashboardState createState() => _MyEventScheduleDashboardState();
}

class _MyEventScheduleDashboardState extends State<MyEventScheduleDashboard> {

  int _selectedDrawerIndex = 5;
  final controller = new TextEditingController();
  final GlobalKey<_MyEventScheduleScreenState> _key = GlobalKey();

  List<Data> listOfEventSchedule = [];

  Future<List<Data>> _fetchEventSchedule() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.encodeFull(ServiceConstants.GET_EVENT_SCHEDULE),
      headers: {
        "Content-Type": "application/json",
        "Authorization": pref.getString(Constants.AUTH_TOKEN)
      },
    );

    print("@@ response inside evenet schedule status code == ${response.statusCode}");
    print("@@ response  inside event schedule  json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of form template json data == $parsedJson");

    if (response.statusCode == 200) {
      MyEventSchedule myClass =
      MyEventSchedule.fromJson(jsonDecode(response.body));
      print('@@ inside 200 $myClass');

      List<Data> listEvent = myClass.data;
      List<Data> listEventConfirmed = [];
      if (listEvent != null && listEvent.length > 0) {
        for (var event in listEvent){
          if (event.attendanceStatus == "confirmed"){
            listEventConfirmed.add(event);
          }
        }

        setState(() {
          listOfEventSchedule = listEventConfirmed;
        });
      }
    } else if (response.statusCode == 401){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogOnClickAction(dialogTitle: Constants.TITLE_ALERT,
            errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
      );
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(
          msg: Constants.INTERNAL_SERVER_ERROR, toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(
          msg: 'Somethins went wrong', toastLength: Toast.LENGTH_LONG);
    }
  }

  Widget appBarTitle = new Text("My Event Schedule");
  Icon actionIcon = new Icon(Icons.search);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onChange);
    Utils.check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        _fetchEventSchedule();
      } else {
        print('No internet == ');
        Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
        // Utils.showCommonMessageDialog(this, title, message);
      }
      // No-Internet Case
    });
  }

  onChange() {
    setState(() {
      print('@@ check if on every character == ' + controller.text);
      _key.currentState.methodUpdateFilter(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    //Let's create drawer list items. Each will have an icon and text
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          ListTile(
            leading: Container(
              width: MediaQuery.of(context).size.width / 12,
              height: MediaQuery.of(context).size.height / 12,
              child: d.image,
            ),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            // onTap: () => _onSelectItem(i),
            onTap: () {
              Navigator.of(context).pop();
              if (widget.drawerItems[i].title == 'Dashboard') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              if (widget.drawerItems[i].title == 'Privacy Policy') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              if (widget.drawerItems[i].title == 'Terms & Conditions'){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TermsConditionsDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              if (widget.drawerItems[i].title == 'Logout') {

                Utils.setPreference(Constants.LOGIN_CHECK, Constants.LOGGED_OUT);
                Utils.clearPreference();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            },
          )
      );
    }
    //Let's scaffold our homepage
    return new Scaffold(
      appBar: new AppBar(
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    controller: controller,
                    autofocus: true,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),
                  );}
                else {
                  setState(() {
                    controller.clear();
                  });
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("My Event Schedule");
                }
              });
            } ,),]
      ),
      // Let's register our Drawer to the Scaffold
      drawer: SafeArea(
        child: new Drawer(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new Column(children: drawerOptions)
                  ],
                ),
              ),
            )
        ),
      ),
      body: listOfEventSchedule.length > 0
          ? MyEventScheduleScreen(key: _key, listOfEventsSchedule: listOfEventSchedule)
          : Center(
          child:
          Text('No scheduled events found'))
    );
  }
}

class MyEventScheduleScreen extends StatefulWidget {

  List<Data> listOfEventsSchedule;
  MyEventScheduleScreen({Key key, List<Data> this.listOfEventsSchedule})
      : super(key: key);


  @override
  _MyEventScheduleScreenState createState() => _MyEventScheduleScreenState(listOfEventsSchedule);
}

class _MyEventScheduleScreenState extends State<MyEventScheduleScreen> {

  String enteredText = '';

  List<Data> initialEventScheduleList;
  List<Data> currentEventScheduleList = [];

  _MyEventScheduleScreenState(this.initialEventScheduleList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterEventsScheduled();
  }

  @override
  Widget build(BuildContext context) {
    filterEventsScheduled();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView.builder(
        itemCount: currentEventScheduleList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index){

          Data eventSchedule = currentEventScheduleList.elementAt(index);

          // Data speedSession = currentSpeedSessionList.elementAt(index);

          return Padding(
            padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
            child: Container(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width /19,
                        height: MediaQuery.of(context).size.height /19,
                        child: Image(image: ExactAssetImage('images/icon_speed_date.png')),
                      ),
                      Padding(padding: EdgeInsets.only(left: 6)),
                      Text(eventSchedule.title, style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      )),
                    ],
                  ),

                  Text(eventSchedule.date + "(${eventSchedule.startTime +" - " + eventSchedule.endTime })", style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  )),

                  Padding(padding: EdgeInsets.only(top: 5)),
                  Text(eventSchedule.location != null ? eventSchedule.location : "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )
                  ),

                  Padding(padding: EdgeInsets.only(top: 5)),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeclineEventSchedule(eventDetials: eventSchedule)));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4.2,
                      height: MediaQuery.of(context).size.height / 22,
                      child: Container(
                        color: Colors.grey[400],
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(8),
                              child: Image(image: ExactAssetImage('images/icon_decline.png')),
                            ),
                            Text('DECLINE',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black
                              ),),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 5)),

                  Divider(
                    color: Colors.black,
                  )

                ],
              ),
            ),
          );
        },
      )
    );
  }

  methodUpdateFilter(String text) {
    setState(() {
      enteredText = text;
    });
  }

  filterEventsScheduled(){
    // Prepare lists
    List<Data> tmp = [];
    currentEventScheduleList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty ) {
      tmp.addAll(initialEventScheduleList);
    } else {
      for (Data c in initialEventScheduleList) {
        if (c.title.toLowerCase().contains(name.toLowerCase())) {
          tmp.add(c);
        }
        else{
          if (c.title.toLowerCase().contains(name.toLowerCase())){
            tmp.add(c);
          }
        }
      }
    }
    setState(() {
      currentEventScheduleList = tmp;
    });
  }
}


class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}
