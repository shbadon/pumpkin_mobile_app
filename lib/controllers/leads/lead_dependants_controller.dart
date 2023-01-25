import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/response_models/dependants_send_model.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/models/response_models/lead_dependents_response_model.dart';
import 'package:pumpkin/models/send_models/user_info_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';

class LeaddependantsScreenController extends GetxController {
  TextEditingController nameTextEditingController = TextEditingController();
  var selectedReletionship =
      EnumResponseModel();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController mobileNumberTextEditingController =
      TextEditingController();
  RxBool isLoading = false.obs;

  RxList<OneDependentModel> dependentsList = <OneDependentModel>[].obs;

  String? countryCode = "65";
  String? countryCodeLabel = "SG";

  var relationList = <EnumResponseModel>[].obs;

  @override
  void onInit() {
    //getDependants();
    super.onInit();
  }

  getDependants() async {
    try {
      isLoading.value = true;

      var responseBody = await CoreService()
          .getWithAuth(url: baseUrl + getLeadDepenedentsdUrl + GetControllers.shared.getAddLeadScreenController().leadID.value);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        var results = LeadDependentsResponseModel.fromJson(responseBody);
        dependentsList.value = results.dependentsList!;
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  save() async {

    if(GetControllers.shared.getAddLeadScreenController().leadID.value.isEmpty || dependentsList.isEmpty){
      return;
    }

    try {
      isLoading.value = true;

      var body = LeadDependentsResponseModel(
        dependentsList: dependentsList.value,
      );

      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + updateLeadDepenedentsdUrl + GetControllers.shared.getAddLeadScreenController().leadID.value, body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.back();
        Get.delete<LeaddependantsScreenController>();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  void add(context) {
    try {
      dependentsList.add(OneDependentModel(
          name: nameTextEditingController.text,
          mobile: mobileNumberTextEditingController.text,
          email: emailTextEditingController.text,
          relationship: selectedReletionship.description,
          countryCode: countryCode,
          countryLabel: countryCodeLabel));
      clearAllFields();
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateDependant(int index) {
    try {
      dependentsList[index] = OneDependentModel(
          name: nameTextEditingController.text,
          mobile: mobileNumberTextEditingController.text,
          email: emailTextEditingController.text,
          relationship: selectedReletionship.description,
          countryCode: countryCode,
          countryLabel: countryCodeLabel);
      clearAllFields();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  clearAllFields() {
    nameTextEditingController.clear();
    mobileNumberTextEditingController.clear();
    emailTextEditingController.clear();
    selectedReletionship = EnumResponseModel();
  }
}
