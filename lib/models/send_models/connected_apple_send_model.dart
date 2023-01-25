class ConnectedAppleSendModel {
  ConnectedAppleSendModel({
      this.manualLoginAccessToken, 
      this.provider, 
      this.identityToken, 
      this.authorizationCode,
      this.givenName,
  });

  ConnectedAppleSendModel.fromJson(dynamic json) {
    manualLoginAccessToken = json['manual_login_access_token'];
    provider = json['provider'];
    identityToken = json['identityToken'];
    authorizationCode = json['authorizationCode'];
    authorizationCode = json['givenName'];
  }
  String? manualLoginAccessToken;
  String? provider;
  String? identityToken;
  String? authorizationCode;
  String? givenName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['manual_login_access_token'] = manualLoginAccessToken;
    map['provider'] = provider;
    map['identityToken'] = identityToken;
    map['authorizationCode'] = authorizationCode;
    map['givenName'] = givenName;
    return map;
  }

}