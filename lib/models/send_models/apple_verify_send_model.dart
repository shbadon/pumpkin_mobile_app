class AppleVerifySendModel {
  AppleVerifySendModel({
      this.provider = "apple",
      this.identityToken, 
      this.authorizationCode,
      this.givenName,
  });

  AppleVerifySendModel.fromJson(dynamic json) {
    provider = json['provider'];
    identityToken = json['identityToken'];
    authorizationCode = json['authorizationCode'];
    givenName = json['givenName'];
  }

  String? provider;
  String? identityToken;
  String? authorizationCode;
  String? givenName;

AppleVerifySendModel copyWith({  String? provider,
  String? identityToken,
  String? authorizationCode,
  String? user,
}) => AppleVerifySendModel(  provider: provider ?? this.provider,
  identityToken: identityToken ?? this.identityToken,
  authorizationCode: authorizationCode ?? this.authorizationCode,
  givenName: givenName ?? this.givenName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['provider'] = provider;
    map['identityToken'] = identityToken;
    map['authorizationCode'] = authorizationCode;
    map['givenName'] = givenName;
    return map;
  }

}