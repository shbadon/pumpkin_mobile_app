// This model is used for the Login API , this is the response model for the login API

class LoginScreenResponseModel {
  String? accessToken;
  String? refreshToken;

  LoginScreenResponseModel({this.accessToken, this.refreshToken});

  factory LoginScreenResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginScreenResponseModel(
        accessToken: json['access_token'],
        refreshToken: json["refresh_token"],
      );
}
