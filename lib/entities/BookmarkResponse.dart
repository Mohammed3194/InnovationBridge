class BookmarkResponse {
  Message message;

  BookmarkResponse({this.message});

  BookmarkResponse.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.toJson();
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