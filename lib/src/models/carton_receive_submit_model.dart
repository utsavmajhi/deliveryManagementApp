class CartonReceiveSubmitModel {
  String? pickID;
  String? cartonID;
  String? receivedBy;
  String? receivedLoc;

  CartonReceiveSubmitModel(
      {this.pickID, this.cartonID, this.receivedBy, this.receivedLoc});

  CartonReceiveSubmitModel.fromJson(Map<String, dynamic> json) {
    pickID = json['pickID'];
    cartonID = json['cartonID'];
    receivedBy = json['receivedBy'];
    receivedLoc = json['receivedLoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pickID'] = this.pickID;
    data['cartonID'] = this.cartonID;
    data['receivedBy'] = this.receivedBy;
    data['receivedLoc'] = this.receivedLoc;
    return data;
  }
}