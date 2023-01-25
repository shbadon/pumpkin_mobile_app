class EnterMobileScreenSendModel {
  String contryCode;
  String countryLabel;
  String mobile;

  EnterMobileScreenSendModel({
    required this.contryCode,
    required this.countryLabel,
    required this.mobile,
  });

  Map<String, dynamic> toJson() => {
        "country_code": contryCode,
        "country_code_label": countryLabel,
        "mobile": mobile,
      };
}
