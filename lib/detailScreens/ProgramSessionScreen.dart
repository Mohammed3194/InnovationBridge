import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/EditDeleteBookmarkScreen.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/BookmarkDetails.dart';
import 'package:innovation_bridge/entities/ProgramID.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AddBookmarkScreen.dart';
import 'package:http/http.dart' as http;

class ProgramSessionScreen extends StatefulWidget {

  ParallelActivities detail;
  ProgramSessionScreen({@required this.detail});



  @override
  _ProgramSessionScreenState createState() => _ProgramSessionScreenState(detail);
}

class _ProgramSessionScreenState extends State<ProgramSessionScreen> {

  ParallelActivities detail;
  _ProgramSessionScreenState(this.detail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parallel Session'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(detail.title, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )),
                Padding(padding: EdgeInsets.only(top: 4)),
                Text(detail.location, style: TextStyle(
                    fontSize: 12,
                  color: Colors.blue
                )),
                Text(detail.startTime + ' - ' +detail.endTime, style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue
                )),
                Padding(padding: EdgeInsets.only(top: 6)),
                Text(detail.details,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),),
                Padding(padding: EdgeInsets.only(top: 10)),

                Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration:BoxDecoration(
                        border: Border.all(width: 1.2,
                            color: Colors.grey[600]
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0) //                 <--- border radius here
                        ),
                      ), //             <--- BoxDecoration here
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: Text('Presenter name', style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold
                                      ))
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('10:00 - 10:15', style: TextStyle(
                                          fontSize: 11.5,
                                        )),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Scope of the presentation', style: TextStyle(
                                    fontSize: 12,
                                  )),
                                )
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),

                GestureDetector(
                  onTap: (){
                    bool isBookmarked = detail.bookmarked;
                    if (isBookmarked){
                      Utils.check().then((internet){
                        if (internet != null && internet){
                          _getBookmarkDetailsById(context, detail.bookmarkId);
                        }
                        else{
                          Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                        }
                      });
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                        => AddBookmarkScreen(
                          referencedId: detail.id,
                          nameTitle: detail.title,
                          type: Constants.TYPE_PROGRAM_SESSION,
                          uuid: detail.uuid,
                        )),
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width /12,
                    height: MediaQuery.of(context).size.height /12,
                    child: detail.bookmarked ? Image(image: ExactAssetImage('images/bookmark_remove.png')) :
                    Image(image: ExactAssetImage('images/bookmark_add.png')),
                  ),
                )

              ],
            ),
          )
        ),
      ),
    );
  }
}

Future<BookmarkDetails> _getBookmarkDetailsById(BuildContext context, int bookmarkId) async {

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
    BookmarkDetails details = BookmarkDetails.fromJson(jsonDecode(response.body));

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
