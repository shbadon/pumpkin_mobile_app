import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/models/send_models/contacts_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';

class LeadContactsScreenController extends GetxController {
  AgentDetailsResponseModel agentDetailsResponseModel =
      AgentDetailsResponseModel();

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

  String? gender;
  String? countryCode = "65";
  String? countryCodeLabel = "SG";
  RxBool isLoading = false.obs;
  RxBool isFromLeadProfile = false.obs;

  save() async {
    if (mobileNumberTextEditingController.text.isEmpty &&
        emailTextEditingController.text.isEmpty &&
        whatsappTextEditingController.text.isEmpty &&
        instagramTextEditingController.text.isEmpty &&
        facebookTextEditingController.text.isEmpty &&
        twitterTextEditingController.text.isEmpty &&
        linkedinTextEditingController.text.isEmpty &&
        telegramTextEditingController.text.isEmpty) {
      return;
    }

    List<SocialIds> socialIDS = [];

    if (whatsappTextEditingController.text.isNotEmpty) {
      socialIDS.add(
          SocialIds(name: "whatsapp", id: whatsappTextEditingController.text));
    }

    if (instagramTextEditingController.text.isNotEmpty) {
      socialIDS.add(SocialIds(
          name: "instagram", id: instagramTextEditingController.text));
    }

    if (facebookTextEditingController.text.isNotEmpty) {
      socialIDS.add(
          SocialIds(name: "facebook", id: facebookTextEditingController.text));
    }

    if (twitterTextEditingController.text.isNotEmpty) {
      socialIDS.add(
          SocialIds(name: "twitter", id: twitterTextEditingController.text));
    }

    if (linkedinTextEditingController.text.isNotEmpty) {
      socialIDS.add(
          SocialIds(name: "linkedin", id: linkedinTextEditingController.text));
    }

    if (telegramTextEditingController.text.isNotEmpty) {
      socialIDS.add(
          SocialIds(name: "telegram", id: telegramTextEditingController.text));
    }

    try {
      isLoading.value = true;

      var body = ContactsSendModel(
          mobile: mobileNumberTextEditingController.text,
          countryCodeLabel: mobileNumberTextEditingController.text.isEmpty
              ? ""
              : countryCodeLabel,
          countryCode:
              mobileNumberTextEditingController.text.isEmpty ? "" : countryCode,
          email: emailTextEditingController.text,
          socialIds: socialIDS);

      var responseBody = await CoreService().putWithAuth(
          url: baseUrl +
              addContactsUrl +
              GetControllers.shared.getAddLeadScreenController().leadID.value,
          body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;

        if (isFromLeadProfile.value) {
          clearAllFields();
          GetControllers.shared
              .getLeadProfileScreenController()
              .getLeadDetails();
        }

        isFromLeadProfile.value = false;
        Get.back();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  clearAllFields() {
    mobileNumberTextEditingController.clear();
    emailTextEditingController.clear();
    instagramTextEditingController.clear();
    facebookTextEditingController.clear();
    twitterTextEditingController.clear();
    linkedinTextEditingController.clear();
    instagramTextEditingController.clear();
    whatsappTextEditingController.clear();
    isFromLeadProfile.value = false;
  }

  getSocialId(List socialIds) {
    for (var item in socialIds) {
      switch (item.name.toString()) {
        case "whatsapp":
          whatsappTextEditingController.text = item.id.toString();
          break;
        case "instagram":
          instagramTextEditingController.text = item.id.toString();
          break;
        case "facebook":
          facebookTextEditingController.text = item.id.toString();
          break;
        case "twitter":
          twitterTextEditingController.text = item.id.toString();
          break;

        case "linkedin":
          linkedinTextEditingController.text = item.id.toString();
          break;
        case "telegram":
          telegramTextEditingController.text = item.id.toString();
          break;
      }
    }
  }

  void setContactUpdateData(LeadModel leadModel) {
    GetControllers.shared.getAddLeadScreenController().leadID.value =
        leadModel.id.toString();

    isFromLeadProfile.value = true;

    countryCode = leadModel.countryCode ?? "65";
    countryCodeLabel = leadModel.countryCodeLabel ?? "SG";
    mobileNumberTextEditingController.text = leadModel.mobile ?? "";
    emailTextEditingController.text = leadModel.email ?? "";

    if (leadModel.socialIds != null) {
      getSocialId(leadModel.socialIds!);
    }
  }
}
