class CompleteprofileScreenSendModel {
  String companyName;
  String agencyName;
  String designation;
  String email;

  CompleteprofileScreenSendModel(
      {required this.companyName,
      required this.agencyName,
      required this.designation,
      required this.email});

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "agency_name": agencyName,
        "designation": designation,
        "email": email
      };
}
