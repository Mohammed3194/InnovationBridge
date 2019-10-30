import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/AttendeesDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/BookmarksDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ExibitorsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/InnovationsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/MeetingsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ProgramDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/SpeedSessionDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/detailScreens/AnnouncementDetailScreen.dart';
import 'package:innovation_bridge/entities/Announcements.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementsDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  List<Data> listAnnouncements;
  AnnouncementsDashboard({@required this.listAnnouncements});

  @override
  _AnnouncementsDashboardState createState() => _AnnouncementsDashboardState(listAnnouncements);
}

class _AnnouncementsDashboardState extends State<AnnouncementsDashboard> {

  int _selectedDrawerIndex = 7;
  final GlobalKey<_AnnouncementsScreenState> _key = GlobalKey();
  final controller = new TextEditingController();


  List<Data> listOfAnnoucements;
  _AnnouncementsDashboardState(this.listOfAnnoucements);

  @override
  initState() {
    super.initState();
    controller.addListener(onChange);
  }

  onChange() {
    setState(() {
      print('@@ check if on every character == ' + controller.text);
      _key.currentState.methodUpdateFilter(controller.text);
    });
  }

  Widget appBarTitle = new Text("Announcement");
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
              /*if (widget.drawerItems[i].title == 'Announcements') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AnnouncementsDashboard()),
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
                  this.appBarTitle = new Text("Announcement");
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
      body: AnnouncementsScreen(key: _key, listOfAnnoucement: listOfAnnoucements),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}


class AnnouncementsScreen extends StatefulWidget {

  List<Data> listOfAnnoucement;
  AnnouncementsScreen({Key key, List<Data> this.listOfAnnoucement}) : super(key: key);

  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState(listOfAnnoucement);
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {

  String enteredText = '';
  String lastUpdatedDateTime;

  List<Data> initialAnnoucementList;
  List<Data> currentAnnoucementList = [];

  _AnnouncementsScreenState(this.initialAnnoucementList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterAnnouncement();

    Utils.setPreferenceInt(Constants.READ_COUNT, initialAnnoucementList.length);
    getLastUpdatedDateTime();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => storeUpdateDateTime(context));
  }

  void getLastUpdatedDateTime() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String lastDateTime = pref.getString(Constants.LAST_DATETIME);

    print('@@ last updated date time == $lastDateTime');

    setState(() {
      lastUpdatedDateTime = lastDateTime;
    });
  }

  storeUpdateDateTime(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 3000), (){
      DateTime now = DateTime.now();
      // String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      // 2019-10-18 01:42:29.081256
      // print('@@ current date time value == $now');
      // Utils.setPreference(Constants.LAST_DATETIME, "2019-10-15 01:42:29.081256");
      Utils.setPreference(Constants.LAST_DATETIME, now.toString());
    });
  }

  filterAnnouncement(){
    // Prepare lists
    List<Data> tmp = [];
    currentAnnoucementList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty ) {
      tmp.addAll(initialAnnoucementList);
    } else {
      for (Data c in initialAnnoucementList) {
        if (c.detail != null || c.detail != "") {
          if (c.title.toLowerCase().contains(name.toLowerCase()) ||
              c.detail.toLowerCase().contains(name.toLowerCase())) {
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
      currentAnnoucementList = tmp;
    });
  }

  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  Widget build(BuildContext context) {
    filterAnnouncement();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
          child: ListView.builder(
            itemCount: currentAnnoucementList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index){
              Data announcement = currentAnnoucementList.elementAt(index);

              print('@@ last updated date time inside widget method == $lastUpdatedDateTime');
              bool isGreenIcon = false;
              if (lastUpdatedDateTime == null){
                isGreenIcon = true;
              }
              else{
                DateFormat df1 = DateFormat("yyyy-MM-dd HH:mm:ssz");
                DateTime lastDateTime = df1.parse(lastUpdatedDateTime);

                DateFormat df2 = DateFormat("yyyy-MM-dd'T'HH:mm:ssz");
                DateTime annoucementDateTime = df2.parse(announcement.created);

                // print('@@ lastDateTime == $lastDateTime  and announcementDateTime == $annoucementDateTime');

                if (lastDateTime.isAfter(annoucementDateTime)){
                  // seen
                  //  Here, seen means no need to show the green icon (As we are using visibility) so it is false
                  isGreenIcon = false;
                }
                else{
                  // not seen
                  //  Here, not seen means we have to show the green icon (As we are using visibility) so it is true
                  isGreenIcon = true;
                }
              }

              if (announcement.detail != null){
                print(' @@@ program details length ${announcement.detail.length}');
                if (announcement.detail.length > 300){
                  firstHalf = announcement.detail.substring(0, 280);
                  secondHalf = announcement.detail.substring(50, announcement.detail.length);
                }
                else{
                  firstHalf = announcement.detail;
                  secondHalf = "";
                }
              }

              return Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 4),
                child: Container(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(announcement.title,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500
                                )),
                          ),
                          Visibility(
                            visible: isGreenIcon,
                            child: Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 10)),

                      announcement.detail != null ?
                      secondHalf.isEmpty
                          ? new Text(firstHalf, style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ))
                          : new Column(
                        children: <Widget>[
                          new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf), style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          )),
                          new InkWell(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Text(
                                  flag ? "more[..]" : "  less  ",
                                  style: new TextStyle(color: Colors.blue, fontSize: 12),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AnnouncementDetailScreen(
                                        announcement: announcement,
                                      )));
                              /*setState(() {
                                flag = !flag;
                              });*/
                            },
                          ),
                        ],
                      ) :
                      Text(""),

                      /*Text(announcement.detail,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[800]
                          )),*/

                      Padding(padding: EdgeInsets.only(top: 12)),

                      Divider(
                        color: Colors.black,
                        height: 2,
                      )
                    ],
                  ),
                ),
              );
            },
          )
      ),
    );
  }

  methodUpdateFilter(String text) {
    setState(() {
      enteredText = text;
    });
  }




  /*FutureBuilder _listDetails(){
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
