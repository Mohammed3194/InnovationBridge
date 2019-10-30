import 'package:flutter/material.dart';
import 'package:innovation_bridge/dashboardScreens/AnnouncementsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/AttendeesDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/BookmarksDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ExibitorsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/InnovationsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/MeetingsDashboard.dart';
import 'package:innovation_bridge/dashboardScreens/ProgramDashboard.dart';
import 'package:innovation_bridge/fragments/ProgramScreen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[350],
            ),
          ),
          Expanded(
            flex: 11,
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          crossAxisCount: 3,
                          padding: const EdgeInsets.all(20.0),
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 2),
                          children: <Widget>[

                            // Event Program . .
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProgramDashboard()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/event_program.png')),
                                                  ),
                                                  Text('EVENT PROGRAM',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold
                                                  ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 40.0,
                                              width: 40.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Exibitors . . .
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => ExibitorsDashboard()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/exibitors.png')),
                                                  ),
                                                  Text('EXIBITORS',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold
                                                    ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 40.0,
                                              width: 40.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Innovations
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => InnovationsDashboard()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/innovations.png')),
                                                  ),
                                                  Text('INNOVATIONS',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold
                                                    ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 40.0,
                                              width: 40.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Attendees . . .
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => AttendeesDashboard()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/attendees.png')),
                                                  ),
                                                  Text('ATTENDEES',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold
                                                    ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 40.0,
                                              width: 40.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Meetings
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => MeetingsDashboard()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/meetings.png')),
                                                  ),
                                                  Text('SPEED SESSIONS',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold
                                                    ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 40.0,
                                              width: 40.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Bookmarks . . .
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => BookmarksDashboard()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/bookmarks.png')),
                                                  ),
                                                  Text('BOOKMARKS',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold
                                                    ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 40.0,
                                              width: 40.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Event Portals . . .
                            GestureDetector(
                              onTap: (){

                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/event_portal.png')),
                                                  ),
                                                  Text('EVENT PORTAL',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold
                                                    ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 40.0,
                                              width: 40.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Announcements . . .
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => AnnouncementsDashboard()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: GridTile(
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Hero(
                                        tag: "",
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(6),
                                                    padding: EdgeInsets.all(2),
                                                    width: 60 ,
                                                    height: 60,
                                                    child: Image(image: ExactAssetImage('images/announcements.png')),
                                                  ),
                                                  Text('ANNOUNCEMENTS',
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold
                                                    ),)
                                                ],
                                              ),
                                            ),

                                            // Below container is used to align the notification icon
                                            /* Container(
                                              color: Colors.pink,
                                              height: 20.0,
                                              width: 20.0,
                                            )*/

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(6),
                                      padding: EdgeInsets.all(6),
                                      width: 60 ,
                                      height: 60,
                                      child: Image(image: ExactAssetImage('images/dsi_logo.png')),
                                    )
                                  ),

                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        padding: EdgeInsets.all(4),
                                        width: 60 ,
                                        height: 60,
                                        child: Image(image: ExactAssetImage('images/innovation_bridge_logo.png')),
                                      )
                                  ),

                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.all(7),
                                        width: 60 ,
                                        height: 60,
                                        child: Image(image: ExactAssetImage('images/sfsa_logo.png')),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child:  Text('developed by',
                                        style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 11,
                                      height: MediaQuery.of(context).size.height / 11,
                                      child: Image(image: ExactAssetImage('images/csir_logo.png')),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


