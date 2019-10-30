import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/AddBookmarkScreen.dart';
import 'package:innovation_bridge/EditDeleteBookmarkScreen.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/MapScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/detailScreens/InnovationDetailScreen.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/Innovations.dart' as innov;
import 'package:innovation_bridge/entities/MapDetail.dart' as mapDetail;
import 'package:innovation_bridge/entities/BookmarkDetails.dart' as bookDetails;
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InnovationsDashboard extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Image(image: ExactAssetImage('images/icon_navigation_home.png'))),
    new DrawerItem("Privacy Policy", Image(image: ExactAssetImage('images/icon_navigation_privacy.png'))),
    new DrawerItem("Terms & Conditions", Image(image: ExactAssetImage('images/icon_navigation_terms.png'))),
    new DrawerItem("Logout", Image(image: ExactAssetImage('images/icon_navigation_logout.png')))
  ];

  @override
  _InnovationsDashboardState createState() => _InnovationsDashboardState();
}

class _InnovationsDashboardState extends State<InnovationsDashboard> {

  int _selectedDrawerIndex = 7;
  final GlobalKey<_InnovationsScreenState> _key = GlobalKey();
  final controller = new TextEditingController();

  @override
  initState() {
    super.initState();
    controller.addListener(onChange);
    Utils.check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        _getListOfInnovations();
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


  List<innov.Data> listOfInnovations = [];

  Future<List<innov.Data>> _getListOfInnovations() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.encodeFull(ServiceConstants.GET_ALL_INNOVATIONS),
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
      innov.Innovations myClass = innov.Innovations.fromJson(jsonDecode(response.body));
      print('@@ inside 200 $myClass');

      setState(() {
        listOfInnovations = myClass.data;
        return listOfInnovations;
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

  Widget appBarTitle = new Text("Innovations");
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
              /*if (widget.drawerItems[i].title == 'Innovations') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => InnovationsDashboard()),
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
                  this.appBarTitle = new Text("Innovations");
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
                  new Column(children: drawerOptions)
                ],
              ),
            ),
          )
        ),
      ),
      body: listOfInnovations.length > 0 ? InnovationsScreen(key: _key, listOfInnovations: listOfInnovations) :
      Center(child: CircularProgressIndicator()),
    );
  }
}

//Let's define a DrawerItem data object
class DrawerItem {
  String title;
  Image image;
  DrawerItem(this.title, this.image);
}


class InnovationsScreen extends StatefulWidget {

  List<innov.Data> listOfInnovations;
  InnovationsScreen({Key key, List<innov.Data> this.listOfInnovations}) : super(key: key);

  @override
  _InnovationsScreenState createState() => _InnovationsScreenState(listOfInnovations);
}

class _InnovationsScreenState extends State<InnovationsScreen> {
  String enteredText = '';

  List<innov.Data> initialInnovationsList;
  List<innov.Data> currentInnovationsList = [];

  _InnovationsScreenState(this.initialInnovationsList);

  @override
  void initState() {
    super.initState();
    filterInnovations();
  }

  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  Widget build(BuildContext context) {
    filterInnovations();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView.builder(
        itemCount: currentInnovationsList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index){
          innov.Data innovation = currentInnovationsList[index];

          if (innovation.description != null){
            print(' @@@ program details length ${innovation.description.length}');
            if (innovation.description.length > 300){
              firstHalf = innovation.description.substring(0, 280);
              secondHalf = innovation.description.substring(280, innovation.description.length);
            }
            else{
              firstHalf = innovation.description;
              secondHalf = "";
            }
          }

          return Container(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => InnovationDetailScreen(detail: innovation)
                          ));
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
                      Padding(padding: EdgeInsets.only(top: 2)),

                      Column(
                        children: <Widget>[
                          Text( innovation.exhibitorName == null ? '' :
                              innovation.exhibitorName + '(${innovation.exhibitorCategory})',
                              style: TextStyle(
                                  fontSize: 8
                              ))
                        ],
                      ),


                      innovation.description != null ?
                      secondHalf.isEmpty
                          ? Html(data: firstHalf)
                          : new Column(
                        children: <Widget>[
                          Html(
                            data: flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                          ),
                          /*new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf), style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          )),*/
                          new InkWell(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: new Text(
                                    flag ? "more[..]" : "  less  ",
                                    style: new TextStyle(color: Colors.blue, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              // On navigate . . . .
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => InnovationDetailScreen(detail: innovation)
                              ));
                              /*setState(() {
                                  flag = !flag;
                                });*/
                            },
                          ),
                        ],
                      ) :
                      Text(""),

