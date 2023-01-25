class FacebookConnectSendModel {
  String? manualLoginAccessToken;
  String? accessToken;
  String? userId;

  FacebookConnectSendModel({
    this.manualLoginAccessToken,
    this.accessToken,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
        "manual_login_access_token": manualLoginAccessToken,
        "access_token": accessToken,
        "user_id": userId,
      };
}
