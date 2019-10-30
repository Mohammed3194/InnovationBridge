import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/AddBookmarkScreen.dart';
import 'package:innovation_bridge/EditDeleteBookmarkScreen.dart';
import 'package:innovation_bridge/MapScreen.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/Innovations.dart' as innov;
import 'package:innovation_bridge/entities/MapDetail.dart' as map;
import 'package:innovation_bridge/entities/BookmarkDetails.dart' as bookDetails;
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InnovationDetailScreen extends StatefulWidget {

  innov.Data detail;
  InnovationDetailScreen({@required this.detail});

  @override
  _InnovationDetailScreenState createState() => _InnovationDetailScreenState(detail);
}

class _InnovationDetailScreenState extends State<InnovationDetailScreen> {

  innov.Data innovation;
  _InnovationDetailScreenState(this.innovation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Innovation Detail'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 6)),

                GestureDetector(
                  onTap: (){

                  },
                  child: Text(innovation.title, style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  )),
                ),
                Padding(padding: EdgeInsets.only(top: 6)),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Text(innovation.industries.length > 0 ? innovation.industries[0] : "", style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.blueAccent,
                        )),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(innovation.location != null ? innovation.location.title : '', style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent,
                            )),
                          ),
                        )
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),

                Container(
                  width: double.infinity ,
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: innovation.image != null ? Image.network(innovation.image) : Icon(Icons.picture_in_picture),
                ),

                Padding(padding: EdgeInsets.only(top: 10)),

                Text( innovation.exhibitorName == null ? '' :
                innovation.exhibitorName + '(${innovation.exhibitorCategory})',
                    style: TextStyle(
                        fontSize: 8
                    )),

                Html(
                    data : innovation.description != null ? innovation.description : ""
                ),


                Padding(padding: EdgeInsets.only(top: 10)),

                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          bool isBookmarked = innovation.bookmarked;
                          if (isBookmarked){
                            // Already Bookmarked
                            Utils.check().then((internet) {
                              if (internet != null && internet){
                                _getBookmarkDetailsById(context, innovation.bookmarkId);
                              }
                              else {
                                Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                              }
                            });
                          }
                          else{
                            // No Bookmarked
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)
                              => AddBookmarkScreen(
                                referencedId: innovation.id,
                                nameTitle: innovation.title,
                                type: Constants.TYPE_INNOVATIONS,
                                uuid: innovation.uuid,
                              )),
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width /12,
                          height: MediaQuery.of(context).size.height /12,
                          child: innovation.bookmarked ? Image(image: ExactAssetImage('images/bookmark_remove.png')) :
                          Image(image: ExactAssetImage('images/bookmark_add.png')),
                        ),
                      ),


                      Padding(padding: EdgeInsets.only(left: 12)),

                      GestureDetector(
                        onTap: (){
                          Utils.check().then((internet) async {
                            if (internet != null && internet){

                              String location = '';
                              if (innovation.location != null){
                                location = innovation.location.title;
                              }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(child: CircularProgressIndicator());
                                  });

                              map.MapDetail mapDetail = await _getMapDetail(innovation.id);
                              if (mapDetail != null){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      detail: mapDetail,
                                      title: innovation.title,
                                      subTitle: '',
                                      location: location,
                                    )
                                ));
                              }
                            }
                            else{

                              Utils.showCommonMessageDialog(context, Constants.TITLE_ALERT,
                                  Constants.CHECK_NETWORK_CONNECTION);
                            }
                          });
                        },
                        child:  Container(
                          width: MediaQuery.of(context).size.width /12,
                          height: MediaQuery.of(context).size.height /12,
                          child: Image(image: ExactAssetImage('images/icon_map.png')),
                        ),
                      )

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bookDetails.BookmarkDetails> _getBookmarkDetailsById(BuildContext context, int bookmarkId) async {

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

Future<map.MapDetail> _getMapDetail(int id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var response = await http.get(Uri.encodeFull(ServiceConstants.GET_INNOVATION_MAP_DETAIL + id.toString() + '/map'),
    headers: {"Content-Type":"application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
  );

  print("@@ response of program id status code == ${response.statusCode}");
  print("@@ response of program id json data == ${response.body}");

  var parsedJson = json.decode(response.body);
  print("@@ parsed json of program id json data == $parsedJson");

  if (response.statusCode == 200){
    map.MapDetail detail = map.MapDetail.fromJson(jsonDecode(response.body));
    return detail;
  }
  /*else if (response.statusCode == 200){
      MapDetail detail = MapDetail.fromJson(jsonDecode(response.body));
      return detail;
    }*/
  else {
    return null;
  }
}
