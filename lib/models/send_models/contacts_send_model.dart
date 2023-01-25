import 'package:pumpkin/models/response_models/lead_model.dart';

class ContactsSendModel {
  ContactsSendModel({
      this.mobile, 
      this.countryCodeLabel, 
      this.countryCode, 
      this.email, 
      this.socialIds,});

  ContactsSendModel.fromJson(dynamic json) {
    mobile = json['mobile'];
    countryCodeLabel = json['country_code_label'];
    countryCode = json['country_code'];
    email = json['email'];
    if (json['social_ids'] != null) {
      socialIds = [];
      json['social_ids'].forEach((v) {
        socialIds?.add(SocialIds.fromJson(v));
      });
    }
  }
  String? mobile;
  String? countryCodeLabel;
  String? countryCode;
  String? email;
  List<SocialIds>? socialIds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile'] = mobile;
    map['country_code_label'] = countryCodeLabel;
    map['country_code'] = countryCode;
    map['email'] = email;
    if (socialIds != null) {
      map['social_ids'] = socialIds?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}