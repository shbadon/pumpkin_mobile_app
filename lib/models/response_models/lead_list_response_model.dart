class LeadListResponseModel {
  int? total;
  List<OneLeadResponseModel>? leadsList;
  String? prev;
  String? next;

  LeadListResponseModel({this.total, this.leadsList, this.prev, this.next});
  factory LeadListResponseModel.fromJson(Map<String, dynamic> json) =>
      LeadListResponseModel(
          total: json['total'],
          leadsList: List<OneLeadResponseModel>.from(
              json['data'].map((data) => OneLeadResponseModel.fromJson(data))),
          prev: json['prev'],
          next: json['next']);
}

class OneLeadResponseModel {
  String? id;
  String? firstName;
  String? lastName;
  List<dynamic>? tags;
  String? leadStage;
  String? photo;
  String? mobile;
  String? countryCode;
  String? countryCodeLabel;
  String? email;
  bool status;
  String? createdDate;

  OneLeadResponseModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.tags,
      this.leadStage,
      this.photo,
      this.mobile,
      this.countryCode,
      this.countryCodeLabel,
      this.email,
      this.status = true,
      this.createdDate});

  factory OneLeadResponseModel.fromJson(Map<String, dynamic> json) =>
      OneLeadResponseModel(
          id: json['id'],
          firstName: json['first_name'],
          lastName: json['last_name'],
          tags: json['tags'],
          leadStage: json['lead_stage'],
          photo: json['photo'],
          mobile: json['mobile'],
          countryCode: json['country_code'],
          countryCodeLabel: json['country_code_label'],
          email: json['email'],
          status: json['status'],
          createdDate: json['created_at']);
}
