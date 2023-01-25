// This model is used for the get agent details API, this is the response model of the get agent details response model

import 'package:pumpkin/models/response_models/add_awards_response_model.dart';
import 'package:pumpkin/models/response_models/add_certificate_response_model.dart';

class AgentDetailsResponseModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? dateOfBirth;
  int? status;
  int? isEmailVerified;
  int? isMobileVerified;
  String? gender;
  String? profileMessage;
  String? companyName;
  String? agencyName;
  String? designamtion;
  bool isTWOFAEnabled;
  bool isDeviceAuthEnabled;
  String? photo;
  List<Award>? awards;
  List<Certificate>? certificates;
  bool? isGoogleConnected;
  bool? isFbConnected;
  bool? isAppleConnected;
  bool? isPasswordSet;
  String? registerType;

  //* NOTE: Haven't addded awards and certificated list here

  AgentDetailsResponseModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.mobile,
      this.dateOfBirth,
      this.status,
      this.isEmailVerified,
      this.isMobileVerified,
      this.gender,
      this.profileMessage,
      this.companyName,
      this.agencyName,
      this.designamtion,
      this.isTWOFAEnabled = false,
      this.isDeviceAuthEnabled = false,
      this.photo,
      this.awards,
      this.certificates,
      this.isGoogleConnected = false,
      this.isFbConnected = false,
      this.isAppleConnected = false,
      this.isPasswordSet = false,
      this.registerType});

  factory AgentDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      AgentDetailsResponseModel(
          id: json['id'],
          firstName: json["first_name"],
          lastName: json["last_name"],
          email: json["email"],
          countryCode: json["country_code"],
          mobile: json["mobile"],
          dateOfBirth: json['dob'],
          status: json['status'],
          isEmailVerified: json['is_email_verified'],
          isMobileVerified: json['is_mobile_verified'],
          gender: json['gender'],
          profileMessage: json['profile_msg'],
          companyName: json['company_name'],
          agencyName: json['agency_name'],
          designamtion: json['designation'],
          isTWOFAEnabled: json['isTwoFactorAuthenticationEnabled'],
          isDeviceAuthEnabled: json['isDeviceAuthenticationEnabled'],
          photo: json['photo'],
          awards: List<Award>.from(
              json['awards'].map((data) => Award.fromJson(data))),
          certificates: List<Certificate>.from(
              json['certificates'].map((data) => Certificate.fromJson(data))),
          isGoogleConnected: json['google_connected'],
          isFbConnected: json['fb_connected'],
          isAppleConnected: json['apple_connected'],
          isPasswordSet: json['paswordSet'],
          registerType: json['register_type']);
}
