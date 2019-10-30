import 'dart:core';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/AddBookmarkScreen.dart';
import 'package:innovation_bridge/EditDeleteBookmarkScreen.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/detailScreens/ProgramDetailScreen.dart';
import 'package:innovation_bridge/detailScreens/ProgramSessionScreen.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/ProgramID.dart' as programID;
import 'package:innovation_bridge/entities/Programs.dart' as programList;
import 'package:innovation_bridge/entities/BookmarkDetails.dart' as bookDetails;
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProgramDashboard extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Dashboard",
        Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy",
        Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions",
        Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout",
        Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _ProgramDashboardState createState() => _ProgramDashboardState();
}

class _ProgramDashboardState extends State<ProgramDashboard> {
  List<programList.Data> listOfPrograms = [];

  final GlobalKey<_ProgramScreenState> _key = GlobalKey();
  final controller = new TextEditingController();

  int _selectedDrawerIndex = 7;

  Future<List<programList.Data>> _fetchUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.encodeFull(ServiceConstants.GET_ALL_PROGRAMS),
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
      programList.Programs myClass =
          programList.Programs.fromJson(jsonDecode(response.body));
      print('@@ inside 200 $myClass');

      List<programList.Data> listProg = myClass.data;
      if (listProg != null && listProg.length > 0) {
        setState(() {
          listOfPrograms = listProg;
        });
      }
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
      Fluttertoast.showToast(
          msg: Constants.INTERNAL_SERVER_ERROR, toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  initState() {
    super.initState();
    controller.addListener(onChange);
    Utils.check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        _fetchUsers();
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

  List<String> _auditTemplateList = ['A', 'B', 'C', 'D'];
  String _selectedAuditTemplate;

  bool isSearch = false;
  bool isFilter = false;

  Widget appBarTitle = new Text("Program");
  Icon actionIcon = new Icon(Icons.search);
  Icon actionFilter = new Icon(Icons.filter_list);

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
          /*if (widget.drawerItems[i].title == 'Program') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ProgramDashboard()),
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
      appBar: new AppBar(title: appBarTitle, actions: <Widget>[
        Visibility(
          visible: isFilter ? false : true,
          child: Container(
            width: 40.0,
            child: new IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.isSearch = true;
                      this.actionIcon = new Icon(Icons.close);
                      this.appBarTitle = new TextField(
                        autofocus: true,
                        controller: controller,
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        decoration: new InputDecoration(
                            hintText: "Search...",
                            hintStyle: new TextStyle(color: Colors.white)),
                      );
                    } else {
                      setState(() {
                        controller.clear();
                      });
                      this.isSearch = false;
                      this.actionIcon = new Icon(Icons.search);
                      this.appBarTitle = new Text("Program");
                    }
                  });
                }),
          ),
        ),

        /*Visibility(
              visible: isSearch ? false : true,
              child: Container(
                width: 35.0,
                child: Align(
                  alignment: Alignment.center,
                  child: new IconButton(icon: actionFilter, onPressed: (){
                    setState(() {
                      if (this.actionFilter.icon == Icons.filter_list){
                        this.isFilter = true;
                        this.actionFilter = new Icon(Icons.close);
                        this.appBarTitle = new Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: new Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 0.8),
                                  ),
                                  height: 45.0,
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        items: _auditTemplateList.map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: new Text(val),
                                          );
                                        }).toList(),
                                        hint: new Text("Please select", style: TextStyle(
                                            fontSize: 12.0
                                        ),),
                                        onChanged: (String val) {
                                          setState(() {
                                            _selectedAuditTemplate = val;
                                          });
                                        },
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: DropdownButton<String>(
                                hint: new Text("Please select", style: TextStyle(fontSize: 12.0)),
                                value: _selectedAuditTemplate,
                                onChanged: (String val) {
                                  setState(() {
                                    _selectedAuditTemplate = val;
                                  });
                                },
                                items: _auditTemplateList.map((String val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                              )
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Icon(Icons.search)
                          ],
                        );
                      }
                      else{
                        this.isFilter = false;
                        this.actionFilter = new Icon(Icons.filter_list);
                        this.appBarTitle = new Text("Program");
                      }
                    });
                  }),
                ),
              ),
            )*/
      ]),
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
        )),
      ),
      body: listOfPrograms.length > 0
          ? ProgramScreen(key: _key, listOfPrograms: listOfPrograms)
          : Center(
          child:
          Text('No programs/events found')),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}

