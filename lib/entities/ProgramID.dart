class ProgramID {
  Message message;
  Data data;

  ProgramID({this.message, this.data});

  ProgramID.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Message {
  String status;
  String message;

  Message({this.status, this.message});

  Message.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  String uuid;
  Null parentActivityId;
  String title;
  String date;
  String startTime;
  String endTime;
  List<String> location;
  String details;
  List<Presenters> presenters;
  int parallelActivitiesCount;
  List<ParallelActivities> parallelActivities;
  bool bookmarked;

  Data(
      {this.id,
        this.uuid,
        this.parentActivityId,
        this.title,
        this.date,
        this.startTime,
        this.endTime,
        this.location,
        this.details,
        this.presenters,
        this.parallelActivitiesCount,
        this.parallelActivities,
        this.bookmarked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    parentActivityId = json['parentActivityId'];
    title = json['title'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'].cast<String>();
    details = json['details'];
    if (json['presenters'] != null) {
      presenters = new List<Presenters>();
      json['presenters'].forEach((v) {
        presenters.add(new Presenters.fromJson(v));
      });
    }
    parallelActivitiesCount = json['parallelActivitiesCount'];
    if (json['parallelActivities'] != null) {
      parallelActivities = new List<ParallelActivities>();
      json['parallelActivities'].forEach((v) {
        parallelActivities.add(new ParallelActivities.fromJson(v));
      });
    }
    bookmarked = json['bookmarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['parentActivityId'] = this.parentActivityId;
    data['title'] = this.title;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['location'] = this.location;
    data['details'] = this.details;
    if (this.presenters != null) {
      data['presenters'] = this.presenters.map((v) => v.toJson()).toList();
    }
    data['parallelActivitiesCount'] = this.parallelActivitiesCount;
    if (this.parallelActivities != null) {
      data['parallelActivities'] =
          this.parallelActivities.map((v) => v.toJson()).toList();
    }
    data['bookmarked'] = this.bookmarked;
    return data;
  }
}

class Presenters {
  String name;
  String startTime;
  String endTime;
  String description;

  Presenters({this.name, this.startTime, this.endTime, this.description});

  Presenters.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['description'] = this.description;
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