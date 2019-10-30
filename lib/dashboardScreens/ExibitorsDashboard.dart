import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/AddBookmarkScreen.dart';
import 'package:innovation_bridge/EditDeleteBookmarkScreen.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/MapScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/PrivacyPolicyDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/TermsConditionsDashboard.dart';
import 'package:innovation_bridge/detailScreens/ExhibitorDetailScreen.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/Exhibitors.dart' as exhibitor;
import 'package:innovation_bridge/entities/MapDetail.dart' as mapDetail;
import 'package:innovation_bridge/entities/BookmarkDetails.dart' as bookDetails;
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExibitorsDashboard extends StatefulWidget {
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
  _ExibitorsDashboardState createState() => _ExibitorsDashboardState();
}

class _ExibitorsDashboardState extends State<ExibitorsDashboard> {
  List<exhibitor.Data> listOfExhibitors = [];

  int _selectedDrawerIndex = 7;
  final GlobalKey<_ExibitorsScreenState> _key = GlobalKey();
  final controller = new TextEditingController();

  Future<List<exhibitor.Data>> _getListOfExhibitors() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.encodeFull(ServiceConstants.GET_ALL_EXHIBITORS),
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
      exhibitor.Exhibitors myClass =
          exhibitor.Exhibitors.fromJson(jsonDecode(response.body));
      print('@@ inside 200 $myClass');

