class GetAccessTokenResponseModel {
  String? accessToken;
  String? refreshToken;

  GetAccessTokenResponseModel({this.accessToken, this.refreshToken});

  factory GetAccessTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAccessTokenResponseModel(
        accessToken: json['access_token'],
        refreshToken: json["refresh_token"],
      );
}
