class LoginAuthenticate {
  Message message;
  String token;
  Null pager;
  Null errors;

  LoginAuthenticate({this.message, this.token, this.pager, this.errors});

  LoginAuthenticate.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    token = json['token'];
    pager = json['pager'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    data['token'] = this.token;
    data['pager'] = this.pager;
    data['errors'] = this.errors;
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