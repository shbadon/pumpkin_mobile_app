import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/models/response_models/policy_response_model.dart';
import 'package:pumpkin/models/send_models/policy_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/services/repository.dart';
import 'package:pumpkin/utils/api_urls.dart';

class PolicyDetailsScreenController extends GetxController {
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
  RxBool isLoading = true.obs;

  // OnTap of save button
  onTapSave() {
    if (policyNumberTextEditingController.text.isNotEmpty ||
        policyNameTextEditingController.text.isNotEmpty ||
        annualPremiumTextEditingController.text.isNotEmpty ||
        fycTextEditingController.text.isNotEmpty ||
        selectedPaymentMode.value.description.toString().isNotEmpty ||
        applicationDateTextEditingController.text.isNotEmpty ||
        remarksTextEditingController.text.isNotEmpty) {
      saveAndUpdatePolicy();
    } else {
      Get.back();
    }
  }

  clearAllFields() {
    policyNumberTextEditingController.clear();
    policyNameTextEditingController.clear();
    applicationDateTextEditingController.clear();
    remarksTextEditingController.clear();
    annualPremiumTextEditingController.clear();
    fycTextEditingController.clear();
    selectedPaymentMode = EnumResponseModel().obs;
  }

  // Save the policyDetails
  saveAndUpdatePolicy() async {
    try {
      isLoading.value = true;

      var body = PolicySendModel(
        policyNumber: policyNumberTextEditingController.text,
        policyName: policyNameTextEditingController.text,
        applicationDate: applicationDateTextEditingController.text,
        policyRemarks: remarksTextEditingController.text,
        indicationOfInforce: indicationOfInforceisChecked.value,
        annualPremium: annualPremiumTextEditingController.text.isEmpty
            ? 0
            : num.parse(annualPremiumTextEditingController.text.replaceAll(",", "")),
        paymentModeId: selectedPaymentMode.value.code,
        fyc: fycTextEditingController.text.isEmpty
            ? 0
            : num.parse(fycTextEditingController.text),
      );

      var responseBody;

      debugPrint("isFromLeadProfile.value:: "+isFromLeadProfile.value.toString()+" ::policyID:: "+policyID);

      if(isFromLeadProfile.value && policyID.isNotEmpty){
        responseBody = await CoreService().putWithAuth(
            url: baseUrl +
                updateLeadPolicyUrl +"$policyID/"+
                GetControllers.shared
                    .getAddLeadScreenController()
                    .leadID
                    .value,
            body: body.toJson());
      }else {
        responseBody = await CoreService().postWithAuth(
            url: baseUrl +
                addLeadPolicyUrl +
                GetControllers.shared
                    .getAddLeadScreenController()
                    .leadID
                    .value,
            body: body.toJson());
      }
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.back();
        GetControllers.shared.getLeadProfileScreenController().getLeadDetails();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  var isFromLeadProfile = false.obs;

  String policyID = "";

  void setPolicyData(LeadModel leadModel) {

    GetControllers.shared.getAddLeadScreenController().leadID.value = leadModel.id.toString();

    isFromLeadProfile.value = true;

    if(leadModel.policies!.isEmpty) {
      return;
    }

    PolicyResponseModel policy = leadModel.policies!.first;

    policyID = policy.id.toString();

    policyNumberTextEditingController.text = policy.policyNumber ?? "";
    policyNameTextEditingController.text = policy.policyName ?? "";
    annualPremiumTextEditingController.text = policy.annualPremium ?? "";
    fycTextEditingController.text = policy.fyc ?? "";
    applicationDateTextEditingController.text = policy.applicationDate ?? "";
    remarksTextEditingController.text = policy.policyRemarks ?? "";
    indicationOfInforceisChecked.value = policy.indicationOfInforce ?? false;
    EnumRepository.findEnum2(GetControllers.shared.getEnumController().paymentModeList, policy.paymentModeId.toString(), false, selectedPaymentMode);

    debugPrint("isFromLeadProfile.value:: "+isFromLeadProfile.value.toString()+" ::policyID:: "+policyID);
  }
}
