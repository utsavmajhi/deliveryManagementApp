class CartonResModel {
  List<Cartons>? cartons;
  int? count;
  bool? isBOL;
  bool? isValidID;

  CartonResModel({this.cartons, this.count, this.isBOL, this.isValidID});

  CartonResModel.fromJson(Map<String, dynamic> json) {
    if (json['cartons'] != null) {
      cartons = <Cartons>[];
      json['cartons'].forEach((v) {
        cartons!.add(new Cartons.fromJson(v));
      });
    }
    count = json['count'];
    isBOL = json['isBOL'];
    isValidID = json['isValidID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartons != null) {
      data['cartons'] = this.cartons!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['isBOL'] = this.isBOL;
    data['isValidID'] = this.isValidID;
    return data;
  }
}

class Cartons {
  String? cartonID;
  String? bolID;

  Cartons({this.cartonID, this.bolID});

  Cartons.fromJson(Map<String, dynamic> json) {
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