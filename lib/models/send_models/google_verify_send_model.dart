class GoogleVerifySendModel {
  GoogleVerifySendModel({
    this.idToken,
    this.accessToken,
    this.type,
  });

  GoogleVerifySendModel.fromJson(dynamic json) {
    idToken = json['idToken'];
    accessToken = json['access_token'];
    type = json['type'];
  }
  String? idToken;
  String? accessToken;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idToken'] = idToken;
    map['access_token'] = accessToken;
    return map;
  }
}
