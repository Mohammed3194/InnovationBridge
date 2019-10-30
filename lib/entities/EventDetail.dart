class EventDetail {
  bool isActive;
  String name;
  String startDate;
  String endDate;

  EventDetail({this.isActive, this.name, this.startDate, this.endDate});

  EventDetail.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}