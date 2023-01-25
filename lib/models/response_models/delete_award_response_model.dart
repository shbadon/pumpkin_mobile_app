import 'package:pumpkin/models/response_models/add_awards_response_model.dart';

class DeleteAwardsResponseModel {
  String? message;
  List<Award>? existingAwards;
  DeleteAwardsResponseModel({this.message, this.existingAwards});
  factory DeleteAwardsResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteAwardsResponseModel(
        message: json['message'],
        existingAwards: List<Award>.from(
            json['ExistAwardInfo'].map((data) => Award.fromJson(data))),
      );
}
