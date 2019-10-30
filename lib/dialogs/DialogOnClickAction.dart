import 'package:flutter/material.dart';
import 'package:innovation_bridge/LoginScreen.dart';
import 'package:innovation_bridge/utils/Utils.dart';

class DialogOnClickAction extends StatefulWidget {

  final String dialogTitle;
  final String errorMessage;
  DialogOnClickAction({@required this.dialogTitle, this.errorMessage});

  @override
  State<StatefulWidget> createState() => DialogOnClickActionState();
}

class DialogOnClickActionState extends State<DialogOnClickAction>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
            margin: EdgeInsets.all(60.0),
            padding: EdgeInsets.all(10),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 50.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(widget.dialogTitle, style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black
                    )),
                  ),
                ),

                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(widget.errorMessage,
                        softWrap: true,
                        style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                    )),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 10)),

                SizedBox(
                  width: 80.0,
                  height: 30.0,
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('OK', style: TextStyle(
                        color: Colors.white
                    )),
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),

                Padding(padding: EdgeInsets.only(bottom: 10))
              ],
            )
        ),
      ),
    );
  }
}