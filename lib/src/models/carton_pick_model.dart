class CartonPickModel {
  String? cartonID;
  String? storeID;
  String? storeDesc;
  String? user;

  CartonPickModel({this.cartonID, this.storeID, this.storeDesc, this.user});

  CartonPickModel.fromJson(Map<String, dynamic> json) {
    cartonID = json['cartonID'];
    storeID = json['storeID'];
    storeDesc = json['storeDesc'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartonID'] = this.cartonID;
    data['storeID'] = this.storeID;
    data['storeDesc'] = this.storeDesc;
    data['user'] = this.user;
    return data;
  }
}