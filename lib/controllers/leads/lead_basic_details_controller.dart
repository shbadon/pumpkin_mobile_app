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
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/models/response_models/tags_response_model.dart';
import 'package:pumpkin/models/send_models/add_lead_basic_details_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';

class LeadBasicDetailsScreenController extends GetxController {
  AgentDetailsResponseModel agentDetailsResponseModel =
      AgentDetailsResponseModel();
  TextEditingController firstNametextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController dateOfBirthTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController mobileNumberTextEditingController =
      TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController zipCodeTextEditingController = TextEditingController();
  TextEditingController addressLine1TextEditingController =
      TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController certificationAndAwardNameTextEditingController =
      TextEditingController();
  TextEditingController certificationAncdAwardYearTextEditingController =
      TextEditingController();
  TextEditingController certificationAncdAwardDescriptionTextEditingController =
      TextEditingController();

  TextEditingController changeMobileNumberTextEditingController =
      TextEditingController();
  TextEditingController changeEmailTextEditingController =
      TextEditingController();
  TextEditingController addTagTextEditingController = TextEditingController();

  TextEditingController remarksTextEditingController = TextEditingController();

  TagsController tagsController = GetControllers.shared.getTagsController();

  RxBool selectChoiceChip = false.obs;

  String? gender = "male";
  String? countryCode;
  RxString profilePictureUrl = ''.obs;
  RxList<Award> listOfAwards = <Award>[].obs;
  RxList<Certificate> listOfCertificates = <Certificate>[].obs;
  AddAwardsResponseModel addAwardsResponseModel = AddAwardsResponseModel();
  AddCertificateResponseModel addCertificateResponseModel =
      AddCertificateResponseModel();
  DeleteAwardsResponseModel deleteAwardsResponseModel =
      DeleteAwardsResponseModel();
  DeleteCertificatesResponseModel deleteCertificatesResponseModel =
      DeleteCertificatesResponseModel();
  RxBool isLoading = false.obs;
  final picker = ImagePicker();
  Rx<File> images = File("").obs;
  RxList<OneTag> selectedTagsList = <OneTag>[OneTag(id: -1, name: 'Add')]
      .obs; //We have a byDefault value for the add button
  // RxList<OneTag> tempTagList = <OneTag>[OneTag(id: -1, name: 'Add')]
  // .obs; //We have a byDefault value for the add button
  List<String> tagsListInRequest = [];

  RxBool isFromLeadProfile = false.obs;

  save() async {
    try {
      isLoading.value = true;
      // Converting the tags to a list of strings to send to API request
      for (var element in selectedTagsList) {
        if (element.id != -1) {
          tagsListInRequest.add(element.name!);
        }
      }

      var body = AddLeadBasicDetailsSendModel(
        firstName: firstNametextEditingController.text,
        lastName: lastNameTextEditingController.text,
        dob: dateOfBirthTextEditingController.text,
        genderId: gender.toString() == "male" ? "m" : "f",
        countryId: countryTextEditingController.text,
        zipCode: zipCodeTextEditingController.text,
        address1: addressLine1TextEditingController.text,
        address2: addressLine2Controller.text,
        tags: tagsListInRequest,
        remarks: remarksTextEditingController.text,
      );

      var responseBody = await CoreService().postWithAuth(
          url: baseUrl + addLeadBasicDetailsUrl, body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        var result = AddLeadBasicDetailsResponseModel.fromJson(responseBody);
        GetControllers.shared.getAddLeadScreenController().leadID.value =
            result.showData!.id.toString();

        if (images.value.path.isNotEmpty) {
          await uploadProfilePicture(result.showData!.id.toString());
        }

        //showSuccessToast(result.message.toString());
        isLoading.value = false;
        Get.back();
        Get.delete<LeadBasicDetailsScreenController>();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      debugPrint(pickedFile.path);
      images.value = File(pickedFile.path);
      // uploadProfilePicture(
      //     GetControllers.shared.getAddLeadScreenController().leadID.value);
    } else {
      debugPrint('No image selected.');
    }
  }

  uploadProfilePicture(String leadID) async {
    try {
      var responseBody = await CoreService().postFileWithAuth(
          upload: images.value.readAsBytesSync(),
          filename: images.value.path.split("/").last,
          url: baseUrl + addLeadImageUploadUrl + leadID,
          key: 'photo');
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        debugPrint(responseBody.toString());
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // This functions runs when we tap on the button to add tags
  openTagBottomSheet() {
    try {
      tagsController.getAllTagsforAgent();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  makeIsSelectedFalse(TagsResponseModel tagsResponseModel) {
    try {
      tagsResponseModel.tags?.forEach((element) {
        element.isSelected = false;
      });
      // tempTagList.value = [OneTag(id: -1, name: 'Add')];
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String leadID = "";

  Future<void> settDetailsFromLeadProfileScreen(LeadModel leadModel) async {
    leadID = leadModel.id.toString();

    firstNametextEditingController.text = leadModel.firstName.toString();
    lastNameTextEditingController.text = leadModel.lastName.toString();
    dateOfBirthTextEditingController.text = leadModel.dob ?? "";
    addressLine1TextEditingController.text = leadModel.address1.toString();
    addressLine2Controller.text = leadModel.address2.toString();
    zipCodeTextEditingController.text = leadModel.zipCode.toString();
    countryTextEditingController.text = leadModel.countryId.toString();
    profilePictureUrl.value = leadModel.photo ?? '';
    gender = leadModel.genderId.toString() == "f" ? "female" : "male";

    //await tagsController.getAllTagsforAgent();

    //selectedTagsList.value.add(OneTag());
  }

  detailsUpdate() async {
    try {
      isLoading.value = true;
      // Converting the tags to a list of strings to send to API request
      for (var element in selectedTagsList) {
        if (element.id != -1) {
          tagsListInRequest.add(element.name!);
        }
      }

      var body = AddLeadBasicDetailsSendModel(
        firstName: firstNametextEditingController.text,
        lastName: lastNameTextEditingController.text,
        dob: dateOfBirthTextEditingController.text,
        genderId: gender.toString() == "male" ? "m" : "f",
        countryId: countryTextEditingController.text,
        zipCode: zipCodeTextEditingController.text,
        address1: addressLine1TextEditingController.text,
        address2: addressLine2Controller.text,
        tags: tagsListInRequest,
        remarks: remarksTextEditingController.text,
      );

      var responseBody = await CoreService().putWithAuth(
          url: baseUrl + updateLeadBasicDetailsUrl + leadID,
          body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        var result = AddLeadBasicDetailsResponseModel.fromJson(responseBody);
        GetControllers.shared.getAddLeadScreenController().leadID.value =
            result.showData!.id.toString();

        if (images.value.path.isNotEmpty) {
          await uploadProfilePicture(result.showData!.id.toString());
        }

        GetControllers.shared.getLeadProfileScreenController().getLeadDetails();
        isLoading.value = false;
        Get.back();
        Get.delete<LeadBasicDetailsScreenController>();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
