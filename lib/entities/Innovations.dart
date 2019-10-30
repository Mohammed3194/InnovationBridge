class Innovations {
  List<Data> data;

  Innovations({this.data});

  Innovations.fromJson(Map<String, dynamic> json) {
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
  String uuid;
  String title;
  Location location;
  String description;
  String image;
  String imageThumb;
  bool hasMeeting;
  bool bookmarked;
  int bookmarkId;
  List<String> industries;
  String exhibitorName;
  String exhibitorCategory;

  Data(
      {this.id,
        this.uuid,
        this.title,
        this.location,
        this.description,
        this.image,
        this.imageThumb,
        this.hasMeeting,
        this.bookmarked,
        this.bookmarkId,
        this.industries,
        this.exhibitorName,
        this.exhibitorCategory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    description = json['description'];
    image = json['image'];
    imageThumb = json['image_thumb'];
    hasMeeting = json['hasMeeting'];
    bookmarked = json['bookmarked'];
    bookmarkId = json['bookmarkId'];
    industries = json['industries'].cast<String>();
    exhibitorName = json['exhibitor_name'];
    exhibitorCategory = json['exhibitor_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['description'] = this.description;
    data['image'] = this.image;
    data['image_thumb'] = this.imageThumb;
    data['hasMeeting'] = this.hasMeeting;
    data['bookmarked'] = this.bookmarked;
    data['bookmarkId'] = this.bookmarkId;
    data['industries'] = this.industries;
    data['exhibitor_name'] = this.exhibitorName;
    data['exhibitor_category'] = this.exhibitorCategory;
    return data;
  }
}

class Location {
  int id;
  String title;

  Location({this.id, this.title});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}