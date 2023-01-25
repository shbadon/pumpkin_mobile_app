class LeadDependentsResponseModel {
  List<OneDependentModel>? dependentsList;

  LeadDependentsResponseModel({this.dependentsList});

  Map<String, dynamic> toJson() => {
        "depenedents": dependentsList,
      };
}

class OneDependentModel {
  String? name;
  String? email;
  String? countryCode;
  String? countryLabel;
  String? mobile;
  String? relationship;

  OneDependentModel(
      {this.name,
      this.email,
      this.countryCode,
      this.countryLabel,
      this.mobile,
      this.relationship});

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "country_code": countryCode,
        "country_code_label": countryLabel,
        "mobile": mobile,
        "relationship": relationship,
      };
}
