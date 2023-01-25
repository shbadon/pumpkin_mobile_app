class CertificateAndAwardSendModel {
  String name;
  String year;
  String? description;
  String email;

  CertificateAndAwardSendModel(
      {required this.name,
      required this.year,
      this.description,
      required this.email});

  Map<String, dynamic> toJson() =>
      {"name": name, "year": year, "decription": description, "email": email};
}
