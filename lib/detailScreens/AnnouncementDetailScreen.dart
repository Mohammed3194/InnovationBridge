import 'package:flutter/material.dart';
import 'package:innovation_bridge/entities/Announcements.dart';

class AnnouncementDetailScreen extends StatefulWidget {

  Data announcement;
  AnnouncementDetailScreen({@required this.announcement});

  @override
  _AnnouncementDetailScreenState createState() => _AnnouncementDetailScreenState(announcement);
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {

  Data announcement;
  _AnnouncementDetailScreenState(this.announcement);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(announcement.title,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                    )),

                Padding(padding: EdgeInsets.only(top: 10)),

                Text(announcement.detail != null ? announcement.detail : "", style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ))
              ],
            ),
          )
        ),
      ),
    );
  }
}
