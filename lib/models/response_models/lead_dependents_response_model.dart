class LeadDependentsResponseModel {
  List<OneDependentModel>? dependentsList;

  LeadDependentsResponseModel({this.dependentsList});

  factory LeadDependentsResponseModel.fromJson(Map<String, dynamic> json) =>
      LeadDependentsResponseModel(
        dependentsList: List<OneDependentModel>.from(json['dependants']
            .map((data) => OneDependentModel.fromJson(data))),
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (dependentsList != null) {
      map['depenedents'] = dependentsList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

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

  factory OneDependentModel.fromJson(Map<String, dynamic> json) =>
      OneDependentModel(
        name: json['name'],
        email: json['email'],
        countryCode: json["country_code"],
        countryLabel: json["country_code_label"],
        mobile: json["mobile"],
        relationship: json["relationship"],
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['country_code_label'] = countryLabel;
    map['mobile'] = mobile;
    map['relationship'] = relationship;
    return map;
  }
}
