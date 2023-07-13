class VehicleModel {
  String? typeOfVehicle;
  String? vehicleID;
  String? vehicleDesc;

  VehicleModel({this.typeOfVehicle, this.vehicleID, this.vehicleDesc});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    typeOfVehicle = json['typeOfVehicle'];
    vehicleID = json['vehicleID'];
    vehicleDesc = json['vehicleDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeOfVehicle'] = this.typeOfVehicle;
    data['vehicleID'] = this.vehicleID;
    data['vehicleDesc'] = this.vehicleDesc;
    return data;
  }
}