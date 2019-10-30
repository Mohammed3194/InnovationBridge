import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovation_bridge/detailScreens/ProgramDetailScreen.dart';
import 'package:innovation_bridge/entities/Programs.dart';
import 'package:innovation_bridge/utils/ServiceConstants.dart';
import 'package:table_calendar/table_calendar.dart';

class ProgramScreen extends StatefulWidget {
  @override
  _ProgramScreenState createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {

  var meteors = [
    "Tunguska",
    "Crab Pulsar",
    "Geminga",
    "Calvera",
    "Vela X-1",
  ];

  final String uri = 'https://jsonplaceholder.typicode.com/users';

  Future<List<Data>> _fetchUsers() async {
    var response = await http.get(Uri.encodeFull(ServiceConstants.GET_ALL_PROGRAMS),
      headers: {"Content-Type":"application/json", "Authorization":ServiceConstants.AUTH_TOKEN},
    );

    print("@@ response of form template status code == ${response.statusCode}");
    print("@@ response of form template json data == ${response.body}");

    var parsedJson = json.decode(response.body);
    print("@@ parsed json of form template json data == $parsedJson");

    /*print('@@ inside fetch user == ');
    var response = await http.get(Uri.encodeFull(uri));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Users> listOfUsers = items.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }*/
  }

  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('@@ CALLBACK: _onDaySelected' +day.toIso8601String());
    setState(() {

    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[350],
            child: _buildTableCalendar(),
          ),

          Expanded(
            child:  StreamBuilder(
              stream: Connectivity().onConnectivityChanged,
              builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapShot){
                if (!snapShot.hasData) return Center(child: CircularProgressIndicator());
                var result = snapShot.data;
                switch (result) {
                  case ConnectivityResult.none:
                    print("no net");
                    return Center(child: Text("No Internet Connection! none "));
                  case ConnectivityResult.mobile:
                    return _listDetials();
                  case ConnectivityResult.wifi:
                    print("yes net");
                    return _listDetials();
                  default:
                    return Center(child: Text("No Internet Connection! default"));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  FutureBuilder _listDetials(){
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
          return ListView.builder(
            itemCount: snapshot.data.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index){
              return Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 4),
                child: Container(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ProgramDetailScreen()
                          ));
                        },
                        child: Text('Program Activity Title', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        )),
                      ),
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('Location Name', style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent,
                            )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Start time - End time', style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ))
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 6)),
                      Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),),
                      ExpansionTile(
                        title: Text(''),
                        trailing: Icon(
                          Icons.face,
                          size: 36.0,
                        ),
                        children: <Widget>[
                          GridView.count(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              crossAxisCount: 3,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5,
                              childAspectRatio: MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 4),
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.9
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0) //                 <--- border radius here
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(6, 5, 0, 0),
                                          child: Text('Session Title',
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(6, 1, 0, 0),
                                          child:  Text('10:00 - 10:30',
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 9
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(6, 1, 0, 0),
                                          child: Text('Hall B',
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 9
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ],
                        // onExpansionChanged: (bool expanding) => setState(() => this.isExpanded = expanding),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: true,
      initialCalendarFormat: CalendarFormat.week, availableCalendarFormats: const { CalendarFormat.week: 'Week', },
      calendarStyle: CalendarStyle(
          selectedColor: Colors.deepOrange[400],
          todayColor: Colors.deepOrange[200],
          markersColor: Colors.brown[700],
          outsideDaysVisible: true
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }
}



Widget createGridView(BuildContext context, List<String> cosmicBodies) {
  //I will shuffle my data
  cosmicBodies.shuffle();

  // Then build my GridView and return it
  return new GridView.builder(
      itemCount: cosmicBodies.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 15.0),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 5.0,
            child: new Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
              child: new Text(cosmicBodies[index]),
            ),
          ),
        );
      });
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
