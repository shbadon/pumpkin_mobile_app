class TwoFactorEnableResponseModel {
  TwoFactorEnableResponseModel({
      this.secret, 
      this.otpauthUrl,});

  TwoFactorEnableResponseModel.fromJson(dynamic json) {
    secret = json['secret'];
    otpauthUrl = json['otpauthUrl'];
  }
  String? secret;
  String? otpauthUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['secret'] = secret;
    map['otpauthUrl'] = otpauthUrl;
    return map;
  }

}