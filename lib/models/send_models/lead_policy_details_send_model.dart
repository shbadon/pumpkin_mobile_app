class LeadPolicyDetailsSendModel {
  String? policyNumber;
  String? policyName;
  double? annualPremium;
  double? fyc;
  int? paymnetModeId;
  String? applicationDate;
  String? policyRemarks;
  bool? indicationOfInforce;

  Map<String, dynamic> toJson() => {
        "policy_number": policyNumber,
        "policy_name": policyName,
        "annual_premium": annualPremium,
        "fyc": fyc,
        "payment_mode_id": paymnetModeId,
        "application_date": applicationDate,
        "policy_remarks": policyRemarks,
        "indication_of_inforce": indicationOfInforce
      };
}
