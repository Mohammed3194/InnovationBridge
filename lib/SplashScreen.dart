import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/NoActiveEventsScreen.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/EventDetail.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboardScreens/HomeDashboard.dart';

import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

// void main() => runApp(MyApp());

Future main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Utils.hexToColor("#F24A1C"), //Changing this will change the color of the TabBar
        accentColor: Colors.black,
        // primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIsLogin();

   /* Future<String> loginCheck = Utils.getPreference(Constants.LOGIN_CHECK);
    print('@@ splash screen login check == '+loginCheck.toString());*/

    /*Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 10,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width /3.6 ,
                        height: 100,
                        child: Image(image: ExactAssetImage('images/dsi_logo.png')),
                      ),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Container(
                        width: MediaQuery.of(context).size.width / 3.8 ,
                        height: 100,
                        child: Image(image: ExactAssetImage('images/innovation_bridge_logo.png')),
                      ),
                      Padding(padding: EdgeInsets.only(right: 12)),
                      Container(
                        width: MediaQuery.of(context).size.width / 3.8 ,
                        height: 100,
                        child:  Image(image: ExactAssetImage('images/sfsa_logo.png')),
                      ),

                    ],
                  ),

                  Text('... loading ...', style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                  ),)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child:  Text('developed by', style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400
                      ),),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      child: Image(image: ExactAssetImage('images/csir_logo.png')),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  Future<Null> checkIsLogin() async {
    String loginCheck = '';
    String authToken = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginCheck = prefs.getString(Constants.LOGIN_CHECK);
    authToken = prefs.getString(Constants.AUTH_TOKEN);

    // print('@@ login check value == '+loginCheck);

    if (loginCheck != "" && loginCheck != null ){
      if (loginCheck == Constants.LOGGED_IN){
        print("@@ alreay login.");
        //your home page is loaded

        Utils.check().then((internet){
          if (internet != null && internet){
            _fetchEventDetails(authToken);
          }
          else{
            Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
          }
        });

      }
      else{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      }
    }
    else
    {
      //replace it with the login page
      print("@@ alreay not login.");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }

  Future<EventDetail> _fetchEventDetails(String authToken) async {
    var response = await http.get(Uri.encodeFull(ServiceConstants.GET_EVENT_DETAILS),
      headers: {"Content-Type":"application/json", "Authorization":authToken},
    );

    print("@@ response fetch event detail status code == ${response.statusCode}");
    print("@@ response fetch event detail  json data == ${response.body}");

    if (response.statusCode == 200){
      print('@@ inside 200 ');
      EventDetail eventDetails = EventDetail.fromJson(jsonDecode(response.body));
      
      if (eventDetails.isActive){
        // Check for active events . . .

        DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssz");
        DateTime startDateTime = dateFormat.parse(eventDetails.startDate);
        DateTime endDateTime = dateFormat.parse(eventDetails.endDate);

        Utils.setPreference(Constants.EVENT_NAME, eventDetails.name);
        Utils.setPreference(Constants.EVENT_START_DATE, DateFormat('dd/MM/yyyy').format(startDateTime));
        Utils.setPreference(Constants.EVENT_END_DATE, DateFormat('dd/MM/yyyy').format(endDateTime));
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeDashboard()),
              (Route<dynamic> route) => false,
        );
      }
      else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NoActiveEventsScreen()),
              (Route<dynamic> route) => false,
        );
      }
    }
    else if (response.statusCode == 401){
      // Authorization expired / incorrect
      print('@@ inside auth code error ==== ');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogOnClickAction(dialogTitle: Constants.TITLE_ALERT,
            errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
      );
    }
    else if (response.statusCode == 500){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CommonMessageDialog(
          dialogTitle: Constants.TITLE_ALERT,
          errorMessage: Constants.INTERNAL_SERVER_ERROR,
        )
      );
    }
    else {
      print('@@ inside else condition fetch event details ');
      // No events found ..
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NoActiveEventsScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }
}


