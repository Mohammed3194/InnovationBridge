import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:innovation_bridge/MapScreen.dart';
import 'package:innovation_bridge/dashboardScreens/HomeDashboard.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/entities/LoginAuthenticate.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class NoActiveEventsScreen extends StatefulWidget {
  @override
  _NoActiveEventsScreenState createState() => _NoActiveEventsScreenState();
}

class _NoActiveEventsScreenState extends State<NoActiveEventsScreen> {

  final _emailController = TextEditingController();
  final _cellNoController = TextEditingController();
  final _loginCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Container(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.3,
                            height: 140,
                            child: Image(image: ExactAssetImage(
                                'images/innovation_bridge_logo.png')),
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
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text('No Active Events Found',
                                          style: TextStyle(
                                              fontSize: 18
                                          )),
                                    ),

                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 45,
                                          child: new RaisedButton(
                                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue,
                                              child: Text('CLOSE THE APP'),
                                              onPressed: () {
                                                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                              }),
                                        )
                                    )
                                  ],
                                ),
                              )
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
                                      child: Image(image: ExactAssetImage(
                                          'images/dsi_logo.png')),
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
                                      child: Image(image: ExactAssetImage(
                                          'images/sfsa_logo.png')),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin: EdgeInsets.all(20),
                                        padding: EdgeInsets.fromLTRB(
                                            10, 15, 0, 0),
                                        child: Image(image: ExactAssetImage(
                                            'images/csir_logo.png')),
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
}

