class CartonModel {
  String? cartonID;
  String? bolID;

  CartonModel({this.cartonID, this.bolID});

  CartonModel.fromJson(Map<String, dynamic> json) {
    cartonID = json['cartonID'];
    bolID = json['bolID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartonID'] = this.cartonID;
    data['bolID'] = this.bolID;
    return data;
  }
}