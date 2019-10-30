import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/AddBookmarkScreen.dart';
import 'package:innovation_bridge/EditDeleteBookmarkScreen.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/Attendees.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:innovation_bridge/entities/BookmarkDetails.dart' as bookDetails;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AttendeesDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _AttendeesDashboardState createState() => _AttendeesDashboardState();
}

class _AttendeesDashboardState extends State<AttendeesDashboard> {

  int _selectedDrawerIndex = 4;
  final GlobalKey<_AttendeesScreenState> _key = GlobalKey();
  final controller = new TextEditingController();

  List<Data> listOfAttendees = [];

  Future<List<Data>> _getAllAttendees() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(Uri.encodeFull(ServiceConstants.GET_ALL_ATTENDEES),
      headers: {"Content-Type":"application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
    );

    print("@@ response inside initState status code == ${response.statusCode}");
    print("@@ response  inside initState  json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of form template json data == $parsedJson");

    if (response.statusCode == 200){
      Attendees myClass = Attendees.fromJson(jsonDecode(response.body));
      print('@@ inside 200 $myClass');

      setState(() {
        listOfAttendees = myClass.data;
        return listOfAttendees;
      });
    }
    else if (response.statusCode == 401){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogOnClickAction(dialogTitle: Constants.TITLE_ALERT,
            errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
      );
    }
    else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: Constants.INTERNAL_SERVER_ERROR, toastLength: Toast.LENGTH_LONG);
    }
    else {
      Fluttertoast.showToast(msg: 'Somethins went wrong', toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  initState() {
    super.initState();
    controller.addListener(onChange);
    Utils.check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        _getAllAttendees();
      }
      else{
        print('No internet == ');
        Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
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

  Widget appBarTitle = new Text("Attendees");
  Icon actionIcon = new Icon(Icons.search);

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
            onTap: (){
              Navigator.of(context).pop();
              if (widget.drawerItems[i].title == 'Dashboard') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              /*if (widget.drawerItems[i].title == 'Attendees') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AttendeesDashboard()),
                      (Route<dynamic> route) => false,
                );
              }*/
              if (widget.drawerItems[i].title == 'Privacy Policy') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              if (widget.drawerItems[i].title == 'Terms & Conditions') {
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
                  this.appBarTitle = new Text("Attendees");
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
                  /*Container(
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
                  ),*/
                  new Column(children: drawerOptions)
                ],
              ),
            ),
          )
        ),
      ),
      body: listOfAttendees.length > 0 ? AttendeesScreen(key: _key, listOfAttendee: listOfAttendees)
          : Center(child: CircularProgressIndicator()),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}


class AttendeesScreen extends StatefulWidget {

  List<Data> listOfAttendee;
  AttendeesScreen({Key key, List<Data> this.listOfAttendee}) : super(key: key);

  @override
  _AttendeesScreenState createState() => _AttendeesScreenState(listOfAttendee);
}

class _AttendeesScreenState extends State<AttendeesScreen> {
  String enteredText = '';

  List<Data> initialAttendeeList;
  List<Data> currentAttendeeList = [];

  _AttendeesScreenState(this.initialAttendeeList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterAttendees();
  }

