class CartonPickModel {
  String? cartonID;
  String? vehicleID;
  String? user;
  String? pickLoc;

  CartonPickModel({this.cartonID, this.vehicleID, this.user, this.pickLoc});

  CartonPickModel.fromJson(Map<String, dynamic> json) {
    cartonID = json['cartonID'];
    vehicleID = json['vehicleID'];
    user = json['user'];
    pickLoc = json['pickLoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartonID'] = this.cartonID;
    data['vehicleID'] = this.vehicleID;
    data['user'] = this.user;
    data['pickLoc'] = this.pickLoc;
    return data;
  }
}