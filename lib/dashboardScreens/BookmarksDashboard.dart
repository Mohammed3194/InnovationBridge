import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/AnnouncementsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/AttendeesDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ExibitorsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/InnovationsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/MeetingsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ProgramDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/SpeedSessionDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/dialogs/RemoveBookmarkDialog.dart';
import 'package:innovation_bridge/entities/Bookmarks.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksDashboard extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _BookmarksDashboardState createState() => _BookmarksDashboardState();
}

class _BookmarksDashboardState extends State<BookmarksDashboard> {
  int _selectedDrawerIndex = 6;
  final GlobalKey<_BookmarksScreenState> _key = GlobalKey();
  final controller = new TextEditingController();

  List<Data> listOfBookmarks = [];

  Future<List<Data>> _getAllAttendees() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.encodeFull(ServiceConstants.GET_ALL_BOOKMARKS),
      headers: {
        "Content-Type": "application/json",
        "Authorization": pref.getString(Constants.AUTH_TOKEN)
      },
    );

    print("@@ response inside initState status code == ${response.statusCode}");
    print("@@ response  inside initState  json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of form template json data == $parsedJson");

    if (response.statusCode == 200) {
      Bookmarks myClass = Bookmarks.fromJson(jsonDecode(response.body));
      print('@@ inside 200 $myClass');

      setState(() {
        listOfBookmarks = myClass.data;
        print('@@ bookmark list size == '+listOfBookmarks.length.toString());
        return listOfBookmarks;
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

  Widget appBarTitle = new Text("Bookmarks");
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    //Let's create drawer list items. Each will have an icon and text
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
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
          /*if (widget.drawerItems[i].title == 'Bookmarks') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => BookmarksDashboard()),
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
              MaterialPageRoute(
                  builder: (context) => TermsConditionsDashboard()),
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
      ));
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
                  this.appBarTitle = new Text("Bookmarks");
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
                        child: Text('Menu',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white))),
                  ),
                ),*/
                new Column(children: drawerOptions)
              ],
            ),
          ),
        )),
      ),
      body: listOfBookmarks.length > 0
          ? BookmarksScreen(key: _key, listOfBookmark: listOfBookmarks)
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


class BookmarksScreen extends StatefulWidget {
  List<Data> listOfBookmark;
  BookmarksScreen({Key key, List<Data> this.listOfBookmark}) : super(key: key);

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState(listOfBookmark);
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  String enteredText = '';

  String text = 'Text';

  List<Data> initialBookmarkList;
  List<Data> currentBookmarkList = [];

  _BookmarksScreenState(this.initialBookmarkList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterBookmarks();
  }

  filterBookmarks(){
    // Prepare lists
    List<Data> tmp = [];
    currentBookmarkList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty ) {
      tmp.addAll(initialBookmarkList);
    } else {
      for (Data c in initialBookmarkList) {
        if (c.comment != null || c.comment != "") {
          if (c.title.toLowerCase().contains(name.toLowerCase()) ||
              c.comment.toLowerCase().contains(name.toLowerCase())) {
            tmp.add(c);
          }
        }
        else{
          if (c.title.toLowerCase().contains(name.toLowerCase())){
            tmp.add(c);
          }
        }
      }
    }
    setState(() {
      currentBookmarkList = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    filterBookmarks();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
          child: ListView.builder(
            itemCount: currentBookmarkList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              Data bookmark = currentBookmarkList.elementAt(index);
              return Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 4),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Text(bookmark.title,
                            style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      ),
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Text('Type: ' +bookmark.type,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black
                          )),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      Text('Comment:' +bookmark.comment,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black
                          )),
                      Padding(padding: EdgeInsets.only(top: 6)),

                      /*Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width /13,
                        height: MediaQuery.of(context).size.height /13,
                        child: Image(image: ExactAssetImage('images/bookmark.png')),
                      ),
                      Text('Remove',style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ) )
                    ],
                  ),*/
                      Padding(padding: EdgeInsets.only(top: 10)),

                      GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 22,
                          child: Container(
                            /*shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0)),
                      textColor: Colors.black,*/
                              color: Colors.grey[400],
                              child: GestureDetector(
                                onTap: (){
                                  _awaitReturnValueFromBookmarkScreen(context, index, bookmark);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Image(image: ExactAssetImage('images/icon_decline.png')),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('REMOVE',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black
                                          ),),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            // onPressed: () {}
                          ),
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 15)),
                      Divider(
                        color: Colors.black,
                        height: 2,
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  void _awaitReturnValueFromBookmarkScreen(BuildContext context, int index, Data annoucement) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RemoveBookmarkDialog(id: annoucement.id, comment: annoucement.comment,),
    );

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      text = result;
      print('@@ result message from bookmark screen == ' + text);
      if (text == 'Success'){
        initialBookmarkList.removeAt(index);
      }
    });
  }

  methodUpdateFilter(String text) {
    setState(() {
      enteredText = text;
    });
  }

  /* FutureBuilder _listDetials(){
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
          return ;
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
