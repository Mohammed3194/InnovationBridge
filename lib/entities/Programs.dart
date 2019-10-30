class Programs {
  int code;
  String message;
  List<Data> data;

  Programs({this.code, this.message, this.data});

  Programs.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String uuid;
  String title;
  String date;
  String startTime;
  String endTime;
  List<String> location;
  String details;
  int parallelActivitiesCount;
  List<ParallelActivities> parallelActivities;
  bool bookmarked;
  int bookmarkId;

  Data(
      {this.id,
        this.uuid,
        this.title,
        this.date,
        this.startTime,
        this.endTime,
        this.location,
        this.details,
        this.parallelActivitiesCount,
        this.parallelActivities,
        this.bookmarked,
      this.bookmarkId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'].cast<String>();
    details = json['details'];
    parallelActivitiesCount = json['parallelActivitiesCount'];
    if (json['parallelActivities'] != null) {
      parallelActivities = new List<ParallelActivities>();
      json['parallelActivities'].forEach((v) {
        parallelActivities.add(new ParallelActivities.fromJson(v));
      });
    }
    bookmarked = json['bookmarked'];
    bookmarkId = json['bookmarkId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['location'] = this.location;
    data['details'] = this.details;
    data['parallelActivitiesCount'] = this.parallelActivitiesCount;
    if (this.parallelActivities != null) {
      data['parallelActivities'] =
          this.parallelActivities.map((v) => v.toJson()).toList();
    }
    data['bookmarked'] = this.bookmarked;
    data['bookmarkId'] = this.bookmarkId;
    return data;
  }
}

class ParallelActivities {
  int id;
  String uuid;
  String title;
  String date;
  String startTime;
  String endTime;
  String details;
  String location;
  bool bookmarked;
  int bookmarkId;

  ParallelActivities(
      {this.id,
        this.uuid,
        this.title,
        this.date,
        this.startTime,
        this.endTime,
        this.details,
        this.location,
        this.bookmarked,
      this.bookmarkId});

  ParallelActivities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    details = json['details'];
    location = json['location'];
    bookmarked = json['bookmarked'];
    bookmarkId = json['bookmarkId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['details'] = this.details;
    data['location'] = this.location;
    data['bookmarked'] = this.bookmarked;
    data['bookmarkId'] = this.bookmarkId;
    return data;
  }
}