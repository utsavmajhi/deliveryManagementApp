class CartonModel {
  String? cartonID;
  String? bolID;
  String? pickID;
  bool scanned = false; // Change from bool? to bool

  CartonModel({this.cartonID, this.bolID, this.pickID, bool? scanned})
      : this.scanned = scanned ?? false;

  CartonModel.fromJson(Map<String, dynamic> json) {
    cartonID = json['cartonID'];
    bolID = json['bolID'];
    pickID = json['pickID'];
    scanned = json['scanned'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartonID'] = this.cartonID;
    data['bolID'] = this.bolID;
    data['pickID'] = this.pickID;
    data['scanned'] = this.scanned;
    return data;
  }
}