                      /*Html(
                        data : innovation.description != null ? innovation.description : ""
                      ),*/

                      /*Text(innovation.description,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),),*/
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 10)),

                Container(
                  width: double.infinity ,
                  height: MediaQuery.of(context).size.height / 4,
                  child: innovation.image != null ? Image.network(innovation.image) : Icon(Icons.picture_in_picture),
                ),

                Padding(padding: EdgeInsets.only(top: 10)),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          bool isBookmarked = innovation.bookmarked;
                          if (isBookmarked){
                            // Already Bookmarked
                            Utils.check().then((internet) {
                              if (internet != null && internet){
                                _getBookmarkDetailsById(innovation.bookmarkId);
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
                          width: MediaQuery.of(context).size.width /13,
                          height: MediaQuery.of(context).size.height /13,
                          child: innovation.bookmarked ? Image(image: ExactAssetImage('images/bookmark_remove.png')) :
                          Image(image: ExactAssetImage('images/bookmark_add.png')),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      GestureDetector(
                        onTap: () async {

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

                              mapDetail.MapDetail detail = await _getMapDetail(innovation.id);
                              if (detail != null){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      detail: detail,
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

                          /*Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MapScreen()),
                                  (Route<dynamic> route) => false,
                            );*/
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width /12.5,
                          height: MediaQuery.of(context).size.height /12.5,
                          child: Image(image: ExactAssetImage('images/icon_map.png')),
                        ),
                      )
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(bottom: 10)),

                Divider(
                  color: Colors.black,
                  height: 2,
                )
              ],
            ),
          );
        },
      ),
    );
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

  Future<mapDetail.MapDetail> _getMapDetail(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(Uri.encodeFull(ServiceConstants.GET_INNOVATION_MAP_DETAIL + id.toString() + '/map'),
      headers: {"Content-Type":"application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
    );

    print("@@ response of program id status code == ${response.statusCode}");
    print("@@ response of program id json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of program id json data == $parsedJson");

    if (response.statusCode == 200){
      mapDetail.MapDetail detail = mapDetail.MapDetail.fromJson(jsonDecode(response.body));
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

  Widget addExhibitorNameAndCateory(innov.Data innovation){
    if (innovation.exhibitorName != null){
      if (innovation.exhibitorCategory != null){
        return Text( innovation.exhibitorName + ' - ' + innovation.exhibitorCategory,
            style: TextStyle(
                fontSize: 8.5
            ));
      }
    }
  }

  methodUpdateFilter(String text) {
    setState(() {
      enteredText = text;
    });
  }

  filterInnovations() {
    // Prepare lists
    List<innov.Data> tmp = [];
    currentInnovationsList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty) {
      tmp.addAll(initialInnovationsList);
    } else {
      for (innov.Data c in initialInnovationsList) {
        if ((c.title != null) && (c.description != null) && (c.exhibitorName != null)) {
          if (c.title.toLowerCase().contains(name.toLowerCase()) ||
              c.description.toLowerCase().contains(name.toLowerCase()) ||
              c.exhibitorName.toLowerCase().contains(name.toLowerCase())) {
            tmp.add(c);
          }
        }
        else if ((c.description != null) && (c.exhibitorName != null)) {
          if (c.title.toLowerCase().contains(name.toLowerCase()) ||
              c.description.toLowerCase().contains(name.toLowerCase()) ||
              c.exhibitorName.toLowerCase().contains(name.toLowerCase())) {
            tmp.add(c);
          }
          else if (c.description != null){
            if (c.title.toLowerCase().contains(name.toLowerCase()) ||
                c.description.toLowerCase().contains(name.toLowerCase())) {
              tmp.add(c);
            }
          }
          else if (c.exhibitorName != null){
            if (c.title.toLowerCase().contains(name.toLowerCase()) ||
                c.exhibitorName.toLowerCase().contains(name.toLowerCase())) {
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
      currentInnovationsList = tmp;
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