  filterAttendees(){
    // Prepare lists
    List<Data> tmp = [];
    currentAttendeeList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty ) {
      tmp.addAll(initialAttendeeList);
    } else {
      for (Data c in initialAttendeeList) {
        if (c.organisation != null) {
          if (c.name.toLowerCase().contains(name.toLowerCase()) ||
              c.organisation.toLowerCase().contains(name.toLowerCase())) {
            tmp.add(c);
          }
        }
        else{
          if (c.name.toLowerCase().contains(name.toLowerCase())){
            tmp.add(c);
          }
        }
      }
    }
    setState(() {
      currentAttendeeList = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    filterAttendees();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        child: ListView.builder(
          itemCount: currentAttendeeList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index){

            Data attendee = currentAttendeeList.elementAt(index);

            return Padding(
              padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 4),
              child: Container(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){

                      },
                      child: Text(attendee.name, style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      )),
                    ),
                    Padding(padding: EdgeInsets.only(top: 6)),

                    Container(
                      height: MediaQuery.of(context).size.height /14 ,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text('Type: '+attendee.type,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue
                                  )),
                                  Padding(padding: EdgeInsets.only(top: 4)),
                                  Text(attendee.designation,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: (){
                                        _launchURL(attendee.linkedIn);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 6),
                                        width: MediaQuery.of(context).size.width / 20,
                                        height: MediaQuery.of(context).size.height /20 ,
                                        child: Image(image: ExactAssetImage('images/icon_linkedin.png')),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child:  GestureDetector(
                                      onTap: (){
                                        bool isBookmarked = attendee.bookmarked;
                                        if (isBookmarked){
                                          // Already Bookmarked
                                          // initialAttendeeList.removeAt(index);
                                          Utils.check().then((internet){
                                            if (internet != null && internet){
                                              _getBookmarkDetailsById(attendee.bookmarkId);
                                            }
                                            else {
                                              Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                                            }
                                          });
                                        }
                                        else{
                                          // No Bookmarked
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)
                                            => AddBookmarkScreen(
                                              referencedId: attendee.id,
                                              nameTitle: attendee.name,
                                              type: Constants.TYPE_ATTENDEES,
                                              uuid: attendee.uuid,
                                            )),
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 6),
                                        width: MediaQuery.of(context).size.width / 20,
                                        height: MediaQuery.of(context).size.height /20 ,
                                        child: attendee.bookmarked ? Image(image: ExactAssetImage('images/bookmark_remove.png')) :
                                        Image(image: ExactAssetImage('images/bookmark_add.png')),
                                      ),
                                    ),
                                    /*Container(
                                      margin: EdgeInsets.only(bottom: 6),
                                      width: MediaQuery.of(context).size.width / 20,
                                      height: MediaQuery.of(context).size.height /20 ,
                                      child: attendee.bookmarked ? Image(image: ExactAssetImage('images/bookmark.png')) :
                                      Image(image: ExactAssetImage('images/bookmark_add.png')),
                                    ),*/
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 6),
                                      width: MediaQuery.of(context).size.width / 20,
                                      height: MediaQuery.of(context).size.height /20 ,
                                      child: Image(image: ExactAssetImage('images/icon_meeting_add.png')),
                                    ),
                                  )
                                 /* Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    width: MediaQuery.of(context).size.width / 11,
                                    height: MediaQuery.of(context).size.height /11 ,
                                    child: Image(image: ExactAssetImage('images/icon_linkedin.png')),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    width: MediaQuery.of(context).size.width / 11,
                                    height: MediaQuery.of(context).size.height /11 ,
                                    child: Image(image: ExactAssetImage('images/icon_linkedin.png')),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    width: MediaQuery.of(context).size.width / 11,
                                    height: MediaQuery.of(context).size.height /11 ,
                                    child: Image(image: ExactAssetImage('images/icon_linkedin.png')),
                                  )*/
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Divider(
                      color: Colors.black,
                      height: 2,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  methodUpdateFilter(String text) {
    setState(() {
      enteredText = text;
    });
  }

  Future<bookDetails.BookmarkDetails> _getBookmarkDetailsById(int bookmarkId) async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        });

    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.encodeFull(ServiceConstants.GET_BOOKMARK_BY_ID+bookmarkId.toString()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": pref.getString(Constants.AUTH_TOKEN)
      },
    );

    print("@@ response inside initState status code == ${response.statusCode}");
    print("@@ response  inside initState  json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of form template json data == $parsedJson");

    Navigator.pop(context);
    if (response.statusCode == 200) {
      bookDetails.BookmarkDetails details = bookDetails.BookmarkDetails.fromJson(jsonDecode(response.body));

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditDeleteBookmarkScreen(bookmarkDetails: details.data[0])),
      );

    } else if (response.statusCode == 401) {
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
    }
    else {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later', toastLength: Toast.LENGTH_LONG);
    }
  }

  /*FutureBuilder _listDetials(){
    return FutureBuilder(
      future: _fetchUsers(),
      builder: (context, snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError){
          return Text('${snapshot.error}');
        }
        else{
          return
        }
      },
    );
  }*/
}

class Users {
  int id;
  String name;
  String username;
  String email;

  Users({
    this.id,
    this.name,
    this.username,
    this.email,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
    );
  }
}
