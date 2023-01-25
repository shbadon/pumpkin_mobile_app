class VerifyChangeMobileSendModel {
  String verificationCode;
  String countryCode;
  String countryCodeLabel;
  String mobileNumber;


  VerifyChangeMobileSendModel({
    required this.verificationCode,
    required this.countryCode,
    required this.countryCodeLabel,
    required this.mobileNumber,

  });

  Map<String, dynamic> toJson() => {
        "verification_code": verificationCode,
        "country": countryCode,
        "country_code_label": countryCodeLabel,
        "mobile": mobileNumber,

      };
}
