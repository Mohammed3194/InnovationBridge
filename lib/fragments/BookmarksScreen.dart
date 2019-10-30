import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:innovation_bridge/fragments/ProgramScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
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
                      GestureDetector(
                        onTap: (){

                        },
                        child: Text('Name / Title', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        )),
                      ),
                      Padding(padding: EdgeInsets.only(top: 6)),

                      Text('Type', style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      )),

                      Text('Comment', style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      )),

                      Padding(padding: EdgeInsets.only(top: 6)),

                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width /13,
                            height: MediaQuery.of(context).size.height /13,
                            child: Image(image: ExactAssetImage('images/bookmark.png')),
                          ),
                          Text('Remove',style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ) )
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 10)),

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
