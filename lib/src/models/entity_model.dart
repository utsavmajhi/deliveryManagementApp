class EntityModel {
  String? entityType;
  String? entityID;
  String? entityDesc;

  EntityModel({this.entityType, this.entityID, this.entityDesc});

  EntityModel.fromJson(Map<String, dynamic> json) {
    entityType = json['entityType'];
    entityID = json['entityID'];
    entityDesc = json['entityDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityType'] = this.entityType;
    data['entityID'] = this.entityID;
    data['entityDesc'] = this.entityDesc;
    return data;
  }
}