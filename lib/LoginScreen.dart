import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innovation_bridge/MapScreen.dart';
import 'package:innovation_bridge/NoActiveEventsScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/dialogs/DialogOnClickAction.dart';
import 'package:innovation_bridge/entities/EventDetail.dart';
import 'package:innovation_bridge/entities/LoginAuthenticate.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:innovation_bridge/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _cellNoController = TextEditingController();
  final _loginCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
      body: SafeArea(
        child: Container(
          child:  Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3 ,
                        height: 140,
                        child:  Image(image: ExactAssetImage('images/innovation_bridge_logo.png')),
                      ),
                    ),
                  ),
                ),
              ),

              Flexible(
                flex: 10,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 8,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _cellNoController,
                                decoration: InputDecoration(
                                  labelText: 'Cell No',
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _loginCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Login Code (check email)',
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Container(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: new RaisedButton(
                                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                                        textColor: Colors.white,
                                        color: Colors.blue,
                                        child: Text('LOG IN'),
                                        onPressed: () {

                                          String email = _emailController.text;
                                          String cellNumber = _cellNoController.text;
                                          String loginCode = _loginCodeController.text;

                                          print('@@ Email == '+email);
                                          print('@@ Cell No == '+cellNumber);
                                          print('@@ Login code == '+loginCode);

                                          if (email.isEmpty && cellNumber.isEmpty && loginCode.isEmpty){
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => CommonMessageDialog(dialogTitle: 'Alert',
                                                  errorMessage: 'Please enter mandatory fields'),
                                            );
                                            return;
                                          }

                                          if (cellNumber.isEmpty && loginCode.isEmpty){
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => CommonMessageDialog(dialogTitle: 'Alert',
                                                  errorMessage: 'Please enter Cell No and Login Code'),
                                            );
                                            return;
                                          }

                                          if (email.isEmpty){
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => CommonMessageDialog(dialogTitle: 'Alert',
                                                  errorMessage: 'Please enter Email'),
                                            );
                                            return;
                                          }

                                          if (cellNumber.isEmpty){
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => CommonMessageDialog(dialogTitle: 'Alert',
                                                  errorMessage: 'Please enter Cell No'),
                                            );
                                            return;
                                          }

                                          if (loginCode.isEmpty){
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => CommonMessageDialog(dialogTitle: 'Alert',
                                                  errorMessage: 'Please enter Login Code'),
                                            );
                                            return;
                                          }

                                          if (EmailValidator.Validate(email)){
                                            Utils.check().then((internet) {
                                              if (internet != null && internet){
                                                Map data = {
                                                  'email': email,
                                                  'password': loginCode
                                                };
                                                _authenticateUser(data, context);
                                              }
                                              else{
                                                Fluttertoast.showToast(msg: Constants.CHECK_NETWORK_CONNECTION);
                                              }
                                            });
                                          }
                                          else{
                                            Fluttertoast.showToast(msg: 'Please enter valid email');
                                          }

                                           /*Map data = {
                                                  'email': 'wjviljoen@gmail.com',
                                                  'password': '846308'
                                                };

                                          _authenticateUser(data, context);*/
                                          /*Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => HomeDashboard()),
                                                (Route<dynamic> route) => false,
                                          );*/
                                        }),
                                  )
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: new RaisedButton(
                                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                                              textColor: Colors.black,
                                              color: Colors.grey,
                                              child: Text('CANCEL'),
                                              onPressed: () {

                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) => CommonMessageDialog(dialogTitle: 'Alert',
                                                      errorMessage: 'You have to be logged in to use the functionality of the Mobile App. Please register or Login to the App.'),
                                                );

                                                /*Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => MapScreen()),
                                              (Route<dynamic> route) => false,
                                        );*/

                                              }),
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: new RaisedButton(
                                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue,
                                              child: Text('REGISTER'),
                                              onPressed: () {
                                                _launchURL();
                                              }),
                                        )
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Image(image: ExactAssetImage('images/dsi_logo.png')),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 12),
                                  child:  Image(image: ExactAssetImage('images/sfsa_logo.png')),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    child: Image(image: ExactAssetImage('images/csir_logo.png')),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }

  _launchURL() async {
    const url = 'https://www.innovationbridge.info/ibportal/?q=innovation-bridge-event/register';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

Future<LoginAuthenticate> _authenticateUser(Map data, BuildContext context) async {

  showDialog(
    barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator(),);
      });

  var body = json.encode(data);

  var response = await http.post(Uri.encodeFull(ServiceConstants.AUTHENTICATION_TOKEN),
      headers: {"Content-Type": "application/json"},
      body: body
  );

  print("@@ response of login status code == ${response.statusCode}");
  print("@@ response of login json data == ${response.body}");

  var parsedJson = json.decode(response.body);
  LoginAuthenticate login = LoginAuthenticate.fromJson(parsedJson);

  Navigator.pop(context);
  if (response.statusCode == 200){
    print('@@ inside success 200');

    Utils.setPreference(Constants.LOGIN_CHECK, Constants.LOGGED_IN);
    Utils.setPreference(Constants.AUTH_TOKEN, "Bearer ${login.token}");

    _fetchEventDetails(context, "Bearer ${login.token}");

    /*Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeDashboard()),
          (Route<dynamic> route) => false,
    );*/
    return login;
  }
  else{
    var error = login.message;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: error.status,
          errorMessage: error.message),
    );
  }

}

Future<Null> _fetchEventDetails(BuildContext context, String authToken) async {

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      });

  SharedPreferences pref = await SharedPreferences.getInstance();

  var response = await http.get(Uri.encodeFull(ServiceConstants.GET_EVENT_DETAILS),
    headers: {"Content-Type":"application/json", "Authorization":pref.getString(Constants.AUTH_TOKEN)},
  );

  print("@@ response inside initState status code == ${response.statusCode}");
  print("@@ response  inside initState  json data == ${response.body}");

  var parsedJson = json.decode(response.body);
  print("@@ parsed json of form template json data == $parsedJson");

  Navigator.pop(context);
  if (response.statusCode == 200){
    print('@@ inside 200 ');
    EventDetail eventDetails = EventDetail.fromJson(jsonDecode(response.body));

    if (eventDetails.isActive){
      // Check for active events . . .

      DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssz");
      DateTime startDateTime = dateFormat.parse(eventDetails.startDate);
      DateTime endDateTime = dateFormat.parse(eventDetails.endDate);

      // Utils.setPreferenceInt(Constants.EVENT_COMPLETE_START_DATE, startDateTime.toString());

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
      builder: (_) => CommonMessageDialog(dialogTitle: Constants.TITLE_ALERT,
          errorMessage: Constants.SESSION_EXPIRED_LOGIN_AGAIN),
    );
  }
  else {
    // No events found ..
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NoActiveEventsScreen()),
          (Route<dynamic> route) => false,
    );
  }
}


