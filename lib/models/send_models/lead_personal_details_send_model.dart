class LeadPersonalDetailsSendModel {
  LeadPersonalDetailsSendModel({
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
      this.isLpa,});

  LeadPersonalDetailsSendModel.fromJson(dynamic json) {
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
  }
  String? educationId;
  String? occupation;
  num? annualIncome;
  String? maritalStatusId;
  String? preferredLanguageId;
  String? preferredLanguageOther;
  String? countryResidentId;
  String? citizenshipId;
  String? citizenshipOther;
  String? riskprofileId;
  bool? isNomination;
  bool? canWill;
  bool? isLpa;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    return map;
  }

}