class VerifyEmailSendModel {
  String verificationCode;
  String email;
  String userType;

  VerifyEmailSendModel({
    required this.verificationCode,
    required this.email,
    this.userType = 'agent',
  });

  Map<String, dynamic> toJson() => {
        "verification_code": verificationCode,
        "email": email,
        "user_type": userType,
      };
}
