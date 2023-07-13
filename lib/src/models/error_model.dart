class ErrorModel {
  String? errorMsg;
  String? errCode;

  ErrorModel({this.errorMsg, this.errCode});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    errorMsg = json['errorMsg'];
    errCode = json['errCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMsg'] = this.errorMsg;
    data['errCode'] = this.errCode;
    return data;
  }
}