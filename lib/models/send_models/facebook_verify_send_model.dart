class FacebookVerifySendModel {
  FacebookVerifySendModel({
      this.accessToken, 
      this.userId,});

  FacebookVerifySendModel.fromJson(dynamic json) {
    accessToken = json['access_token'];
    userId = json['user_id'];
  }
  String? accessToken;
  String? userId;
FacebookVerifySendModel copyWith({  String? accessToken,
  String? userId,
}) => FacebookVerifySendModel(  accessToken: accessToken ?? this.accessToken,
  userId: userId ?? this.userId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['user_id'] = userId;
    return map;
  }

}