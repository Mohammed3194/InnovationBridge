import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/dashboardScreens/MyEventScheduleDashboard.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/BookmarkResponse.dart';
import 'package:innovation_bridge/entities/MyEventSchedule.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;

class DeclineEventSchedule extends StatefulWidget {

  Data eventDetials;
  DeclineEventSchedule({@required this.eventDetials});

  @override
  _DeclineEventScheduleState createState() => _DeclineEventScheduleState(eventDetials);
}

class _DeclineEventScheduleState extends State<DeclineEventSchedule> {

  Data eventDetials;
  _DeclineEventScheduleState(this.eventDetials);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decline Speed Session'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 6, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
                // Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width /19,
                      height: MediaQuery.of(context).size.height /19,
                      child: Image(image: ExactAssetImage('images/icon_speed_date.png')),
                    ),
                    Padding(padding: EdgeInsets.only(left: 6)),
                    Text(eventDetials.title, style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    )),
                  ],
                ),
                Text(eventDetials.date + "(${eventDetials.startTime + " - " + eventDetials.endTime})", style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                )),

                Padding(padding: EdgeInsets.only(top: 2)),
                Text(eventDetials.location != null ? eventDetials.location : "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                        color: Colors.black
                    )
                ),

                Padding(padding: EdgeInsets.only(top: 6)),
                Text(eventDetials.comment != null ? eventDetials.comment : "",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    )
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Do you really want to Decline this Speed Networking Session?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          )
                      ),
                    ),
                  ),
                ),


                Padding(padding: EdgeInsets.only(top: 15)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      child: new RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                          textColor: Colors.black,
                          color: Colors.grey,
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(
                      height: 40,
                      child: new RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text('Decline'),
                          onPressed: () {
                            Utils.check().then((internet){
                              if (internet != null && internet){

                                Map data = {
                                  'attendanceStatus' : Constants.ATTENDING_STATUS_DECLINE
                                };
                                _acceptDeclineSpeedSession(data, context, eventDetials.id);
                              }
                              else {
                                Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                              }
                            });
                          }),
                    )

                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
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
      MaterialPageRoute(builder: (context) => MyEventScheduleDashboard()),
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

