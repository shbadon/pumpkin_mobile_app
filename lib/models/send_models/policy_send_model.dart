class PolicySendModel {
  PolicySendModel({
      this.policyNumber, 
      this.policyName, 
      this.annualPremium, 
      this.fyc, 
      this.paymentModeId, 
      this.applicationDate, 
      this.policyRemarks, 
      this.indicationOfInforce,});

  PolicySendModel.fromJson(dynamic json) {
    policyNumber = json['policy_number'];
    policyName = json['policy_name'];
    annualPremium = json['annual_premium'];
    fyc = json['fyc'];
    paymentModeId = json['payment_mode_id'];
    applicationDate = json['application_date'];
    policyRemarks = json['policy_remarks'];
    indicationOfInforce = json['indication_of_inforce'];
  }
  String? policyNumber;
  String? policyName;
  num? annualPremium;
  num? fyc;
  String? paymentModeId;
  String? applicationDate;
  String? policyRemarks;
  bool? indicationOfInforce;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['policy_number'] = policyNumber;
    map['policy_name'] = policyName;
    map['annual_premium'] = annualPremium;
    map['fyc'] = fyc;
    map['payment_mode_id'] = paymentModeId;
    map['application_date'] = applicationDate;
    map['policy_remarks'] = policyRemarks;
    map['indication_of_inforce'] = indicationOfInforce;
    return map;
  }

}