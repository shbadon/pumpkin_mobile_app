class AddLeadBasicDetailsSendModel {
  AddLeadBasicDetailsSendModel({
      this.firstName, 
      this.lastName, 
      this.genderId, 
      this.tags, 
      this.dob, 
      this.zipCode, 
      this.address1, 
      this.address2, 
      this.countryId, 
      this.remarks,});

  AddLeadBasicDetailsSendModel.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    genderId = json['gender_id'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    dob = json['dob'];
    zipCode = json['zip_code'];
    address1 = json['address1'];
    address2 = json['address2'];
    countryId = json['country_id'];
    remarks = json['remarks'];
  }
  String? firstName;
  String? lastName;
  String? genderId;
  List<String>? tags;
  String? dob;
  String? zipCode;
  String? address1;
  String? address2;
  String? countryId;
  String? remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['gender_id'] = genderId;
    map['tags'] = tags;
    map['dob'] = dob;
    map['zip_code'] = zipCode;
    map['address1'] = address1;
    map['address2'] = address2;
    map['country_id'] = countryId;
    map['remarks'] = remarks;
    return map;
  }

}