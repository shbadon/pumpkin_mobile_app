class ConnectedFacebookSendModel {
  ConnectedFacebookSendModel({
      this.manualLoginAccessToken, 
      this.accessToken, 
      this.userId,});

  ConnectedFacebookSendModel.fromJson(dynamic json) {
    manualLoginAccessToken = json['manual_login_access_token'];
    accessToken = json['access_token'];
    userId = json['user_id'];
  }
  String? manualLoginAccessToken;
  String? accessToken;
  String? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['manual_login_access_token'] = manualLoginAccessToken;
    map['access_token'] = accessToken;
    map['user_id'] = userId;
    return map;
  }

}