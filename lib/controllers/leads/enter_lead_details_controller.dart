import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/tags_controller.dart';
import 'package:pumpkin/models/response_models/add_awards_response_model.dart';
import 'package:pumpkin/models/response_models/add_certificate_response_model.dart';
import 'package:pumpkin/models/response_models/add_lead_basic_details_response_model.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:pumpkin/models/response_models/delete_award_response_model.dart';
import 'package:pumpkin/models/response_models/delete_certificate_response_model.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/models/response_models/tags_response_model.dart';
import 'package:pumpkin/models/send_models/add_lead_basic_details_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';

class EnterLeadDetailsScreenController extends GetxController {
  AgentDetailsResponseModel agentDetailsResponseModel =
      AgentDetailsResponseModel();
  TextEditingController firstNametextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController dateOfBirthTextEditingController =
      TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController zipCodeTextEditingController = TextEditingController();
  TextEditingController addressLine1TextEditingController =
      TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();

  String? gender = "male";
  String? countryCode;
  RxBool isLoading = false.obs;


  TextEditingController whatsappTextEditingController = TextEditingController();
  TextEditingController instagramTextEditingController =
  TextEditingController();
  TextEditingController facebookTextEditingController = TextEditingController();
  TextEditingController twitterTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController mobileNumberTextEditingController =
  TextEditingController();

  TextEditingController linkedinTextEditingController = TextEditingController();
  TextEditingController telegramTextEditingController = TextEditingController();

  String? countryCodeLabel = "SG";


  TextEditingController policyNumberTextEditingController =
  TextEditingController();
  TextEditingController policyNameTextEditingController =
  TextEditingController();
  TextEditingController annualPremiumTextEditingController =
  TextEditingController();
  TextEditingController fycTextEditingController = TextEditingController();
  var selectedPaymentMode = EnumResponseModel().obs;
  TextEditingController applicationDateTextEditingController =
  TextEditingController();
  TextEditingController remarksTextEditingController = TextEditingController();
  RxBool indicationOfInforceisChecked = true.obs; //Boolean for checkbox




  save() async {
  }

}
