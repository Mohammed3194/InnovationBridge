import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/BookmarkResponse.dart';
import 'package:innovation_bridge/entities/SpeedSessions.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class SpeedSessionDetials extends StatefulWidget {

  Data detail;
  SpeedSessionDetials({@required this.detail});

  @override
  _SpeedSessionDetialsState createState() => _SpeedSessionDetialsState(detail);
}

class _SpeedSessionDetialsState extends State<SpeedSessionDetials> {

  Data detail;
  _SpeedSessionDetialsState(this.detail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speed Networking Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Container(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    /*Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SpeedSessionDetials()
                    ));*/
                  },
                  child: Text(detail.title, style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue
                  )),
                ),
                Padding(padding: EdgeInsets.only(top: 6)),

                Text(detail.location != null ? detail.location : '', style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                )),

                Padding(padding: EdgeInsets.only(top: 3)),

                Text(detail.date + ' ' + detail.startTime + ' - ' + detail.endTime, style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                )),

                Padding(padding: EdgeInsets.only(top: 5)),

                Row(
                  children: <Widget>[
                    Visibility(
                      visible: detail.availability == 'full' ? true : false,
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
                      visible: detail.attending ? false : true,
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
                        child: Text(detail.availability.toUpperCase()+' (${detail.seatAvailability})',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white
                          ),),
                      ),
                    ),

                    Visibility(
                      visible: detail.attending ? true : false,
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
                Text(detail.comment != null ? detail.comment : "",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),),

                Padding(padding: EdgeInsets.only(top: 10)),

                Row(
                  children: <Widget>[
                    Visibility(
                      visible: detail.attending ? false : true,
                      child: GestureDetector(
                        onTap: (){
                          Utils.check().then((internet){
                            if (internet != null && internet){

                              Map data = {
                                'attendanceStatus' : Constants.ATTENDING_STATUS_CONFIRM
                              };
                              _acceptDeclineSpeedSession(data, context, detail.id);
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
                      visible: detail.attending ? true : false,
                      child: GestureDetector(
                        onTap: (){
                          Utils.check().then((internet){
                            if (internet != null && internet){

                              Map data = {
                                'attendanceStatus' : Constants.ATTENDING_STATUS_DECLINE
                              };
                              _acceptDeclineSpeedSession(data, context, detail.id);
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

  Navigator.pop(context);
  if (response.statusCode == 200){
    var parsedJson = json.decode(response.body);
    BookmarkResponse login = BookmarkResponse.fromJson(parsedJson);
    var error = login.message;

    Navigator.pop(context,'Success');
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
    Navigator.pop(context,'Cancel');
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
