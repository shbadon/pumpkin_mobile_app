class LoginScreenSendModel {
  String email; //This firld csn be both email and the phoe number of the user
  String passowrd;
  String twoFactorAuthCode;

  LoginScreenSendModel(
      {required this.email,
      required this.passowrd,
      required this.twoFactorAuthCode});

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": passowrd,
        "twoFactorAuthenticationCode": twoFactorAuthCode
      };
}
