class MapDetail {
  Data data;

  MapDetail({this.data});

  MapDetail.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int innovationId;
  int exhibitorId;
  int announcementCount;
  String mapUrl;
  String mapSizeX;
  String mapSizeY;
  Null positionX;
  Null positionY;

  Data(
      {this.innovationId,
        this.exhibitorId,
        this.announcementCount,
        this.mapUrl,
        this.mapSizeX,
        this.mapSizeY,
        this.positionX,
        this.positionY});

  Data.fromJson(Map<String, dynamic> json) {
    innovationId = json['innovation_id'];
    exhibitorId = json['exhibitor_id'];
    announcementCount = json['announcementCount'];
    mapUrl = json['mapUrl'];
    mapSizeX = json['map_size_x'];
    mapSizeY = json['map_size_y'];
    positionX = json['position_x'];
    positionY = json['position_y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['innovation_id'] = this.innovationId;
    data['exhibitor_id'] = this.exhibitorId;
    data['announcementCount'] = this.announcementCount;
    data['mapUrl'] = this.mapUrl;
    data['map_size_x'] = this.mapSizeX;
    data['map_size_y'] = this.mapSizeY;
    data['position_x'] = this.positionX;
    data['position_y'] = this.positionY;
    return data;
  }
}