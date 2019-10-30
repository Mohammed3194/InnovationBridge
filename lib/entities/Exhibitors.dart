class Exhibitors {
  List<Data> data;

  Exhibitors({this.data});

  Exhibitors.fromJson(Map<String, dynamic> json) {
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
  String category;
  Location location;
  String description;
  String image;
  String imageThumb;
  String backgroundImage;
  bool hasMeeting;
  bool bookmarked;
  int bookmarkId;
  List<Innovations> innovations;

  Data(
      {this.id,
        this.uuid,
        this.title,
        this.category,
        this.location,
        this.description,
        this.image,
        this.imageThumb,
        this.backgroundImage,
        this.hasMeeting,
        this.bookmarked,
        this.bookmarkId,
        this.innovations});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    category = json['category'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    description = json['description'];
    image = json['image'];
    imageThumb = json['image_thumb'];
    backgroundImage = json['background_image'];
    hasMeeting = json['hasMeeting'];
    bookmarked = json['bookmarked'];
    bookmarkId = json['bookmarkId'];
    if (json['innovations'] != null) {
      innovations = new List<Innovations>();
      json['innovations'].forEach((v) {
        innovations.add(new Innovations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['category'] = this.category;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['description'] = this.description;
    data['image'] = this.image;
    data['image_thumb'] = this.imageThumb;
    data['background_image'] = this.backgroundImage;
    data['hasMeeting'] = this.hasMeeting;
    data['bookmarked'] = this.bookmarked;
    data['bookmarkId'] = this.bookmarkId;
    if (this.innovations != null) {
      data['innovations'] = this.innovations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Innovations {
  int id;
  String title;

  Innovations({this.id, this.title});

  Innovations.fromJson(Map<String, dynamic> json) {
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