class DependantsSendModel {
  DependantsSendModel({
      this.depenedents,});

  DependantsSendModel.fromJson(dynamic json) {
    if (json['depenedents'] != null) {
      depenedents = [];
      json['depenedents'].forEach((v) {
        depenedents?.add(Depenedents.fromJson(v));
      });
    }
  }
  List<Depenedents>? depenedents;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (depenedents != null) {
      map['depenedents'] = depenedents?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Depenedents {
  Depenedents({
      this.name, 
      this.email, 
      this.countryCode, 
      this.countryCodeLabel, 
      this.mobile, 
      this.relationship,});

  Depenedents.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    countryCodeLabel = json['country_code_label'];
    mobile = json['mobile'];
    relationship = json['relationship'];
  }
  String? name;
  String? email;
  String? countryCode;
  String? countryCodeLabel;
  String? mobile;
  String? relationship;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['country_code_label'] = countryCodeLabel;
    map['mobile'] = mobile;
    map['relationship'] = relationship;
    return map;
  }

}