class ProgramScreen extends StatefulWidget {
  List<programList.Data> listOfPrograms;
  ProgramScreen({Key key, List<programList.Data> this.listOfPrograms})
      : super(key: key);

  @override
  _ProgramScreenState createState() => _ProgramScreenState(listOfPrograms);
}

class _ProgramScreenState extends State<ProgramScreen>
    with TickerProviderStateMixin {
  String enteredText = '';

  List<programList.Data> initialProgramList;
  List<programList.Data> currentProgramList = [];

  _ProgramScreenState(this.initialProgramList);

  CalendarController _calendarController;

  String monthYear = '';
  String filteredDate;

  bool visibilityTag = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    WidgetsBinding.instance.addPostFrameCallback((_) => yourFunction(context));
    filterEventPrograms();

    getEventStartEndDate();
  }

  yourFunction(BuildContext context) {
    print('@@ calendar focused day == ${_calendarController.focusedDay}');
    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ssz");
      DateTime startDateTime =
          dateFormat.parse(_calendarController.focusedDay.toString());
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == ' + formatedDate);
      monthYear = formatedDate;

      filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // 2019-10-17 00:00:00.000
    });
  }

  String eventStartDate = "";
  String eventEndDate = "";

  getEventStartEndDate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    this.eventStartDate = pref.getString(Constants.EVENT_START_DATE);
    this.eventEndDate = pref.getString(Constants.EVENT_END_DATE);

    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime startDateTime = dateFormat.parse(eventStartDate);
    _calendarController.setSelectedDay(startDateTime);
    _calendarController.setFocusedDay(startDateTime);

    setState(() {
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == ' + formatedDate);
      monthYear = formatedDate;

      filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('@@ CALLBACK: _onDaySelected' + day.toIso8601String());
    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ssz");
      DateTime startDateTime =
          dateFormat.parse(_calendarController.focusedDay.toString());
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == ' + formatedDate);
      monthYear = formatedDate;

      filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // 2019-10-18T12:00:00.000Z
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');

    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ssz");
      DateTime startDateTime =
          dateFormat.parse(_calendarController.focusedDay.toString());
      String formatedDate = DateFormat('MMM yyyy').format(startDateTime);
      print('@@ formatted date == ' + formatedDate);
      monthYear = formatedDate;

      // filteredDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // 2019-10-18T12:00:00.000Z
    });
  }

  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  Widget build(BuildContext context) {
    filterEventPrograms();
    return GestureDetector(
      onTap: () {
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
                child: Text(
                  monthYear,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              color: Colors.grey[350],
              child: _buildTableCalendar(),
            ),
            Expanded(
                child: currentProgramList.length == 0
                    ? Center(
                        child:
                            Text('No programs/events found for selected date'))
                    : ListView.builder(
                        itemCount: currentProgramList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          programList.Data program =
                              currentProgramList.elementAt(index);

                          String location = '';
                          if (program.location.length > 0) {
                            for (int i = 0; i < program.location.length; i++) {
                              location = location + " " + program.location[i];
                            }
                          } else {
                            location = "";
                          }

                          if (program.details != null) {
                            print(
                                ' @@@ program details length ${program.details.length}');
                            if (program.details.length > 300) {
                              firstHalf = program.details.substring(0, 280);
                              secondHalf = program.details
                                  .substring(280, program.details.length);
                            } else {
                              firstHalf = program.details;
                              secondHalf = "";
                            }
                          }

                          // print('@@ program data == ' + program.title);
                          return Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 4),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      Utils.check().then((internet) async {
                                        if (internet != null && internet) {
                                          // Internet Present Case
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              });

                                          programID.ProgramID detail =
                                              await _getProgramDetailsById(
                                                  program.id);
                                          if (detail != null) {
                                            if (detail.message != null) {
                                              // Got detail of program
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) =>
                                                    CommonMessageDialog(
                                                        dialogTitle: 'Alert',
                                                        errorMessage: detail
                                                            .message.message),
                                              );
                                            } else {
                                              // Message object is not null
                                              // we got error message from response
                                              // have to show to user
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProgramDetailScreen(
                                                              detail: detail)));
                                            }
                                          } else {
                                            // If detail is show internal server error message
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => CommonMessageDialog(
                                                  dialogTitle: 'Alert',
                                                  errorMessage:
                                                      'Internal server error, please try later'),
                                            );
                                          }
                                        } else {
                                          print('No internet == ');
                                          Utils.showCommonMessageDialog(
                                              context,
                                              Constants.TITLE_ALERT,
                                              Constants
                                                  .CHECK_NETWORK_CONNECTION);
                                        }
                                      });
                                    },
                                    // Title
                                    child: Text(program.title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 6)),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        // Locatiton Name
                                        child: Text(location,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueAccent,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            // Start time - End time
                                            child: Text(
                                                program.startTime +
                                                    ' - ' +
                                                    program.endTime,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blueAccent,
                                                ))),
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 6)),
                                  // Description

                                  program.details != null
                                      ? secondHalf.isEmpty
                                          ? new Text(firstHalf,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ))
                                          : new Column(
                                              children: <Widget>[
                                                new Text(
                                                    flag
                                                        ? (firstHalf + "...")
                                                        : (firstHalf +
                                                            secondHalf),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                                new InkWell(
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      new Text(
                                                        flag
                                                            ? "more[..]"
                                                            : "  less  ",
                                                        style: new TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    // On navigate . . . .
                                                    Utils.check()
                                                        .then((internet) async {
                                                      if (internet != null &&
                                                          internet) {
                                                        // Internet Present Case
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            });

                                                        programID.ProgramID
                                                            detail =
                                                            await _getProgramDetailsById(
                                                                program.id);
                                                        if (detail != null) {
                                                          if (detail.message !=
                                                              null) {
                                                            // Got detail of program
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder: (_) => CommonMessageDialog(
                                                                  dialogTitle:
                                                                      'Alert',
                                                                  errorMessage: detail
                                                                      .message
                                                                      .message),
                                                            );
                                                          } else {
                                                            // Message object is not null
                                                            // we got error message from response
                                                            // have to show to user
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ProgramDetailScreen(
                                                                            detail:
                                                                                detail)));
                                                          }
                                                        } else {
                                                          // If detail is show internal server error message
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (_) =>
                                                                CommonMessageDialog(
                                                                    dialogTitle:
                                                                        'Alert',
                                                                    errorMessage:
                                                                        'Internal server error, please try later'),
                                                          );
                                                        }
                                                      } else {
                                                        print(
                                                            'No internet == ');
                                                        Utils.showCommonMessageDialog(
                                                            context,
                                                            Constants
                                                                .TITLE_ALERT,
                                                            Constants
                                                                .CHECK_NETWORK_CONNECTION);
                                                      }
                                                    });
                                                    /*setState(() {
                                  flag = !flag;
                                });*/
                                                  },
                                                ),
                                              ],
                                            )
                                      : Text(""),

                                  /*program.details != null ?
                        (program.details.length > 300 ?
                            Column(
                              children: <Widget>[
                                Text(
                                  program.details.substring(0, 280),
                                  maxLines: null,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text("show more")
                                    ],
                                  ),
                                )
                              ],
                            ):
                        Text(
                          program.details,
                          maxLines: null,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                        ) : Text(""),*/

                                  /*Text(
                          program.details != null ? program.details : "",
                          maxLines: null,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),*/
                                  /*InkWell(
                          onTap: (){
                            _index = index;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              // descTextShowFlag ? Text("Show Less",style: TextStyle(color: Colors.blue)) :
                              Text("Show More",style: TextStyle(
                                  color: Colors.blue,
                                fontSize: 10
                              ))
                            ],
                          ),
                        ),*/

                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            if (program.bookmarked) {

                                              Utils.check().then((internet){
                                                if (internet != null && internet){
                                                  _getBookmarkDetailsById(program.bookmarkId);
                                                }
                                                else {
                                                  Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                                                }
                                              });
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddBookmarkScreen(
                                                          referencedId:
                                                              program.id,
                                                          nameTitle:
                                                              program.title,
                                                          type: Constants
                                                              .TYPE_PROGRAM,
                                                          uuid: program.uuid,
                                                        )),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                14,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                14,
                                            child: program.bookmarked
                                                ? Image(
                                                    image: ExactAssetImage(
                                                        'images/bookmark_remove.png'))
                                                : Image(
                                                    image: ExactAssetImage(
                                                        'images/bookmark_add.png')),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(right: 8)),
                                        Visibility(
                                          visible: program.parallelActivities
                                                      .length >
                                                  0
                                              ? true
                                              : false,
                                          child: GestureDetector(
                                              onTap: () {
                                                print(
                                                    '@@ on click of drop down icon == ' +
                                                        index.toString());
                                                List<
                                                        programList
                                                            .ParallelActivities>
                                                    listActivities =
                                                    program.parallelActivities;

                                                // programList.ParallelActivities prog = program.parallelActivities[index+1];
                                                // createGridItems(program.parallelActivities))
                                                print('@@ on click of drop down icon == ' +
                                                    index.toString() +
                                                    ' and size/length == ${listActivities.length}');

                                                if (listActivities.length > 0) {
                                                  setState(() {
                                                    _index = index;

                                                    if (visibilityTag) {
                                                      visibilityTag = false;
                                                    } else {
                                                      visibilityTag = true;
                                                    }
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    14,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    14,
                                                child: index == _index
                                                    ? (visibilityTag
                                                        ? Image(
                                                            image: ExactAssetImage(
                                                                'images/icon_parallelsessions_close.png'))
                                                        : Image(
                                                            image: ExactAssetImage(
                                                                'images/icon_parallelsessions_open.png')))
                                                    : Image(
                                                        image: ExactAssetImage(
                                                            'images/icon_parallelsessions_open.png')),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                    visible: index == _index
                                        ? (visibilityTag ? true : false)
                                        : false,
                                    child: GridView.count(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 5,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4),
                                        children: createGridItems(
                                            program.parallelActivities)),
                                  ),

                                  /* ExpansionTile(
                          title: Text(''),
                          trailing: Container(
                            height: MediaQuery.of(context).size.height / 14,
                            width: MediaQuery.of(context).size.width / 14,
                            child: Image(
                                image: ExactAssetImage(
                                    'images/icon_parallelsessions_open.png')),
                          ),
                          children: <Widget>[
                            GridView.count(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                crossAxisCount: 3,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 4),
                                children:
                                    createGridItems(program.parallelActivities))
                          ],
                          // onExpansionChanged: (bool expanding) => setState(() => this.isExpanded = expanding),
                        ),*/

                                  Divider(
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }

  methodUpdateFilter(String text) {
    setState(() {
      enteredText = text;
    });
  }

  filterEventPrograms() {
    // Prepare lists
    List<programList.Data> tmp = [];
    currentProgramList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty) {
      for (programList.Data prog in initialProgramList) {
        if (filteredDate == prog.date) {
          tmp.add(prog);
        }
      }
      // tmp.addAll(initialProgramList);
    } else {
      for (programList.Data c in initialProgramList) {
        if ((c.title != null) && (c.details != null) && (c.location != null)) {
          if (c.title.toLowerCase().contains(name.toLowerCase()) ||
              c.details.toLowerCase().contains(name.toLowerCase()) ||
              c.location.contains(name)) {
            tmp.add(c);
          }
        }
        else if ((c.details != null) && (c.location.length > 0)) {
          if (c.title.toLowerCase().contains(name.toLowerCase()) ||
              c.details.toLowerCase().contains(name.toLowerCase()) ||
              c.location.contains(name)) {
            tmp.add(c);
          }
          else if (c.details != null){
            if (c.title.toLowerCase().contains(name.toLowerCase()) ||
                c.details.toLowerCase().contains(name.toLowerCase())) {
              tmp.add(c);
            }
          }
          else if (c.location.length > 0){
            if (c.title.toLowerCase().contains(name.toLowerCase()) ||
                c.location.contains(name)) {
              tmp.add(c);
            }
          }
        }
        else {
          if (c.title.toLowerCase().contains(name.toLowerCase())){
            tmp.add(c);
          }
        }
      }
    }
    setState(() {
      currentProgramList = tmp;
    });
  }

  Future<programID.ProgramID> _getProgramDetailsById(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.encodeFull(ServiceConstants.GET_PROGRAMS_BY_ID + id.toString()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": pref.getString(Constants.AUTH_TOKEN)
      },
    );

    print("@@ response of program id status code == ${response.statusCode}");
    print("@@ response of program id json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of program id json data == $parsedJson");

    if (response.statusCode == 200) {
      programID.ProgramID detail =
          programID.ProgramID.fromJson(jsonDecode(response.body));
      return detail;
    } else if (response.statusCode == 404) {
      programID.ProgramID detail =
          programID.ProgramID.fromJson(jsonDecode(response.body));
      return detail;
    }  else if (response.statusCode == 401){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogOnClickAction(dialogTitle: Constants.TITLE_ALERT,
            errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
      );
    }else {
      return null;
    }
  }

  List<Widget> createGridItems(
      List<programList.ParallelActivities> parallelActivities) {
    List<Widget> listGridTiles = new List<Widget>();

    for (var pActivity in parallelActivities) {
      listGridTiles.add(GestureDetector(
        onTap: () {
          programID.ParallelActivities pAct = new programID.ParallelActivities(
              id: pActivity.id,
              uuid: pActivity.uuid,
              title: pActivity.title,
              date: pActivity.date,
              startTime: pActivity.startTime,
              endTime: pActivity.endTime,
              details: pActivity.details,
              location: pActivity.location,
              bookmarked: pActivity.bookmarked,
            bookmarkId: pActivity.bookmarkId
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProgramSessionScreen(detail: pAct)));
        },
        child: Container(
          decoration: BoxDecoration(
            color: pActivity.bookmarked ? Colors.green : Colors.grey,
            border: Border.all(
                width: 0.9,
                color: pActivity.bookmarked ? Colors.green : Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //                 <--- border radius here
                ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(6, 5, 0, 0),
                // Session Title
                child: Text(pActivity.title,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(6, 1, 0, 0),
                // time
                child: Text(pActivity.startTime + ' - ' + pActivity.endTime,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 9)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(6, 1, 0, 0),
                child: Text(pActivity.location,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 9)),
              ),
            ],
          ),
        ),
      ));
    }

    return listGridTiles;
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

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    print('@@@ inside buildcalendar strt date == $eventStartDate');
    print('@@@ inside buildcalendar end date == $eventEndDate');

    DateTime startDateTime;
    DateTime endDateTime;

    if (eventStartDate == "" && eventEndDate == "") {
      print(("@@@@@ inside emtpy data time == "));
    } else {
      print(("@@@@@ inside not empty data time == "));

      DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      startDateTime = dateFormat.parse(eventStartDate);
      endDateTime = dateFormat.parse(eventEndDate);

      endDateTime = new DateTime(
          endDateTime.year, endDateTime.month, endDateTime.day + 1);

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
      initialSelectedDay: startDateTime == null ? null : startDateTime,
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
}

Widget createGridView(BuildContext context, List<String> cosmicBodies) {
  //I will shuffle my data
  cosmicBodies.shuffle();

  // Then build my GridView and return it
  return new GridView.builder(
      itemCount: cosmicBodies.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 15.0),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 5.0,
            child: new Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
              child: new Text(cosmicBodies[index]),
            ),
          ),
        );
      });
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
