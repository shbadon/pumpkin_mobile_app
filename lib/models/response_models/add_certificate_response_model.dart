class AddCertificateResponseModel {
  String? message;
  Certificate? showData;
  AddCertificateResponseModel({this.message, this.showData});
  factory AddCertificateResponseModel.fromJson(Map<String, dynamic> json) =>
      AddCertificateResponseModel(
        message: json['message'],
        showData: Certificate.fromJson(json['showData']),
      );
}

class Certificate {
  int? id;
  String? name;
  String? year;
  String? description;

  Certificate({this.id, this.name, this.year, this.description});

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
        id: json['id'],
        name: json['name'],
        year: json["year"],
        description: json["description"],
      );
}
