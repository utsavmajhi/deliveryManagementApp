class CartonPickModel {
  String? cartonID;
  String? vehicleID;
  String? user;
  String? pickLoc;
  String? bolID;

  CartonPickModel({this.cartonID, this.vehicleID, this.user, this.pickLoc, this.bolID});

  CartonPickModel.fromJson(Map<String, dynamic> json) {
    cartonID = json['cartonID'];
    bolID = json['bolID'];
    vehicleID = json['vehicleID'];
    user = json['user'];
    pickLoc = json['pickLoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartonID'] = this.cartonID;
    data['bolID'] = this.bolID;
    data['vehicleID'] = this.vehicleID;
    data['user'] = this.user;
    data['pickLoc'] = this.pickLoc;
    return data;
  }
}