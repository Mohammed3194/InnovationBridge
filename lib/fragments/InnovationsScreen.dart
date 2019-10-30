import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:innovation_bridge/detailScreens/InnovationDetailScreen.dart';
import 'package:innovation_bridge/fragments/ProgramScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InnovationsScreen extends StatefulWidget {
  @override
  _InnovationsScreenState createState() => _InnovationsScreenState();
}

class _InnovationsScreenState extends State<InnovationsScreen> {
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
  Widget build(BuildContext context) {
    return Container(
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
              return _listDetails();
            case ConnectivityResult.wifi:
              print("yes net");
              return _listDetails();
            default:
              return Center(child: Text("No Internet Connection! default"));
          }
        },
      ),
    );
  }

  FutureBuilder _listDetails(){
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
                                  builder: (context) => InnovationDetailScreen()
                              ));
                            },
                            child: Text('Innovation Title', style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                            )),
                          ),
                          Padding(padding: EdgeInsets.only(top: 6)),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('Industory Type Name', style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                )),
                              ),
                              Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('Hall 3, Stand XYZ', style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueAccent,
                                    ))
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 6)),

                          Column(
                            children: <Widget>[
                              Text('Exhibitor Name (Exhibitor Category)', style: TextStyle(
                                  fontSize: 8.5
                              )),
                            ],
                          ),

                          Padding(padding: EdgeInsets.only(top: 6)),

                          Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),),
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top: 6)),

                    Container(
                      color: Colors.blue,
                      width: double.infinity ,
                      height: MediaQuery.of(context).size.height / 4,
                      child: Image(image: ExactAssetImage('images/announcements.png')),
                    ),


                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width /13,
                            height: MediaQuery.of(context).size.height /13,
                            child: Image(image: ExactAssetImage('images/bookmark.png')),
                          ),
                          Padding(padding: EdgeInsets.only(left: 2)),
                          Container(
                            width: MediaQuery.of(context).size.width /13,
                            height: MediaQuery.of(context).size.height /13,
                            child: Image(image: ExactAssetImage('images/bookmark.png')),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color: Colors.black,
                      height: 2,
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

