import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/dashboardScreens/AttendeesDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ExibitorsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/InnovationsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ProgramDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/SpeedSessionDashboard.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/entities/BookmarkResponse.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBookmarkScreen extends StatefulWidget {

  int referencedId;
  String nameTitle;
  String type;
  String uuid;

  AddBookmarkScreen({@required this.referencedId, this.nameTitle, this.type, this.uuid});

  @override
  _AddBookmarkScreenState createState() => _AddBookmarkScreenState(referencedId, nameTitle, type, uuid);
}

class _AddBookmarkScreenState extends State<AddBookmarkScreen> {

  int referencedId;
  String nameTitle;
  String type;
  String uuid;
  String showTypeToUser;

  _AddBookmarkScreenState(this.referencedId, this.nameTitle, this.type, this.uuid);

  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if (type == Constants.TYPE_PROGRAM){
      showTypeToUser = "Program Activity";
    }
    else if (type == Constants.TYPE_EXHIBITOR){
      showTypeToUser = "Exhibitor";
    }
    else if (type == Constants.TYPE_INNOVATIONS){
      showTypeToUser = "Innovation";
    }
    else if (type == Constants.TYPE_ATTENDEES){
      showTypeToUser = "Attendee";
    }
    else if (type == Constants.TYPE_PROGRAM_SESSION){
      showTypeToUser = "Session";
    }

    print(' @@@ book mark uuid  ===== $uuid');

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bookmark'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 12, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
                // Padding(padding: EdgeInsets.only(top: 15)),
                Text(nameTitle,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Padding(padding: EdgeInsets.only(top: 4)),
                Text('Type: ' +showTypeToUser,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
                    )),

                Padding(padding: EdgeInsets.only(top: 10)),

                Container(
                  height: 140,
                  child: new ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 135.0,
                    ),
                    child: new Scrollbar(
                      child: new SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: SizedBox(
                          height: 135.0,
                          child: new TextFormField(
                            controller: _commentController,
                            maxLines: 100,
                            decoration: new InputDecoration(
                              labelText: 'Comment',
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black, width: 0.8)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black, width: 0.8)),
                            ),
                          ),
                        ),
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
                          child: Text('Save'),
                          onPressed: () {
                            String comment = _commentController.text;

                            if (comment.isEmpty){
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => CommonMessageDialog(dialogTitle: 'Alert',
                                    errorMessage: 'Please enter comment'),
                              );
                              return;
                            }

                            Utils.check().then((internet) {
                              if (internet != null && internet){

                                if(type == Constants.TYPE_PROGRAM_SESSION){
                                  Map data = {
                                    'referencedId': referencedId,
                                    'referencedUuid': uuid,
                                    'comment' : comment
                                  };
                                  print('@@ final json request of add bookmark == '+data.toString());
                                  _addBookmark(data, context ,type);
                                }
                                else{
                                  Map data = {
                                    'referencedId': referencedId,
                                    'type': type,
                                    'comment' : comment
                                  };
                                  print('@@ final json request of add bookmark == '+data.toString());
                                  _addBookmark(data, context ,type);
                                }


                              }
                              else{
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

Future<BookmarkResponse> _addBookmark(Map data, BuildContext context, String type) async {

  showDialog(
      context: context,
      builder: (BuildContext context) {
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

    Fluttertoast.showToast(msg: 'Bookmark added successfully');
    if (type == Constants.TYPE_EXHIBITOR){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ExibitorsDashboard()),
            (Route<dynamic> route) => false,
      );
    }
    if (type == Constants.TYPE_ATTENDEES){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AttendeesDashboard()),
            (Route<dynamic> route) => false,
      );
    }
    if (type == Constants.TYPE_INNOVATIONS){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => InnovationsDashboard()),
            (Route<dynamic> route) => false,
      );
    }
    if (type == Constants.TYPE_PROGRAM_SESSION){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProgramDashboard()),
            (Route<dynamic> route) => false,
      );
    }
    if (type == Constants.TYPE_PROGRAM){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProgramDashboard()),
            (Route<dynamic> route) => false,
      );
    }

    return login;
  }
  else if (response.statusCode == 401){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: Constants.TITLE_ALERT,
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
