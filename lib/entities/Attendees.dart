class Attendees {
  List<Data> data;
  Pager pager;

  Attendees({this.data, this.pager});

  Attendees.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    pager = json['pager'] != null ? new Pager.fromJson(json['pager']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.pager != null) {
      data['pager'] = this.pager.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String uuid;
  String type;
  String name;
  String designation;
  String linkedIn;
  String organisation;
  String category;
  bool bookmarked;
  int bookmarkId;
  bool hasMeeting;

  Data(
      {this.id,
        this.uuid,
        this.type,
        this.name,
        this.designation,
        this.linkedIn,
        this.organisation,
        this.category,
        this.bookmarked,
        this.bookmarkId,
        this.hasMeeting});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    type = json['type'];
    name = json['name'];
    designation = json['designation'];
    linkedIn = json['linkedIn'];
    organisation = json['organisation'];
    category = json['category'];
    bookmarked = json['bookmarked'];
    bookmarkId = json['bookmarkId'];
    hasMeeting = json['hasMeeting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['type'] = this.type;
    data['name'] = this.name;
    data['designation'] = this.designation;
    data['linkedIn'] = this.linkedIn;
    data['organisation'] = this.organisation;
    data['category'] = this.category;
    data['bookmarked'] = this.bookmarked;
    data['bookmarkId'] = this.bookmarkId;
    data['hasMeeting'] = this.hasMeeting;
    return data;
  }
}

class Pager {
  int pageCount;
  int currentPage;

  Pager({this.pageCount, this.currentPage});

  Pager.fromJson(Map<String, dynamic> json) {
    pageCount = json['pageCount'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageCount'] = this.pageCount;
    data['currentPage'] = this.currentPage;
    return data;
  }
}