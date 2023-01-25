import 'package:pumpkin/models/response_models/policy_response_model.dart';

class LeadModel {
  LeadModel({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.genderId, 
      this.tags, 
      this.dob, 
      this.zipCode, 
      this.address1, 
      this.address2, 
      this.countryId, 
      this.leadStage, 
      this.userId, 
      this.photo, 
      this.remarks, 
      this.mobile, 
      this.countryCode, 
      this.countryCodeLabel, 
      this.wholeNumber, 
      this.email, 
      this.socialIds, 
      this.policies,
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
      this.status, 
      this.dateClosed, 
      this.createdUserId, 
      this.updatedUserId, 
      this.createdAt, 
      this.updatedAt, 
      this.disabledAt, 
      this.disable,});

  LeadModel.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    genderId = json['gender_id'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    dob = json['dob'];
    zipCode = json['zip_code'];
    address1 = json['address1'];
    address2 = json['address2'];
    countryId = json['country_id'];
    leadStage = json['lead_stage'];
    userId = json['user_id'];
    photo = json['photo'];
    remarks = json['remarks'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    countryCodeLabel = json['country_code_label'];
    wholeNumber = json['whole_number'];
    email = json['email'];
    if (json['social_ids'] != null) {
      socialIds = [];
      json['social_ids'].forEach((v) {
        socialIds?.add(SocialIds.fromJson(v));
      });
    }if (json['policies'] != null) {
      policies = [];
      json['policies'].forEach((v) {
        policies?.add(PolicyResponseModel.fromJson(v));
      });
    }
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
    status = json['status'];
    dateClosed = json['date_closed'];
    createdUserId = json['created_user_id'];
    updatedUserId = json['updated_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    disabledAt = json['disabled_at'];
    disable = json['disable'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? genderId;
  List<String>? tags;
  String? dob;
  String? zipCode;
  String? address1;
  String? address2;
  String? countryId;
  String? leadStage;
  String? userId;
  String? photo;
  String? remarks;
  String? mobile;
  String? countryCode;
  String? countryCodeLabel;
  String? wholeNumber;
  String? email;
  List<SocialIds>? socialIds;
  List<PolicyResponseModel>? policies;
  dynamic educationId;
  dynamic occupation;
  dynamic annualIncome;
  dynamic maritalStatusId;
  dynamic preferredLanguageId;
  dynamic preferredLanguageOther;
  String? countryResidentId;
  dynamic citizenshipId;
  dynamic citizenshipOther;
  dynamic riskprofileId;
  dynamic isNomination;
  dynamic canWill;
  dynamic isLpa;
  dynamic dependants;
  bool? status;
  dynamic dateClosed;
  String? createdUserId;
  String? updatedUserId;
  String? createdAt;
  String? updatedAt;
  dynamic disabledAt;
  bool? disable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['gender_id'] = genderId;
    map['tags'] = tags;
    map['dob'] = dob;
    map['zip_code'] = zipCode;
    map['address1'] = address1;
    map['address2'] = address2;
    map['country_id'] = countryId;
    map['lead_stage'] = leadStage;
    map['user_id'] = userId;
    map['photo'] = photo;
    map['remarks'] = remarks;
    map['mobile'] = mobile;
    map['country_code'] = countryCode;
    map['country_code_label'] = countryCodeLabel;
    map['whole_number'] = wholeNumber;
    map['email'] = email;
    if (socialIds != null) {
      map['social_ids'] = socialIds?.map((v) => v.toJson()).toList();
    }
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
    map['status'] = status;
    map['date_closed'] = dateClosed;
    map['created_user_id'] = createdUserId;
    map['updated_user_id'] = updatedUserId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['disabled_at'] = disabledAt;
    map['disable'] = disable;
    return map;
  }

}

class SocialIds {
  SocialIds({
      this.name, 
      this.id,});

  SocialIds.fromJson(dynamic json) {
    name = json['name'];
    id = json['id'];
  }
  String? name;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['id'] = id;
    return map;
  }

}