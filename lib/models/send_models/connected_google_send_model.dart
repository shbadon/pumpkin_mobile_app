class ConnectedGoogleSendModel {
  ConnectedGoogleSendModel({
      this.manualLoginAccessToken, 
      this.idToken, 
      this.accessToken,});

  ConnectedGoogleSendModel.fromJson(dynamic json) {
    manualLoginAccessToken = json['manual_login_access_token'];
    idToken = json['idToken'];
    accessToken = json['access_token'];
  }
  String? manualLoginAccessToken;
  String? idToken;
  String? accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['manual_login_access_token'] = manualLoginAccessToken;
    map['idToken'] = idToken;
    map['access_token'] = accessToken;
    return map;
  }

}