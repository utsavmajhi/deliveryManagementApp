class LocModel {
  String? locType;
  String? locID;
  String? locDesc;

  LocModel({this.locType, this.locID, this.locDesc});

  LocModel.fromJson(Map<String, dynamic> json) {
    locType = json['locType'];
    locID = json['locID'];
    locDesc = json['locDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locType'] = this.locType;
    data['locID'] = this.locID;
    data['locDesc'] = this.locDesc;
    return data;
  }
}