import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/NoActiveEventsScreen.dart';
import 'package:innovation_bridge/dashboardScreens/AnnouncementsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/AttendeesDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/BookmarksDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ExibitorsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/InnovationsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/MeetingsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/MyEventScheduleDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ProgramDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/SpeedSessionDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/Announcements.dart';
import 'package:innovation_bridge/entities/BookmarkResponse.dart';
import 'package:innovation_bridge/entities/EventDetail.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import 'package:innovation_bridge/entities/MapDetail.dart' as map;

// import 'package:qrscan/qrscan.dart' as scanner;

import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeDashboard extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final GlobalKey<_HomeScreenState> _key = GlobalKey();

  int _selectedDrawerIndex = 0;
  final controller = new TextEditingController();

  @override
  initState() {
    super.initState();
    // controller.addListener(onChange);
  }

 /* onChange() {
    setState(() {
      print('@@ check if on every character == ' + controller.text);
      _key.currentState.methodUpdateFilter(controller.text);
    });
  }*/

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text('', style: new TextStyle(color: Colors.white));

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    //Let's create drawer list items. Each will have an icon and text
    // this.appBarTitle = new Text('Dashboard', style: new TextStyle(color: Colors.white));
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
        onTap: () {
          Navigator.of(context).pop();
          /*if (widget.drawerItems[i].title == 'Dashboard') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeDashboard()),
              (Route<dynamic> route) => false,
            );
          }*/
          if (widget.drawerItems[i].title == 'Program') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProgramDashboard()),
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
        // onTap: () => _onSelectItem(i,widget.drawerItems[i].title),
      ));
    }

    //Let's scaffold our homepage
    return new Scaffold(
      /*appBar: eventDetails == null ? null : AppBar(
        title: Text('Dashboard'),
      ),*/
      appBar: AppBar(title: Text('Dashboard')),
     /* appBar: new AppBar(
        // We will dynamically display title of selected page
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    controller: controller,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        //prefixIcon: new Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)),
                  );
                } else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle =
                      new Text(widget.drawerItems[_selectedDrawerIndex].title);
                }
              });
            },
          ),
        ],
      ),*/
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
      // body: eventDetails != null ? HomeScreen(eventDetail: eventDetails) : Center(child: CircularProgressIndicator()),
      // body: HomeScreen(eventDetail: eventDetails),
      body: HomeScreen(),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}

class HomeScreen extends StatefulWidget {
  // EventDetail eventDetail;
  // HomeScreen({Key key, this.eventDetail}) : super(key: key);
  // HomeScreen({@required this.eventDetail});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  // EventDetail eventDetail;
  // _HomeScreenState(this.eventDetail);

  methodUpdateFilter(String text) {
    Fluttertoast.showToast(msg: text);
    /*setState(() {
      enteredText = text;

    });*/
  }

  String eventName = '';
  String eventStartDate = '';
  String eventEndDate = '';
  int annoucementCount = 0;

