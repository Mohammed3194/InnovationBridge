import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/entities/BookmarkResponse.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoveBookmarkDialog extends StatefulWidget {

  final int id;
  final String comment;
  RemoveBookmarkDialog({@required this.id, this.comment});

  @override
  State<StatefulWidget> createState() => RemoveBookmarkDialogState(id, comment);
}

class RemoveBookmarkDialogState extends State<RemoveBookmarkDialog>
    with SingleTickerProviderStateMixin {

  final int id;
  final String comment;
  RemoveBookmarkDialogState(this.id, this.comment);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
            margin: EdgeInsets.all(50.0),
            padding: EdgeInsets.all(10),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 50.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Remove Bookmark', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black
                    )),
                  ),
                ),

                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Do you want to Remove the Bookmark?',
                        softWrap: true,
                        style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
                    )),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){

                        Utils.check().then((internet) {
                          if (internet != null && internet){

                            Map data = {
                              'id': id,
                              'comment': comment,
                              'delete' : true
                            };
                            print('@@ final json request of add bookmark == '+data.toString());

                            _removeBookmark(data, context);
                          }
                          else{
                            Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                          }
                        });


                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 18,
                        height: MediaQuery.of(context).size.height / 18,
                        margin: EdgeInsets.all(20),
                        child: Image(image: ExactAssetImage('images/icon_accept.png')),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context, 'Cancel');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 18,
                        height: MediaQuery.of(context).size.height / 18,
                        margin: EdgeInsets.all(20),
                        child: Image(image: ExactAssetImage('images/icon_decline.png')),
                      ),
                    )
                  ],
                ),

                /*SizedBox(
                  width: 80.0,
                  height: 30.0,
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('OK', style: TextStyle(
                        color: Colors.white
                    )),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),*/

                Padding(padding: EdgeInsets.only(bottom: 10))
              ],
            )
        ),
      ),
    );
  }
}

Future<BookmarkResponse> _removeBookmark(Map data, BuildContext context) async {

  showDialog(
      context: context,
      builder: (BuildContext aaaaa) {
        return Center(child: CircularProgressIndicator());
      });

  var body = json.encode(data);

  SharedPreferences pref = await SharedPreferences.getInstance();
  var response = await http.post(Uri.encodeFull(ServiceConstants.BOOKMARK_EDIT_DELETE),
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

    Navigator.pop(context,'Success');
    Fluttertoast.showToast(msg: "Successfully removed bookmark");
    return login;
  }
  else if (response.statusCode == 401){
    Fluttertoast.showToast(msg: Constants.SESSION_EXPIRED_LOGIN_AGAIN, toastLength: Toast.LENGTH_LONG);
    /*showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: Constants.TITLE_ALERT,
          errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
    );*/
  }
  else{
    var parsedJson = json.decode(response.body);
    BookmarkResponse login = BookmarkResponse.fromJson(parsedJson);
    var error = login.message;
    Fluttertoast.showToast(msg: error.message, toastLength: Toast.LENGTH_LONG);
    Navigator.pop(context,'Cancel');
    /*showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: error.status,
          errorMessage: error.message),
    );*/
  }

}