import 'package:pumpkin/models/response_models/add_certificate_response_model.dart';

class DeleteCertificatesResponseModel {
  String? message;
  List<Certificate>? existingAwards;
  DeleteCertificatesResponseModel({this.message, this.existingAwards});
  factory DeleteCertificatesResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteCertificatesResponseModel(
        message: json['message'],
        existingAwards: List<Certificate>.from(
            json['ExistCertInfo'].map((data) => Certificate.fromJson(data))),
      );
}
