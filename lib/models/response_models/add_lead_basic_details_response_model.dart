class AddLeadBasicDetailsResponseModel {
  AddLeadBasicDetailsResponseModel({
      this.message, 
      this.showData,});

  AddLeadBasicDetailsResponseModel.fromJson(dynamic json) {
    message = json['message'];
    showData = json['showData'] != null ? ShowData.fromJson(json['showData']) : null;
  }
  String? message;
  ShowData? showData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (showData != null) {
      map['showData'] = showData?.toJson();
    }
    return map;
  }

}

class ShowData {
  ShowData({
      this.firstName, 
      this.lastName, 
      this.dob, 
      this.genderId, 
      this.zipCode, 
      this.tags, 
      this.address1, 
      this.address2, 
      this.countryId, 
      this.remarks, 
      this.userId, 
      this.createdAt, 
      this.createdUserId, 
      this.status, 
      this.disable, 
      this.leadStage, 
      this.photo, 
      this.mobile, 
      this.countryCode, 
      this.countryCodeLabel, 
      this.wholeNumber, 
      this.email, 
      this.socialIds, 
      this.educationId, 
      this.occupation, 
      this.annualIncome, 
      this.maritalStatusId, 
      this.preferredLanguageId, 
      this.preferredLanguageOther, 
      this.countryResidentId, 
      this.citizenshipId, 
      this.citizenshipOther, 
      this.riskprofileId, 
      this.isNomination, 
      this.canWill, 
      this.isLpa, 
      this.dependants, 
      this.updatedUserId, 
      this.updatedAt, 
      this.disabledAt, 
      this.id,});

  ShowData.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    genderId = json['gender_id'];
    zipCode = json['zip_code'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    address1 = json['address1'];
    address2 = json['address2'];
    countryId = json['country_id'];
    remarks = json['remarks'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    createdUserId = json['created_user_id'];
    status = json['status'];
    disable = json['disable'];
    leadStage = json['lead_stage'];
    photo = json['photo'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    countryCodeLabel = json['country_code_label'];
    wholeNumber = json['whole_number'];
    email = json['email'];
    socialIds = json['social_ids'];
    educationId = json['education_id'];
    occupation = json['occupation'];
    annualIncome = json['annual_income'];
    maritalStatusId = json['marital_status_id'];
    preferredLanguageId = json['preferred_language_id'];
    preferredLanguageOther = json['preferred_language_other'];
    countryResidentId = json['country_resident_id'];
    citizenshipId = json['citizenship_id'];
    citizenshipOther = json['citizenship_other'];
    riskprofileId = json['riskprofile_id'];
    isNomination = json['is_nomination'];
    canWill = json['can_will'];
    isLpa = json['is_lpa'];
    dependants = json['dependants'];
    updatedUserId = json['updated_user_id'];
    updatedAt = json['updated_at'];
    disabledAt = json['disabled_at'];
    id = json['id'];
  }
  String? firstName;
  String? lastName;
  String? dob;
  dynamic genderId;
  String? zipCode;
  List<String>? tags;
  String? address1;
  String? address2;
  String? countryId;
  String? remarks;
  String? userId;
  String? createdAt;
  String? createdUserId;
  bool? status;
  bool? disable;
  String? leadStage;
  dynamic photo;
  dynamic mobile;
  dynamic countryCode;
  dynamic countryCodeLabel;
  dynamic wholeNumber;
  dynamic email;
  dynamic socialIds;
  dynamic educationId;
  dynamic occupation;
  dynamic annualIncome;
  dynamic maritalStatusId;
  dynamic preferredLanguageId;
  dynamic preferredLanguageOther;
  dynamic countryResidentId;
  dynamic citizenshipId;
  dynamic citizenshipOther;
  dynamic riskprofileId;
  dynamic isNomination;
  dynamic canWill;
  dynamic isLpa;
  dynamic dependants;
  dynamic updatedUserId;
  dynamic updatedAt;
  dynamic disabledAt;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['dob'] = dob;
    map['gender_id'] = genderId;
    map['zip_code'] = zipCode;
    map['tags'] = tags;
    map['address1'] = address1;
    map['address2'] = address2;
    map['country_id'] = countryId;
    map['remarks'] = remarks;
    map['user_id'] = userId;
    map['created_at'] = createdAt;
    map['created_user_id'] = createdUserId;
    map['status'] = status;
    map['disable'] = disable;
    map['lead_stage'] = leadStage;
    map['photo'] = photo;
    map['mobile'] = mobile;
    map['country_code'] = countryCode;
    map['country_code_label'] = countryCodeLabel;
    map['whole_number'] = wholeNumber;
    map['email'] = email;
    map['social_ids'] = socialIds;
    map['education_id'] = educationId;
    map['occupation'] = occupation;
    map['annual_income'] = annualIncome;
    map['marital_status_id'] = maritalStatusId;
    map['preferred_language_id'] = preferredLanguageId;
    map['preferred_language_other'] = preferredLanguageOther;
    map['country_resident_id'] = countryResidentId;
    map['citizenship_id'] = citizenshipId;
    map['citizenship_other'] = citizenshipOther;
    map['riskprofile_id'] = riskprofileId;
    map['is_nomination'] = isNomination;
    map['can_will'] = canWill;
    map['is_lpa'] = isLpa;
    map['dependants'] = dependants;
    map['updated_user_id'] = updatedUserId;
    map['updated_at'] = updatedAt;
    map['disabled_at'] = disabledAt;
    map['id'] = id;
    return map;
  }

}