      setState(() {
        listOfExhibitors = myClass.data;
        return listOfExhibitors;
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
      Fluttertoast.showToast(
          msg: Constants.INTERNAL_SERVER_ERROR, toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(
          msg: 'Somethins went wrong', toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  initState() {
    super.initState();
    controller.addListener(onChange);
    Utils.check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        _getListOfExhibitors();
      } else {
        print('No internet == ');
        Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
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

  Widget appBarTitle = new Text("Exhibitor");
  Icon actionIcon = new Icon(Icons.search);

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
          /*if (widget.drawerItems[i].title == 'Exibitors') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ExibitorsDashboard()),
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
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  controller: controller,
                  autofocus: true,
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
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("Exhibitor");
              }
            });
          },
        ),
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
      body: listOfExhibitors.length > 0
          ? ExibitorsScreen(key: _key, listOfExhibitors: listOfExhibitors)
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

class ExibitorsScreen extends StatefulWidget {
  List<exhibitor.Data> listOfExhibitors;
  ExibitorsScreen({Key key, List<exhibitor.Data> this.listOfExhibitors})
      : super(key: key);

  @override
  _ExibitorsScreenState createState() =>
      _ExibitorsScreenState(listOfExhibitors);
}

class _ExibitorsScreenState extends State<ExibitorsScreen> {
  String enteredText = '';

  List<exhibitor.Data> initialExhibitorList;
  List<exhibitor.Data> currentExhibitorList = [];

  _ExibitorsScreenState(this.initialExhibitorList);

  @override
  void initState() {
    super.initState();
    filterExhibitors();
  }

  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  Widget build(BuildContext context) {
    filterExhibitors();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView.builder(
        itemCount: currentExhibitorList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          exhibitor.Data exhibitorDetail =
              currentExhibitorList.elementAt(index);

          if (exhibitorDetail.description != null) {
            print(
                ' @@@ program details length ${exhibitorDetail.description.length}');
            if (exhibitorDetail.description.length > 300) {
              firstHalf = exhibitorDetail.description.substring(0, 280);
              secondHalf = exhibitorDetail.description
                  .substring(280, exhibitorDetail.description.length);
            } else {
              firstHalf = exhibitorDetail.description;
              secondHalf = "";
            }
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 4),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExhibitorDetailScreen(
                                  detail: exhibitorDetail)));
                    },
                    // Exhibitor title
                    child: Text(exhibitorDetail.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 6)),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        // Exhibitor Category
                        child: Text(exhibitorDetail.category,
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
                            // Location Name
                            child: Text(
                                exhibitorDetail.location != null
                                    ? exhibitorDetail.location.title
                                    : '',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ))),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 6)),
                  Column(
                    children:
                        createTextInnovations(exhibitorDetail.innovations),
                  ),
                  Padding(padding: EdgeInsets.only(top: 6)),
                  exhibitorDetail.description != null
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
                                        : (firstHalf + secondHalf),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                                new InkWell(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      new Text(
                                        flag ? "more[..]" : "  less  ",
                                        style: new TextStyle(
                                            color: Colors.blue, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // On navigate . . . .
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ExhibitorDetailScreen(
                                                    detail: exhibitorDetail)));
                                    /*setState(() {
                                  flag = !flag;
                                });*/
                                  },
                                ),
                              ],
                            )
                      : Text(""),

                  /*Text(exhibitorDetail.description != null ? exhibitorDetail.description : "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    )
                  ),*/

                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            bool isBookmarked = exhibitorDetail.bookmarked;
                            if (isBookmarked) {
                              // Already Bookmarked
                              Utils.check().then((internet){
                                if (internet != null && internet){
                                  _getBookmarkDetailsById(exhibitorDetail.bookmarkId);
                                }
                                else {
                                  Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                                }
                              });

                            } else {
                              // No Bookmarked
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddBookmarkScreen(
                                          referencedId: exhibitorDetail.id,
                                          nameTitle: exhibitorDetail.title,
                                          type: Constants.TYPE_EXHIBITOR,
                                          uuid: exhibitorDetail.uuid,
                                        )),
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 13,
                            height: MediaQuery.of(context).size.height / 13,
                            child: exhibitorDetail.bookmarked
                                ? Image(
                                    image: ExactAssetImage(
                                        'images/bookmark_remove.png'))
                                : Image(
                                    image: ExactAssetImage(
                                        'images/bookmark_add.png')),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 14)),
                        GestureDetector(
                          onTap: () async {
                            Utils.check().then((internet) async {
                              if (internet != null && internet) {
                                String location = '';
                                if (exhibitorDetail.location != null) {
                                  location = exhibitorDetail.location.title;
                                }
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    });

                                mapDetail.MapDetail detail =
                                    await _getMapDetail(exhibitorDetail.id);
                                if (detail != null) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen(
                                                detail: detail,
                                                title: exhibitorDetail.title,
                                                subTitle:
                                                    exhibitorDetail.category,
                                                location: location,
                                              )));
                                }
                              } else {
                                Utils.showCommonMessageDialog(
                                    context,
                                    Constants.TITLE_ALERT,
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
                            width: MediaQuery.of(context).size.width / 12.5,
                            height: MediaQuery.of(context).size.height / 12.5,
                            child: Image(
                                image: ExactAssetImage('images/icon_map.png')),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  )
                ],
              ),
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
    var response = await http.get(
      Uri.encodeFull(
          ServiceConstants.GET_EXHIBITOR_MAP_DETAIL + id.toString() + '/map'),
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
      mapDetail.MapDetail detail =
          mapDetail.MapDetail.fromJson(jsonDecode(response.body));
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

  List<Widget> createTextInnovations(List<exhibitor.Innovations> innovations) {
    List<Widget> listOfText = new List<Widget>();

    if (innovations != null) {
      if (innovations.length > 3) {
        for (int i = 0; i < 3; i++) {
          listOfText.add(Align(
            alignment: Alignment.centerLeft,
            child: Text(
                i == 2 ? innovations[i].title + " ...." : innovations[i].title,
                style: TextStyle(fontSize: 9)),
          ));
        }
        return listOfText;
      } else {
        for (var item in innovations) {
          listOfText.add(Align(
            alignment: Alignment.centerLeft,
            child: Text(item.title, style: TextStyle(fontSize: 8.5)),
          ));
        }
        return listOfText;
      }
    }
    return new List<Widget>();
  }

  methodUpdateFilter(String text) {
    setState(() {
      enteredText = text;
    });
  }

  filterExhibitors() {
    // Prepare lists
    List<exhibitor.Data> tmp = [];
    currentExhibitorList.clear();

    String name = enteredText;
    print("filter cars for name " + name);
    if (name.isEmpty) {
      tmp.addAll(initialExhibitorList);
    } else {
      for (exhibitor.Data c in initialExhibitorList) {
        if (c.description != null) {
          if (c.title.toLowerCase().contains(name.toLowerCase()) ||
              c.description.toLowerCase().contains(name.toLowerCase())) {
            tmp.add(c);
          }
        }
        else{
          if (c.title.toLowerCase().contains(name.toLowerCase())){
            tmp.add(c);
          }
        }
      }
    }
    setState(() {
      currentExhibitorList = tmp;
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
