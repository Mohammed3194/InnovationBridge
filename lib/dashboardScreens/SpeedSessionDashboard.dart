import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/AnnouncementsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/AttendeesDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/BookmarksDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ExibitorsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/InnovationsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ProgramDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/detailScreens/SpeedSessionDetails.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/BookmarkResponse.dart';
import 'package:innovation_bridge/fragments/ProgramScreen.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:innovation_bridge/entities/SpeedSessions.dart';

import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SpeedSessionDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _SpeedSessionDashboardState createState() => _SpeedSessionDashboardState();
}

class _SpeedSessionDashboardState extends State<SpeedSessionDashboard> {

  int _selectedDrawerIndex = 5;
  final GlobalKey<_SpeedSessionScreenState> _key = GlobalKey();
  final controller = new TextEditingController();

  List<Data> listOfSpeedSessions = [];

  Future<List<Data>> _getAllSpeedSessions() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(Uri.encodeFull(ServiceConstants.GET_ALL_SPEED_SESSIONS),
      headers: {"Content-Type":"application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
    );

    print("@@ response inside initState status code == ${response.statusCode}");
    print("@@ response  inside initState  json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of form template json data == $parsedJson");

    if (response.statusCode == 200){
      SpeedSessions myClass = SpeedSessions.fromJson(jsonDecode(response.body));
      print('@@ inside 200 $myClass');

      setState(() {
        listOfSpeedSessions = myClass.data;
        return listOfSpeedSessions;
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
        _getAllSpeedSessions();
      }
      else{
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

  Widget appBarTitle = new Text("Speed Sessions");
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
            onTap: () {
              Navigator.of(context).pop();
              if (widget.drawerItems[i].title == 'Dashboard') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeDashboard()),
                      (Route<dynamic> route) => false,
                );
              }
              /*if (widget.drawerItems[i].title == 'Speed Session') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SpeedSessionDashboard()),
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
                  this.appBarTitle = new Text("Speed Sessions");
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
                 /* Container(
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
      body: listOfSpeedSessions.length > 0 ? SpeedSessionScreen(key: _key, listOfSpeedSession: listOfSpeedSessions)
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


class SpeedSessionScreen extends StatefulWidget {

  List<Data> listOfSpeedSession;
  SpeedSessionScreen({Key key, List<Data> this.listOfSpeedSession}) : super(key: key);


  @override
  _SpeedSessionScreenState createState() => _SpeedSessionScreenState(listOfSpeedSession);
}

class _SpeedSessionScreenState extends State<SpeedSessionScreen> {

  CalendarController _calendarController;

  String enteredText = '';
  String monthYear = '';
  String filteredDate;

  List<Data> initialSpeedSessionList;
  List<Data> currentSpeedSessionList = [];

  _SpeedSessionScreenState(this.initialSpeedSessionList);

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    getEventStartEndDate();
    filterSpeedSessions();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => yourFunction(context));
  }

  String eventStartDate = "";
  String eventEndDate = "";

  getEventStartEndDate() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    this.eventStartDate = pref.getString(Constants.EVENT_START_DATE);
    this.eventEndDate = pref.getString(Constants.EVENT_END_DATE);

    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime startDateTime = dateFormat.parse(eventStartDate);
    _calendarController.setSelectedDay(startDateTime);
    _calendarController.setFocusedDay(startDateTime);

    setState(() {
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == '+formatedDate);
      monthYear = formatedDate;

      filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  filterSpeedSessions(){
    // Prepare lists
    List<Data> tmp = [];
    currentSpeedSessionList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty ) {
      for(Data speed in initialSpeedSessionList){
        if (filteredDate == speed.date){
          tmp.add(speed);
        }
      }
      // tmp.addAll(initialSpeedSessionList);
    } else {
      for (Data c in initialSpeedSessionList) {
        if (c.comment != null) {
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
        /*if (c.title.toLowerCase().contains(name.toLowerCase())) {
          tmp.add(c);
        }*/
      }
    }
    setState(() {
      currentSpeedSessionList = tmp;
    });
  }

  yourFunction(BuildContext context) {
    print('@@ calendar focused day == ${_calendarController.focusedDay}');
    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ssz");
      DateTime startDateTime = dateFormat.parse(_calendarController.focusedDay.toString());
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == '+formatedDate);
      monthYear = formatedDate;

      filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // 2019-10-17 00:00:00.000
    });
  }

  String text = 'Text';

  @override
  Widget build(BuildContext context) {
    filterSpeedSessions();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey[400],
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 28,
              child: Align(
                alignment: Alignment.center,
                child: Text(monthYear, style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
            Container(
              color: Colors.grey[350],
              child: _buildTableCalendar(),
            ),
            Expanded(
                child: currentSpeedSessionList.length == 0 ? Center(child: Text("No sessions found for selected date")) :
                ListView.builder(
                  itemCount: currentSpeedSessionList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index){

                    Data speedSession = currentSpeedSessionList.elementAt(index);

                    return Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 4),
                      child: Container(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                _awaitReturnValueFromSpeedSessionDetailScreen(context, speedSession);
                              },
                              child: Text(speedSession.title, style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              )),
                            ),
                            Padding(padding: EdgeInsets.only(top: 6)),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(speedSession.location != null ? speedSession.location : '', style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent,
                                  )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(speedSession.startTime + ' - ' + speedSession.endTime, style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueAccent,
                                      ))
                                  ),
                                )
                              ],
                            ),

                            Padding(padding: EdgeInsets.only(top: 5)),

                            Row(
                              children: <Widget>[
                                Visibility(
                                  visible: speedSession.availability == 'full' ? true : false,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration:BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(width: 1.2,
                                          color: Colors.red
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0) //                 <--- border radius here
                                      ),
                                    ), //             <--- BoxDecoration here
                                    child: Text('FULL', style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),),
                                  ),
                                ),

                                Visibility(
                                  visible: speedSession.attending ? false : true,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration:BoxDecoration(
                                      color: Colors.orange,
                                      border: Border.all(width: 1.2,
                                          color: Colors.orange
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0) //                 <--- border radius here
                                      ),
                                    ), //             <--- BoxDecoration here
                                    child: Text(speedSession.availability.toUpperCase()+' (${speedSession.seatAvailability})',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
                                      ),),
                                  ),
                                ),

                                Visibility(
                                  visible: speedSession.attending ? true : false,
                                  child:Container(
                                    padding: EdgeInsets.all(5),
                                    decoration:BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(width: 1.2,
                                          color: Colors.green
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0) //                 <--- border radius here
                                      ),
                                    ), //             <--- BoxDecoration here
                                    child: Text('ATTENDING', style: TextStyle(
                                        fontSize: 10.5,
                                        color: Colors.white,
                                    ),),
                                  ),
                                )
                              ],
                            ),

                            Padding(padding: EdgeInsets.only(top: 6)),
                            Text(speedSession.comment != null ? speedSession.comment : "",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )
                            ),

                            Padding(padding: EdgeInsets.only(top: 12)),

                            Row(
                              children: <Widget>[
                                Visibility(
                                  visible: speedSession.attending ? false : true,
                                  child: GestureDetector(
                                    onTap: (){
                                      Utils.check().then((internet){
                                        if (internet != null && internet){

                                          Map data = {
                                            'attendanceStatus' : Constants.ATTENDING_STATUS_CONFIRM
                                          };

                                          print("@@@ ${ServiceConstants.MEETING_ATTEND_DECLINE + speedSession.id.toString() + "/attend"}");

                                          _acceptDeclineSpeedSession(data, context, speedSession.id);
                                        }
                                        else {
                                          Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 5,
                                      height: MediaQuery.of(context).size.height / 22,
                                      child: Container(
                                        color: Colors.grey[400],
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Image(image: ExactAssetImage('images/icon_accept.png')),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft ,
                                                    child: Text('RSVP',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black
                                                      ),),
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: speedSession.attending ? true : false,
                                  child: GestureDetector(
                                    onTap: (){
                                      Utils.check().then((internet){
                                        if (internet != null && internet){

                                          Map data = {
                                            'attendanceStatus' : Constants.ATTENDING_STATUS_DECLINE
                                          };
                                          _acceptDeclineSpeedSession(data, context, speedSession.id);
                                        }
                                        else {
                                          Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      height: MediaQuery.of(context).size.height / 22,
                                      child: Container(
                                        color: Colors.grey[400],
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Image(image: ExactAssetImage('images/icon_decline.png')),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft ,
                                                    child: Text('DECLINE',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black
                                                      ),),
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            ),

                            Padding(padding: EdgeInsets.only(bottom: 8)),

                            Divider(
                              color: Colors.black,
                            )

                          ],
                        ),
                      ),
                    );
                  },
                )
            )
          ],
        ),
      ),
    );
  }

  void _awaitReturnValueFromSpeedSessionDetailScreen(BuildContext context, Data speedSession) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SpeedSessionDetials(detail: speedSession)
    );

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      text = result;
      print('@@ result message from bookmark screen == ' + text);
      if (text == 'Success'){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SpeedSessionDashboard()),
              (Route<dynamic> route) => false,
        );
        // Fluttertoast.showToast(msg: error.message, toastLength: Toast.LENGTH_LONG);
      }
    });
  }

  Future<BookmarkResponse> _acceptDeclineSpeedSession(Map data, BuildContext context, int id) async {
    showDialog(
        context: context,
        builder: (BuildContext aaaaa) {
          return Center(child: CircularProgressIndicator());
        });

    var body = json.encode(data);

    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.encodeFull(ServiceConstants.MEETING_ATTEND_DECLINE + id.toString() + "/attend" ),
        headers: {"Content-Type": "application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
        body: body
    );

    if (response.statusCode == 200){
      var parsedJson = json.decode(response.body);
      BookmarkResponse login = BookmarkResponse.fromJson(parsedJson);
      var error = login.message;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SpeedSessionDashboard()),
            (Route<dynamic> route) => false,
      );
      Fluttertoast.showToast(msg: error.message, toastLength: Toast.LENGTH_LONG);
    }
    else if (response.statusCode == 401){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogOnClickAction(dialogTitle: Constants.TITLE_ALERT,
            errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
      );
    }
    else{
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

  Widget _buildTableCalendar() {

    print('@@@ inside buildcalendar strt date == $eventStartDate');
    print('@@@ inside buildcalendar end date == $eventEndDate');

    DateTime startDateTime;
    DateTime endDateTime;


    if (eventStartDate == "" && eventEndDate == ""){
      print(("@@@@@ inside emtpy data time == "));
    }
    else{
      print(("@@@@@ inside not empty data time == "));

      DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      startDateTime = dateFormat.parse(eventStartDate);
      endDateTime = dateFormat.parse(eventEndDate);

      endDateTime = new DateTime(endDateTime.year, endDateTime.month, endDateTime.day + 1);

      print('@@@ inside not empty start $startDateTime and end $endDateTime');

      DateTime now = DateTime.now();
      print('@@@ today date === $now');
    }

    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      initialCalendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week',
      },
      startDay: startDateTime == null ? null : startDateTime,
      endDay: endDateTime == null ? null : endDateTime,
      calendarStyle: CalendarStyle(
          selectedColor: Colors.deepOrange[400],
          todayColor: Colors.deepOrange[200],
          markersColor: Colors.brown[700],
          outsideDaysVisible: true),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
        TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      availableGestures: AvailableGestures.all,
      formatAnimation: FormatAnimation.slide,
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  void _onDaySelected(DateTime day, List events) {
    print('@@ CALLBACK: _onDaySelected' +day.toIso8601String());
    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ssz");
      DateTime startDateTime = dateFormat.parse(_calendarController.focusedDay.toString());
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == '+formatedDate);
      monthYear = formatedDate;

      filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // 2019-10-18T12:00:00.000Z
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ssz");
      DateTime startDateTime = dateFormat.parse(_calendarController.focusedDay.toString());
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == '+formatedDate);
      monthYear = formatedDate;

      // filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // 2019-10-18T12:00:00.000Z
    });
  }
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
