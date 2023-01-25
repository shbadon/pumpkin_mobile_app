class PolicyResponseModel {
  PolicyResponseModel({
      this.id, 
      this.leadId, 
      this.policyNumber, 
      this.policyName, 
      this.annualPremium, 
      this.fyc, 
      this.paymentModeId, 
      this.applicationDate, 
      this.policyRemarks, 
      this.indicationOfInforce, 
      this.createdUserId, 
      this.updatedUserId, 
      this.createdAt, 
      this.updatedAt,});

  PolicyResponseModel.fromJson(dynamic json) {
    id = json['id'];
    leadId = json['lead_id'];
    policyNumber = json['policy_number'];
    policyName = json['policy_name'];
    annualPremium = json['annual_premium'];
    fyc = json['fyc'];
    paymentModeId = json['payment_mode_id'];
    applicationDate = json['application_date'];
    policyRemarks = json['policy_remarks'];
    indicationOfInforce = json['indication_of_inforce'];
    createdUserId = json['created_user_id'];
    updatedUserId = json['updated_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  String? leadId;
  String? policyNumber;
  String? policyName;
  String? annualPremium;
  String? fyc;
  String? paymentModeId;
  String? applicationDate;
  String? policyRemarks;
  bool? indicationOfInforce;
  String? createdUserId;
  dynamic updatedUserId;
  String? createdAt;
  dynamic updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['lead_id'] = leadId;
    map['policy_number'] = policyNumber;
    map['policy_name'] = policyName;
    map['annual_premium'] = annualPremium;
    map['fyc'] = fyc;
    map['payment_mode_id'] = paymentModeId;
    map['application_date'] = applicationDate;
    map['policy_remarks'] = policyRemarks;
    map['indication_of_inforce'] = indicationOfInforce;
    map['created_user_id'] = createdUserId;
    map['updated_user_id'] = updatedUserId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}