  @override
  void initState() {
    super.initState();
    getEventDetails();
    Utils.check().then((internet){
      if (internet != null && internet){
        getAnnoucementCount();
      }
      else{
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CommonMessageDialog(
            dialogTitle: Constants.TITLE_ALERT,
            errorMessage: Constants.CHECK_NETWORK_CONNECTION,
          )
        );
      }
    });
  }


  Future<Null> getEventDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      eventName = prefs.getString(Constants.EVENT_NAME);
      eventStartDate = prefs.getString(Constants.EVENT_START_DATE);
      eventEndDate = prefs.getString(Constants.EVENT_END_DATE);
    });
  }

  List<Data> listOfAnnoucements = [];
  Future<Null> getAnnoucementCount() async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        });

    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(Uri.encodeFull(ServiceConstants.GET_ALL_ANNOUNCEMENTS),
      headers: {"Content-Type":"application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
    );

    if (response.statusCode == 200){
      Announcements myClass = Announcements.fromJson(jsonDecode(response.body));
      // map.MapDetail myClass = map.MapDetail.fromJson(jsonDecode(response.body));

      SharedPreferences pref = await SharedPreferences.getInstance();
      int readCount = pref.getInt(Constants.READ_COUNT);

      listOfAnnoucements = myClass.data;
      print('@@ list of annoucement count == ${listOfAnnoucements.length.toString()}');
      Utils.setPreferenceInt(Constants.UN_READ_COUNT, listOfAnnoucements.length);

      int unReadCount = pref.getInt(Constants.UN_READ_COUNT);
      print('@@@ @@@@ un read count == $unReadCount');

      Navigator.of(context).pop();
      setState(() {

        if (readCount == null){
          annoucementCount = listOfAnnoucements.length;
        }
        else{
          print('@@ inside else condition ========== ');
          if (unReadCount == null){
            print('@@ @@@@@@@@@@@@@@@@@@@ inside unread count === ');
          }
          else{
            if (readCount > unReadCount){
              int unreadCount = unReadCount;
              annoucementCount = unreadCount - readCount;
              print('@@ inside count difference calculation == $annoucementCount');
            }
            else{
              annoucementCount = 0;
            }
          }

        }
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
  }

  /*updateAnnouncementCount(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      int readCount = pref.getInt(Constants.READ_COUNT);

      setState(() {
        print('@@@@@@ read count value $readCount');
        print('@@@@@@ un read count value ${listOfAnnoucements.length}');

      });
    });
  }*/


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = size.height / 9;
    final double itemWidth = size.width / 4;

    //DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssz");
    //DateTime startDateTime = dateFormat.parse(eventDetail.startDate);
    //DateTime endDateTime = dateFormat.parse(eventDetail.endDate);

    // String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    // print('@@ formatted date == '+formattedDate);

    print('@@ formatted date inside home screen == '+eventName + " " + eventStartDate + ' ' + eventEndDate);

    return Scaffold(
        resizeToAvoidBottomInset : false,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    width: double.infinity,
                    color: Colors.grey[350],
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(eventName,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 6)),
                          Text(eventStartDate + " - " +
                              eventEndDate,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Utils.hexToColor("#F24A1C"),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ))
                        ],
                      ),
                    )
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Container(
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            crossAxisCount: 3,
                            padding: const EdgeInsets.all(20.0),
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5,
                            childAspectRatio: (itemWidth / itemHeight),
                            children: <Widget>[

                              // Event Program . .
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProgramDashboard()),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: new Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 3,
                                                  child: Container(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Container(
                                                        margin: EdgeInsets.all(10),
                                                        child: Image(image: ExactAssetImage('images/event_program.png')),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Align(
                                                      alignment: Alignment.topCenter,
                                                      child: Text('EVENT PROGRAM',
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyEventScheduleDashboard()),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: new Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 3,
                                                  child: Container(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Container(
                                                        margin: EdgeInsets.all(10),
                                                        child: Image(image: ExactAssetImage('images/meetings.png')),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Align(
                                                      alignment: Alignment.topCenter,
                                                      child: Text('MY EVENT SCHEDULE',
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ),

                              // Announcements . . .
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => AnnouncementsDashboard(
                                        listAnnouncements: listOfAnnoucements)
                                    ),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Container(
                                          child: new Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 3,
                                                    child: Container(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Container(
                                                          margin: EdgeInsets.all(10),
                                                          child: Image(image: ExactAssetImage('images/announcements.png')),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Text('ANNOUNCEMENTS',
                                                            softWrap: true,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 8,
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  )

                                                ],
                                              ),

                                              Visibility(
                                                visible: annoucementCount != 0 ? true : false,
                                                child: new Align(
                                                  alignment: Alignment(0.7, -0.8),
                                                  child:  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.red,
                                                    ),
                                                    height: MediaQuery.of(context).size.height / 31 ,
                                                    width: MediaQuery.of(context).size.width / 18 ,
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(annoucementCount.toString(), style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )

                                    ),
                                  ),
                                ),
                              ),

                              // Exibitors . . .
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => ExibitorsDashboard()),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Hero(
                                          tag: "",
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 3,
                                                      child: Container(
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: Container(
                                                            margin: EdgeInsets.all(10),
                                                            child: Image(image: ExactAssetImage('images/exibitors.png')),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Align(
                                                          alignment: Alignment.topCenter,
                                                          child: Text('EXIBITORS',
                                                              softWrap: true,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 8,
                                                                  fontWeight: FontWeight.bold
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    /*Container(
                                                margin: EdgeInsets.all(6),
                                                padding: EdgeInsets.all(2),
                                                width: 60 ,
                                                height: 60,
                                                child: Image(image: ExactAssetImage('images/exibitors.png')),
                                              ),
                                              Text('EXIBITORS',
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold
                                                )
                                              )*/
                                                  ],
                                                ),
                                              ),

                                              // Below container is used to align the notification icon
                                              /* Container(
                                          color: Colors.pink,
                                          height: 40.0,
                                          width: 40.0,
                                        )*/

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Innovations
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => InnovationsDashboard()),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Image(image: ExactAssetImage('images/innovations.png')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text('INNOVATIONS',
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Bookmarks . . .
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => BookmarksDashboard()),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Image(image: ExactAssetImage('images/bookmarks.png')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text('BOOKMARKS',
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => SpeedSessionDashboard()),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Image(image: ExactAssetImage('images/icon_speed_session.png')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text('SPEED SESSIONS',
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Attendees . . .
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => AttendeesDashboard()),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Image(image: ExactAssetImage('images/attendees.png')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text('ATTENDEES',
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /*GestureDetector(
                                onTap: (){

                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Image(image: ExactAssetImage('images/icon_meeting_requests.png')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text('MEETING REQUESTS',
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),*/

                              GestureDetector(
                                onTap: () async {
                                  String barcode = "";
                                 scan();

                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Image(image: ExactAssetImage('images/icon_qr_code.png')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text('SCAN QR',
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Event Portals . . .
                              GestureDetector(
                                onTap: (){
                                  _launchURL();
                                },
                                child: GridTile(
                                  child: Card(
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Image(image: ExactAssetImage('images/event_portal.png')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Text('EVENT PORTAL',
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.all(6),
                                            padding: EdgeInsets.all(6),
                                            width: 60 ,
                                            height: 60,
                                            child: Image(image: ExactAssetImage('images/dsi_logo.png')),
                                          )
                                      ),

                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.all(4),
                                            padding: EdgeInsets.all(4),
                                            width: 60 ,
                                            height: 60,
                                            child: Image(image: ExactAssetImage('images/innovation_bridge_logo.png')),
                                          )
                                      ),

                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.all(8),
                                            padding: EdgeInsets.all(7),
                                            width: 60 ,
                                            height: 60,
                                            child: Image(image: ExactAssetImage('images/sfsa_logo.png')),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child:  Text('developed by',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w500
                                              ),),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 8,
                                            height: MediaQuery.of(context).size.height / 8,
                                            child: Image(image: ExactAssetImage('images/csir_logo.png')),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );

  }

  String barcode = "";
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        print('@@@@@@@@@@@ Bar code scanner === $barcode');

        if (barcode != null || barcode != ""){
          print('@@@@@@@ inside barcode if condition');

          Utils.check().then((internet){
            if (internet != null && internet){
              Map data = {
                'referencedUuid': barcode,
              };
              print('@@ final json request of add bookmark == '+data.toString());
              _addBookmarkAfterQRScan(data, context);
            }
            else{
              Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION, toastLength: Toast.LENGTH_LONG);
            }
          });

        }
        else{
          print('@@@@@@@ inside barcode else condition');
        }
      });

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

_launchURL() async {
  const url = 'https://www.innovationbridge.info/ibportal/?q=innovation-bridge-event/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<BookmarkResponse> _addBookmarkAfterQRScan(Map data, BuildContext context) async {

  showDialog(
      context: context,
      builder: (BuildContext aaaaa) {
        return Center(child: CircularProgressIndicator());
      });

  var body = json.encode(data);

  SharedPreferences pref = await SharedPreferences.getInstance();
  var response = await http.post(Uri.encodeFull(ServiceConstants.BOOKMARK_ADD),
      headers: {"Content-Type": "application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
      body: body
  );

  print("@@ response of login status code == ${response.statusCode}");
  print("@@ response of login json data == ${response.body}");

  Navigator.pop(context);
  if (response.statusCode == 200){
    print('@@ inside success 200');

    var parsedJson = json.decode(response.body);
    BookmarkResponse login = BookmarkResponse.fromJson(parsedJson);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: login.message.status,
          errorMessage: login.message.message),
    );
    return login;
  }
  else if (response.statusCode == 401){
    // Fluttertoast.showToast(msg: Constants.SESSION_EXPIRED_LOGIN_AGAIN, toastLength: Toast.LENGTH_LONG);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogOnClickAction(dialogTitle: Constants.TITLE_ALERT,
          errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
    );
  }
  else if (response.statusCode == 404){
    var parsedJson = json.decode(response.body);
    BookmarkResponse login = BookmarkResponse.fromJson(parsedJson);
    var error = login.message;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: error.status,
          errorMessage: error.message),
    );
  }
  else {
    // Internal server error
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: Constants.TITLE_ALERT,
          errorMessage: Constants.INTERNAL_SERVER_ERROR),
    );
  }

}

class PrivacyPolicyScreen extends StatefulWidget {
  PrivacyPolicyScreen({Key key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  List<Car> initialList = Car.cars;
  List<Car> currentList = [];
  String enteredText = '';

  @override
  initState() {
    super.initState();
    filterCars();
  }

  @override
  Widget build(BuildContext context) {
    filterCars();
    return Container(
        child: ListView.builder(
            itemCount: currentList.length,
            itemBuilder: (BuildContext context, int index) {
              Car current = currentList.elementAt(index);
              return Card(
                elevation: 4,
                child: ListTile(
                  title: Text(current.name),
                  subtitle: Text(current.brand),
                  trailing: Text(current.price.toString() + " \$"),
                  leading: Text(current.year),
                ),
              );
            }));
  }

  methodUpdateFilter(String text) {
    /*setState(() {
      enteredText = text;
      Fluttertoast.showToast(msg: enteredText);
    });*/
  }

  filterCars() {
    // Prepare lists
    List<Car> tmp = [];
    currentList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty) {
      tmp.addAll(initialList);
    } else {
      for (Car c in initialList) {
        if (c.name.toLowerCase().startsWith(name.toLowerCase())) {
          tmp.add(c);
        }
      }
    }
    currentList = tmp;
  }
}

class Car {
  final String name;
  final String brand;
  final String type;
  final int maxSpeed;
  final int horsePower;
  final String year;
  final bool selfDriving;
  final double price;

  Car({
    this.name,
    this.brand,
    this.type,
    this.maxSpeed,
    this.horsePower,
    this.year,
    this.selfDriving,
    this.price,
  });

  static final cars = [
    new Car(
        name: "Jazz",
        brand: "Honda",
        type: "gas",
        maxSpeed: 200,
        horsePower: 83,
        year: "2001",
        selfDriving: false,
        price: 2000.00),
    new Car(
        name: "Citigo",
        brand: "Skoda",
        type: "gas",
        maxSpeed: 200,
        horsePower: 75,
        year: "2011",
        selfDriving: false,
        price: 10840.00),
    new Car(
        name: "Octavia Combi",
        brand: "Skoda",
        type: "diesel",
        maxSpeed: 240,
        horsePower: 149,
        year: "2016",
        selfDriving: false,
        price: 32650.00),
    new Car(
        name: "Rapid",
        brand: "Skoda",
        type: "diesel",
        maxSpeed: 240,
        horsePower: 95,
        year: "2012",
        selfDriving: false,
        price: 20190.00),
    new Car(
        name: "Q2",
        brand: "Audi",
        type: "gas",
        maxSpeed: 280,
        horsePower: 140,
        year: "2018",
        selfDriving: false,
        price: 28000.00),
    new Car(
        name: "Model 3",
        brand: "Tesla",
        type: "electric",
        maxSpeed: 280,
        horsePower: 140,
        year: "2018",
        selfDriving: true,
        price: 35000),
  ];
}
