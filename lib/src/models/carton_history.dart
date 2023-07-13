class CartonHistory {
  String? user;
  String? dateTimeStamp;
  String? storeDesc;
  String? eventType;
  String? storeID;
  String? cartonID;

  CartonHistory(
      {this.user,
        this.dateTimeStamp,
        this.storeDesc,
        this.eventType,
        this.storeID,
        this.cartonID});

  CartonHistory.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    dateTimeStamp = json['dateTimeStamp'];
    storeDesc = json['storeDesc'];
    eventType = json['eventType'];
    storeID = json['storeID'];
    cartonID = json['cartonID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['dateTimeStamp'] = this.dateTimeStamp;
    data['storeDesc'] = this.storeDesc;
    data['eventType'] = this.eventType;
    data['storeID'] = this.storeID;
    data['cartonID'] = this.cartonID;
    return data;
  }
}