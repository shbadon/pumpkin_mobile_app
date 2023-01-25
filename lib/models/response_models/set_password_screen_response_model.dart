class SetPasswordScreenResponseModel {
  String? email;
  String? firstName;
  String? lastName;
  String? mobileNumbers;
  String? countryCode;
  String? accessToken;
  String? refreshToken;
  SetPasswordScreenResponseModel(
      {this.email,
      this.firstName,
      this.lastName,
      this.mobileNumbers,
      this.countryCode,
      this.accessToken,
      this.refreshToken});

  factory SetPasswordScreenResponseModel.fromJson(Map<String, dynamic> json) =>
      SetPasswordScreenResponseModel(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobileNumbers: json["mobile"],
        countryCode: json["country_code"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );
}
