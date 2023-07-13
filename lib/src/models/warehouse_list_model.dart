class WarehouseModel {
  String? storeId;
  String? storeDesc;

  WarehouseModel({this.storeId, this.storeDesc});

  WarehouseModel.fromJson(Map<String, dynamic> json) {
    storeId = json['storeID'];
    storeDesc = json['storeDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeID'] = this.storeId;
    data['storeDesc'] = this.storeDesc;
    return data;
  }
}