import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:innovation_bridge/detailScreens/SpeedSessionDetails.dart';
import 'package:innovation_bridge/fragments/ProgramScreen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpeedSessionScreen extends StatefulWidget {
  @override
  _SpeedSessionScreenState createState() => _SpeedSessionScreenState();
}

class _SpeedSessionScreenState extends State<SpeedSessionScreen> {

  CalendarController _calendarController;

  final String uri = 'https://jsonplaceholder.typicode.com/users';

  Future<List<Users>> _fetchUsers() async {
    var response = await http.get(Uri.encodeFull(uri));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Users> listOfUsers = items.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

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
            child: StreamBuilder(
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
                              builder: (context) => SpeedSessionDetials()
                          ));
                        },
                        child: Text('Speed Session Tile', style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          color: Colors.blue
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

                      Padding(padding: EdgeInsets.only(top: 5)),

                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration:BoxDecoration(
                              border: Border.all(width: 1.2,
                                  color: Colors.grey[600]
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0) //                 <--- border radius here
                              ),
                            ), //             <--- BoxDecoration here
                            child: Text('Full', style: TextStyle(
                              fontSize: 10
                            ),),
                          ),

                          Padding(padding: EdgeInsets.only(right: 5)),

                          Container(
                            padding: EdgeInsets.all(5),
                            decoration:BoxDecoration(
                              border: Border.all(width: 1.2,
                                  color: Colors.grey[600]
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0) //                 <--- border radius here
                              ),
                            ), //             <--- BoxDecoration here
                            child: Text('Open (3)', style: TextStyle(
                                fontSize: 10
                            ),),
                          ),

                          Padding(padding: EdgeInsets.only(right: 5)),

                          Container(
                            padding: EdgeInsets.all(5),
                            decoration:BoxDecoration(
                              border: Border.all(width: 1.2,
                                  color: Colors.grey[600]
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0) //                 <--- border radius here
                              ),
                            ), //             <--- BoxDecoration here
                            child: Text('Attending', style: TextStyle(
                                fontSize: 10
                            ),),
                          )
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 6)),
                      Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),),

                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width /13,
                                height: MediaQuery.of(context).size.height /13,
                                child: Image(image: ExactAssetImage('images/bookmark.png')),
                              ),

                              Text('RSVP', style: TextStyle(
                                fontSize: 12
                              ),)
                            ],
                          ),

                          Padding(padding: EdgeInsets.only(left: 10)),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width /13,
                                height: MediaQuery.of(context).size.height /13,
                                child: Image(image: ExactAssetImage('images/bookmark.png')),
                              ),

                              Text('Decline', style: TextStyle(
                                  fontSize: 12
                              ),)
                            ],
                          ),
                        ],
                      ),

                      Divider(
                        color: Colors.black,
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

  void _onDaySelected(DateTime day, List events) {
    print('@@ CALLBACK: _onDaySelected' +day.toIso8601String());
    setState(() {

    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }
}
