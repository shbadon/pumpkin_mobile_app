import 'package:pumpkin/models/response_models/enum_response_model.dart';

class AllEnumResponseModel {
  AllEnumResponseModel({
      this.type, 
      this.options,});

  AllEnumResponseModel.fromJson(dynamic json) {
    type = json['type'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options?.add(EnumResponseModel.fromJson(v));
      });
    }
  }
  String? type;
  List<EnumResponseModel>? options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (options != null) {
      map['options'] = options?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
