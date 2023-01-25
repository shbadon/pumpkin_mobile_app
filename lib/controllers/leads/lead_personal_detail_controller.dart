import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/models/send_models/lead_personal_details_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/services/repository.dart';
import 'package:pumpkin/utils/api_urls.dart';

class LeadPersonalDetailsScreenController extends GetxController {
  var selectedMaritalStatus = EnumResponseModel().obs;
  TextEditingController occupationTextEditingController =
      TextEditingController();
  TextEditingController annualIncomeTextEditingController =
      TextEditingController();

  var selectedValueNotifier = EnumResponseModel().obs;
  var selectedEducational = EnumResponseModel().obs;
  var iconAnimationNotifier = false.obs;

  var selectedCitizenshipStatus =
  EnumResponseModel().obs;

  var selectedPreferredLanguage =
  EnumResponseModel().obs;

  var countryOfResidenceTextEditingController =
      TextEditingController();

  var selectedRiskProfile =
  EnumResponseModel().obs;

  RxBool isLoading = false.obs;
  RxBool isNominations = true.obs;
  RxBool isWill = true.obs;
  RxBool isLPA = true.obs;

  final countryResidenceList = [
    'Singapore',
    'Malaysia',
    'India',
    'Others',
  ];

  RxBool isFromLeadProfile = false.obs;

  @override
  void onInit() {
     /*EnumRepository.getEnum(
        "education", educationList);
     EnumRepository.getEnum(
        "language", preferredLanguageList);
     EnumRepository.getEnum(
        "citizenship", citizenshipStatusList);
     EnumRepository.getEnum(
        "marital_status", maritalList);
     EnumRepository.getEnum(
        "risk_profile", riskProfileList);*/
    super.onInit();
  }

  save() async {

    /*if(selectedEducational == null && occupationTextEditingController.text.isEmpty
        && annualIncomeTextEditingController.text.isEmpty
        && selectedMaritalStatus == null
        && selectedPreferredLanguage == null
        && countryOfResidenceTextEditingController == null
        && selectedCitizenshipStatus == null
        && selectedRiskProfile == null

    )*/

    try {
      isLoading.value = true;

      var body = LeadPersonalDetailsSendModel(
        educationId: selectedEducational.value.code.toString(),
        occupation: occupationTextEditingController.text,
        annualIncome: num.tryParse(annualIncomeTextEditingController.text.replaceAll(",", "")),
        //maritalStatusId: maritalTextEditingController.text,
        maritalStatusId: selectedMaritalStatus.value.code,
        preferredLanguageId: selectedPreferredLanguage.value.code,
        preferredLanguageOther: selectedPreferredLanguage.value.code,
        countryResidentId: countryOfResidenceTextEditingController.text,
        citizenshipId: selectedCitizenshipStatus.value.code,
        citizenshipOther: selectedCitizenshipStatus.value.code,
        riskprofileId: selectedRiskProfile.value.code,
        isNomination: isNominations.value,
        canWill: isWill.value,
        isLpa: isLPA.value,
      );

      var responseBody = await CoreService().putWithAuth(
          url: baseUrl +
              addPersonalDetailsUrl +
              GetControllers.shared.getAddLeadScreenController().leadID.value,
          body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        if(isFromLeadProfile.value){
          GetControllers.shared.getLeadProfileScreenController().getLeadDetails();
          clearAllFields();
        }
        Get.back();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  clearAllFields() {
    selectedEducational= EnumResponseModel().obs;
    selectedMaritalStatus= EnumResponseModel().obs;
    occupationTextEditingController.clear();
    annualIncomeTextEditingController.clear();
    selectedCitizenshipStatus= EnumResponseModel().obs;
    selectedPreferredLanguage= EnumResponseModel().obs;
    countryOfResidenceTextEditingController.clear();
    selectedRiskProfile= EnumResponseModel().obs;
  }

  var enums = GetControllers.shared.getEnumController();

  void setDetailsFromLeadProfileScreen(LeadModel leadModel) {

    countryOfResidenceTextEditingController.text = leadModel.countryResidentId ?? '';

    GetControllers.shared.getAddLeadScreenController().leadID.value  = leadModel.id.toString();

    occupationTextEditingController.text = leadModel.occupation ?? '';
    annualIncomeTextEditingController.text = leadModel.annualIncome.toString() == "null" ? '' : leadModel.annualIncome.toString();

    isWill.value = leadModel.canWill ?? false;
    isNominations.value = leadModel.isNomination ?? false;
    isLPA.value = leadModel.isLpa ?? false;

   EnumRepository.findEnum2(enums.educationList.value, leadModel.educationId.toString(), false, selectedEducational);
   EnumRepository.findEnum2(enums.maritalList.value, leadModel.maritalStatusId.toString(), false, selectedMaritalStatus);
   EnumRepository.findEnum2(enums.preferredLanguageList.value, leadModel.preferredLanguageId.toString(), false, selectedPreferredLanguage);
   EnumRepository.findEnum2(enums.citizenshipStatusList.value, leadModel.citizenshipId.toString(), false, selectedCitizenshipStatus);
   EnumRepository.findEnum2(enums.riskProfileList.value, leadModel.riskprofileId.toString(), false, selectedRiskProfile);

   debugPrint("countryOfResidenceTextEditingController:: "+countryOfResidenceTextEditingController.text);
  }
}
