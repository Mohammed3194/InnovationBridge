import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class TermsConditionsScreen extends StatefulWidget {
  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<TermsConditionsScreen> {
  final GlobalKey<_ChildPageState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parent")),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                alignment: Alignment.center,
                child: RaisedButton(
                  child: Text("Call method in child"),
                  onPressed: () => _key.currentState.methodInChild(), // calls method in child
                ),
              ),
            ),
            Text("Above = Parent\nBelow = Child"),
            Expanded(
              child: ChildPage(key: _key, function: methodInParent),
            ),
          ],
        ),
      ),
    );
  }

  methodInParent() => Fluttertoast.showToast(msg: "Method called in parent", gravity: ToastGravity.CENTER);
}

class ChildPage extends StatefulWidget {
  final Function function;

  ChildPage({Key key, this.function}) : super(key: key);

  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      width: double.infinity,
      alignment: Alignment.center,
      child: RaisedButton(
        child: Text("Call method in parent"),
        onPressed: () => widget.function(), // calls method in parent
      ),
    );
  }

  methodInChild() => Fluttertoast.showToast(msg: "Method called in child");
}

/*class TermsConditionsScreen extends StatefulWidget {
  @override
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                style: TextStyle(
                    fontSize: 14
                )),
          )
      ),
    );
  }
}*/
