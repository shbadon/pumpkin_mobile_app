class VerifyMobileSendModel {
  String verificationCode;
  String countryCode;
  String countryCodeLabel;
  String mobileNumber;
  String email;

  VerifyMobileSendModel({
    required this.verificationCode,
    required this.countryCode,
    required this.countryCodeLabel,
    required this.mobileNumber,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "verification_code": verificationCode,
        "country": countryCode,
        "country_code_label": countryCodeLabel,
        "mobile": mobileNumber,
        "email": email
      };
}
