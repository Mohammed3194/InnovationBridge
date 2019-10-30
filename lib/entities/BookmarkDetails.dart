class BookmarkDetails {
  List<Data> data;

  BookmarkDetails({this.data});

  BookmarkDetails.fromJson(Map<String, dynamic> json) {
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
  int referencedId;
  String type;
  String referencedUuid;
  String comment;
  String title;

  Data(
      {this.id,
        this.referencedId,
        this.type,
        this.referencedUuid,
        this.comment,
        this.title});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referencedId = json['referencedId'];
    type = json['type'];
    referencedUuid = json['referencedUuid'];
    comment = json['comment'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['referencedId'] = this.referencedId;
    data['type'] = this.type;
    data['referencedUuid'] = this.referencedUuid;
    data['comment'] = this.comment;
    data['title'] = this.title;
    return data;
  }
}