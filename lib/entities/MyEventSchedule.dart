class MyEventSchedule {
  List<Data> data;

  MyEventSchedule({this.data});

  MyEventSchedule.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  int inviteId;
  String type;
  String date;
  String startTime;
  String endTime;
  String title;
  String comment;
  String location;
  String meetingStatus;
  String attendanceStatus;
  bool isOrganiser;
  Null organiserName;
  Null organiserType;
  String attendeeName;
  String attendeeType;
  int seatAvailability;

  Data(
      {this.id,
        this.inviteId,
        this.type,
        this.date,
        this.startTime,
        this.endTime,
        this.title,
        this.comment,
        this.location,
        this.meetingStatus,
        this.attendanceStatus,
        this.isOrganiser,
        this.organiserName,
        this.organiserType,
        this.attendeeName,
        this.attendeeType,
        this.seatAvailability});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inviteId = json['inviteId'];
    type = json['type'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    title = json['title'];
    comment = json['comment'];
    location = json['location'];
    meetingStatus = json['meetingStatus'];
    attendanceStatus = json['attendanceStatus'];
    isOrganiser = json['isOrganiser'];
    organiserName = json['organiserName'];
    organiserType = json['organiserType'];
    attendeeName = json['attendeeName'];
    attendeeType = json['attendeeType'];
    seatAvailability = json['seatAvailability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['inviteId'] = this.inviteId;
    data['type'] = this.type;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['title'] = this.title;
    data['comment'] = this.comment;
    data['location'] = this.location;
    data['meetingStatus'] = this.meetingStatus;
    data['attendanceStatus'] = this.attendanceStatus;
    data['isOrganiser'] = this.isOrganiser;
    data['organiserName'] = this.organiserName;
    data['organiserType'] = this.organiserType;
    data['attendeeName'] = this.attendeeName;
    data['attendeeType'] = this.attendeeType;
    data['seatAvailability'] = this.seatAvailability;
    return data;
  }
}