class CartonHistory {
  String? user;
  String? dateTimeStamp;
  String? location;
  String? eventType;
  String? cartonID;

  CartonHistory(
      {this.user,
        this.dateTimeStamp,
        this.location,
        this.eventType,
        this.cartonID});

  CartonHistory.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    dateTimeStamp = json['dateTimeStamp'];
    location = json['location'];
    eventType = json['eventType'];
    cartonID = json['cartonID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['dateTimeStamp'] = this.dateTimeStamp;
    data['location'] = this.location;
    data['eventType'] = this.eventType;
    data['cartonID'] = this.cartonID;
    return data;
  }
}