class CartonModel {
  String? cartonID;
  String? bolID;
  String? pickID;

  CartonModel({this.cartonID, this.bolID,this.pickID});

  CartonModel.fromJson(Map<String, dynamic> json) {
    cartonID = json['cartonID'];
    bolID = json['bolID'];
    pickID = json['pickID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartonID'] = this.cartonID;
    data['bolID'] = this.bolID;
    data['pickID'] = this.pickID;
    return data;
  }
}