import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/AddBookmarkScreen.dart';
import 'package:innovation_bridge/EditDeleteBookmarkScreen.dart';
import 'package:innovation_bridge/MapScreen.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/Exhibitors.dart' as exhib;
import 'package:innovation_bridge/entities/MapDetail.dart' as map;
import 'package:innovation_bridge/entities/BookmarkDetails.dart' as bookDetails;
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExhibitorDetailScreen extends StatefulWidget {

  exhib.Data detail;
  ExhibitorDetailScreen({@required this.detail});

  @override
  _ExhibitorDetailScreenState createState() => _ExhibitorDetailScreenState(detail);
}

class _ExhibitorDetailScreenState extends State<ExhibitorDetailScreen> {

  exhib.Data detail;
  _ExhibitorDetailScreenState(this.detail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exhibitor Detail'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){

                      },
                      child: Text(detail.title, style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      )),
                    ),
                    Padding(padding: EdgeInsets.only(top: 6)),

                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(detail.category, style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                          )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(detail.location != null ? detail.location.title : '', style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent,
                              ))
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 20)),

              Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity ,
                          height: MediaQuery.of(context).size.height / 6,
                          child: detail.backgroundImage != null ? Image.network(detail.backgroundImage) :
                          Icon(Icons.picture_in_picture),
                        ),
                      ],
                    ),
                  ),

                  // Below container is used to align the notification icon

                  Container(
                    margin: EdgeInsets.fromLTRB(25, 17, 0, 0),
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width / 4,
                    child: detail.imageThumb != null ? Image.network(detail.imageThumb) : Icon(Icons.picture_in_picture),
                  ),

                ],
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: createTextInnovations(detail.innovations),
                    ),

                    Padding(padding: EdgeInsets.only(top: 10)),

                    Text(detail.description != null ? detail.description : "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),),

                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            bool isBookmarked = detail.bookmarked;
                            if (isBookmarked){
                              // Already Bookmarked
                              Utils.check().then((internet){
                                if (internet != null && internet){
                                  _getBookmarkDetailsById(context, detail.bookmarkId);
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
                                  referencedId: detail.id,
                                  nameTitle: detail.title,
                                  type: Constants.TYPE_EXHIBITOR,
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
                        ),
                        Padding(padding: EdgeInsets.only(left: 12)),
                        GestureDetector(
                          onTap: (){
                            Utils.check().then((internet) async {
                              if (internet != null && internet){

                                String location = '';
                                if (detail.location != null){
                                  location = detail.location.title;
                                }
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(child: CircularProgressIndicator());
                                    });

                                map.MapDetail mapDetail = await _getMapDetail(detail.id, context);
                                if (mapDetail != null){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                        detail: mapDetail,
                                        title: detail.title,
                                        subTitle: detail.category,
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
                          child: Container(
                            width: MediaQuery.of(context).size.width /12.5,
                            height: MediaQuery.of(context).size.height /12.5,
                            child: Image(image: ExactAssetImage('images/icon_map.png')),
                          ),
                        )
                      ],
                    ),

                    Padding(padding: EdgeInsets.only(bottom: 80))

                  ],
                ),
              )

            ],
          ),
        ),
        /*child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child:
        )*/
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

Future<map.MapDetail> _getMapDetail(int id, BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var response = await http.get(Uri.encodeFull(ServiceConstants.GET_EXHIBITOR_MAP_DETAIL + id.toString() + '/map'),
    headers: {"Content-Type":"application/json", "Authorization": pref.getString(Constants.AUTH_TOKEN)},
  );

  print("@@ response of program id status code == ${response.statusCode}");
  print("@@ response of program id json data == ${response.body}");

  var parsedJson = json.decode(response.body);
  print("@@ parsed json of program id json data == $parsedJson");

  if (response.statusCode == 200){
    map.MapDetail detail = map.MapDetail.fromJson(jsonDecode(response.body));
    return detail;
  }
  else if (response.statusCode == 401){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogOnClickAction(dialogTitle: Constants.TITLE_ALERT,
          errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
    );
  }
  else {
    return null;
  }
}

List<Widget> createTextInnovations(List<exhib.Innovations> innovations){
  List<Widget> listOfText = new List<Widget>();

  if (innovations != null){
    for(var item in innovations){
      listOfText.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(item.title,
                style: TextStyle(
                fontSize: 9
            )),
          )
      );
    }
  }
  return listOfText;
}
