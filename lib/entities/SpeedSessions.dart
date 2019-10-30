class SpeedSessions {
  List<Data> data;

  SpeedSessions({this.data});

  SpeedSessions.fromJson(Map<String, dynamic> json) {
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
  String type;
  String title;
  String comment;
  String location;
  String date;
  String startTime;
  String endTime;
  int seatAvailability;
  String availability;
  bool attending;

  Data(
      {this.id,
        this.type,
        this.title,
        this.comment,
        this.location,
        this.date,
        this.startTime,
        this.endTime,
        this.seatAvailability,
        this.availability,
        this.attending});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    comment = json['comment'];
    location = json['location'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    seatAvailability = json['seatAvailability'];
    availability = json['availability'];
    attending = json['attending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['comment'] = this.comment;
    data['location'] = this.location;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['seatAvailability'] = this.seatAvailability;
    data['availability'] = this.availability;
    data['attending'] = this.attending;
    return data;
  }
}