class UserInfoSendModel {
  UserInfoSendModel({
      this.firstName, 
      this.lastName, 
      this.dob, 
      this.gender, 
      this.profileMsg, 
      this.companyName, 
      this.agencyName, 
      this.designation,});

  UserInfoSendModel.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    gender = json['gender'];
    profileMsg = json['profile_msg'];
    companyName = json['company_name'];
    agencyName = json['agency_name'];
    designation = json['designation'];
  }
  String? firstName;
  String? lastName;
  String? dob;
  String? gender;
  String? profileMsg;
  String? companyName;
  String? agencyName;
  String? designation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['dob'] = dob;
    map['gender'] = gender;
    map['profile_msg'] = profileMsg;
    map['company_name'] = companyName;
    map['agency_name'] = agencyName;
    map['designation'] = designation;
    return map;
  }

}