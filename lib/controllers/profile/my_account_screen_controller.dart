import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pumpkin/models/response_models/add_awards_response_model.dart';
import 'package:pumpkin/models/response_models/add_certificate_response_model.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:pumpkin/models/response_models/delete_award_response_model.dart';
import 'package:pumpkin/models/response_models/delete_certificate_response_model.dart';
import 'package:pumpkin/models/send_models/enter_mobile_screen_send_model.dart';
import 'package:pumpkin/models/send_models/user_info_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/toast.dart';

class MyAccountScreenController extends GetxController {
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
  TextEditingController profileMessageTextEditingController =
      TextEditingController();
  TextEditingController companyNameTextEditingController =
      TextEditingController();
  TextEditingController agencyNameTextEditingController =
      TextEditingController();
  TextEditingController designationTextEditingController =
      TextEditingController();
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

  String? gender;
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

  @override
  void onInit() {
    agentDetailsResponseModel = Get.arguments != null
        ? Get.arguments[0]
        : AgentDetailsResponseModel(); //Argument to get agent details from the previous screen
    firstNametextEditingController.text =
        agentDetailsResponseModel.firstName ?? '';
    lastNameTextEditingController.text =
        agentDetailsResponseModel.lastName ?? '';
    dateOfBirthTextEditingController.text =
        agentDetailsResponseModel.dateOfBirth ?? '';
    emailTextEditingController.text = agentDetailsResponseModel.email ?? '';
    mobileNumberTextEditingController.text =
        agentDetailsResponseModel.mobile ?? '';
    profileMessageTextEditingController.text =
        agentDetailsResponseModel.profileMessage ?? '';
    companyNameTextEditingController.text =
        agentDetailsResponseModel.companyName ?? '';
    agencyNameTextEditingController.text =
        agentDetailsResponseModel.agencyName ?? '';
    designationTextEditingController.text =
        agentDetailsResponseModel.designamtion ?? '';
    gender = agentDetailsResponseModel.gender.toString().camelCase;
    countryCode = agentDetailsResponseModel.countryCode;
    profilePictureUrl.value = agentDetailsResponseModel.photo ?? '';
    listOfAwards.value = agentDetailsResponseModel.awards ?? [];
    listOfCertificates.value = agentDetailsResponseModel.certificates ?? [];
    super.onInit();
  }

  // Saving the changes made in the User details
  save() async {
    try {
      isLoading.value = true;

      var body = UserInfoSendModel(
        firstName: firstNametextEditingController.text,
        lastName: lastNameTextEditingController.text,
        dob: dateOfBirthTextEditingController.text,
        gender: gender.toString(),
        profileMsg: profileMessageTextEditingController.text,
        companyName: companyNameTextEditingController.text,
        agencyName: agencyNameTextEditingController.text,
        designation: designationTextEditingController.text,
      );

      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + updateUserInfoUrl, body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            save();
          }
        });
      } else {
        isLoading.value = false;
        Get.back();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Select image from the mobile phone
  Future getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      debugPrint(pickedFile.path);
      images.value = File(pickedFile.path);
      uploadProfilePicture();
    } else {
      debugPrint('No image selected.');
    }
  }

  // Call the API to upload the profile picture selected by the Agent
  uploadProfilePicture() async {
    isLoading.value = true;
    try {
      var responseBody = await CoreService().putFileWithoutAuth(
          upload: images.value.readAsBytesSync(),
          filename: images.value.path.split("/").last,
          url: baseUrl +
              updateProfilePicture +
              'agent/' +
              agentDetailsResponseModel.email!,
          key: 'upload');
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        profilePictureUrl.value = responseBody.toString();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Add certificate after user is logged in from the profile page
  addCertificate(Map<String, dynamic> body, BuildContext context) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .postWithoutAuth(url: baseUrl + addCertificateUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        addCertificateResponseModel =
            AddCertificateResponseModel.fromJson(responseBody);
        listOfCertificates.add(addCertificateResponseModel.showData!);
        isLoading.value = false;
        clearFileds();
        Navigator.pop(context);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Add award from the profile details page after user is logged in
  addAward(Map<String, dynamic> body, BuildContext context) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .postWithoutAuth(url: baseUrl + addAwardUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        addAwardsResponseModel = AddAwardsResponseModel.fromJson(responseBody);
        listOfAwards.add(addAwardsResponseModel.showData!);
        isLoading.value = false;
        clearFileds();
        Navigator.pop(context);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Clear all the fields after entering details of award and certificate or closing he bottom sheet
  clearFileds() {
    certificationAndAwardNameTextEditingController.clear();
    certificationAncdAwardYearTextEditingController.clear();
    certificationAncdAwardDescriptionTextEditingController.clear();
  }

  // Delete award after login from the profile details page
  deleteAward(String awardId) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().deleteWithoutAuth(
          url: baseUrl +
              deleteAwardUrl +
              agentDetailsResponseModel.email! +
              '/' +
              awardId);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        // Clear the awards list
        listOfAwards.clear();
        // Add the awards in the certificate list, that we receive from the API after deleting
        deleteAwardsResponseModel =
            DeleteAwardsResponseModel.fromJson(responseBody);
        listOfAwards.addAll(deleteAwardsResponseModel.existingAwards!);
        isLoading.value = false;
        clearFileds();
        showSuccessToast(deleteAwardsResponseModel.message.toString());
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Delete certificate after login from the profile details page
  deleteCertificate(String certificateId) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().deleteWithoutAuth(
          url: baseUrl +
              deleteCertificateUrl +
              agentDetailsResponseModel.email! +
              '/' +
              certificateId);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        //Clear the certificates list
        listOfCertificates.clear();
        //Add the certificates in the certificate list, that we receive from the API after deleting
        deleteCertificatesResponseModel =
            DeleteCertificatesResponseModel.fromJson(responseBody);
        listOfCertificates
            .addAll(deleteCertificatesResponseModel.existingAwards!);
        isLoading.value = false;
        clearFileds();
        showSuccessToast(deleteCertificatesResponseModel.message.toString());
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  String? changeCountryCode = AppLabels.defaultCountryCode;
  String? countryCodeLabel = AppLabels.defaultCountryLabel;

  // Change the mobile of the user after user logged in
  changeMobileSave() async {
    try {
      isLoading.value = true;

      Get.back();
      var body = EnterMobileScreenSendModel(
          contryCode: changeCountryCode.toString(),
          countryLabel: countryCodeLabel.toString(),
          mobile: changeMobileNumberTextEditingController.text);

      var responseBody = await CoreService().putWithAuth(
          url: baseUrl + chgPhoneAfterLoginUrl, body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
        changeMobileNumberTextEditingController.clear();
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            changeMobileSave();
          }
        });
      } else {
        isLoading.value = false;
        Get.toNamed(confirmMobileScreen, arguments: [
          agentDetailsResponseModel.email.toString(),
          countryCode,
          body.mobile,
          body.countryLabel,
          null,
          true // This is used only for change mobile after user is logged in
        ]);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Change the email of the user after login
  changeEmail(BuildContext context, Map<String, dynamic> body) async {
    try {
      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + changeEmailAfterLoginUrl, body: body);
      if (responseBody == null) {
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            changeEmail(context, body);
          }
        });
      } else {
        Navigator.pop(context);
        Get.offAndToNamed(confirmEmailScreen, arguments: [
          changeEmailTextEditingController.text,
          'FromMyAccount'
        ]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
