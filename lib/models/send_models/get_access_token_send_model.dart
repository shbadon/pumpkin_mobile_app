class GetAccessTokenSendModel {
  String? refreshToken;
  GetAccessTokenSendModel({this.refreshToken});
  Map<String, dynamic> toJson() => {
        "refresh_token": refreshToken,
      };
}
