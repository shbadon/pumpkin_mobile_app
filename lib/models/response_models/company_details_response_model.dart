class CompanyDetailsResponseModel {
  int? id;
  String? companyName;
  String? companyEmail;
  String? phone;
  String? countryCode;
  String? countryCodeLabel;
  String? companyAddress;
  String? terms;
  String? policy;
  String? website;
  String? logo;

  CompanyDetailsResponseModel(
      {this.id,
      this.companyName,
      this.companyEmail,
      this.phone,
      this.countryCode,
      this.countryCodeLabel,
      this.companyAddress,
      this.terms,
      this.policy,
      this.website,
      this.logo});

  factory CompanyDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsResponseModel(
      id: json['id'],
      companyName: json['company_name'],
      companyEmail: json['company_email'],
      phone: json['phone'],
      countryCode: json['country_code'],
      countryCodeLabel: json['country_code_label'],
      companyAddress: json['company_address'],
      terms: json['terms'],
      policy: json['policy'],
      website: json['website'],
      logo: json['logo'],
    );
  }
}
