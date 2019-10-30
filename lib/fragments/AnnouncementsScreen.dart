import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:innovation_bridge/fragments/ProgramScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AnnouncementsScreen extends StatefulWidget {
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
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
              return Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 4),
                child: Container(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        children: <Widget>[
                          Text('Announcement Name', style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          )),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                            ),
                          )
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 10)),

                      Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[800]
                          )),

                      Padding(padding: EdgeInsets.only(top: 12)),

                      Divider(
                        color: Colors.black,
                        height: 2,
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
}
