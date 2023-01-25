import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/add_awards_response_model.dart';
import 'package:pumpkin/models/response_models/add_certificate_response_model.dart';
import 'package:pumpkin/models/response_models/delete_award_response_model.dart';
import 'package:pumpkin/models/response_models/delete_certificate_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class CompleteProfileScreenController extends GetxController {
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
  RxBool isLoading = false.obs;
  RxString email = ''.obs;
  RxList<Award> listOfAwards = <Award>[].obs;
  RxList<Certificate> listOfCertificates = <Certificate>[].obs;
  AddAwardsResponseModel addAwardsResponseModel = AddAwardsResponseModel();
  AddCertificateResponseModel addCertificateResponseModel =
      AddCertificateResponseModel();
  DeleteAwardsResponseModel deleteAwardsResponseModel =
      DeleteAwardsResponseModel();
  DeleteCertificatesResponseModel deleteCertificatesResponseModel =
      DeleteCertificatesResponseModel();

  @override
  void onInit() {
    email.value = Get.arguments[0]; //Argument to get email
    super.onInit();
  }

  // Complete profile in the onboarding flow
  completeProfile(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .postWithoutAuth(url: baseUrl + completeProfileUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.offAllNamed(mainDashBoardScreen);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Add award in the onboarding flow
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

  // Add certificate in the onboarding flow
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

  // Clear the award or certificate textfields after we enter an award or certificate or else if the close the bottom sheet
  clearFileds() {
    certificationAndAwardNameTextEditingController.clear();
    certificationAncdAwardYearTextEditingController.clear();
    certificationAncdAwardDescriptionTextEditingController.clear();
  }

  // Delete award in onboarding flow
  deleteAward(String awardId) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().deleteWithoutAuth(
          url: baseUrl + deleteAwardUrl + email.value + '/' + awardId);
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
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Delete certificate in the onboarfing flow
  deleteCertificate(String certificateId) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().deleteWithoutAuth(
          url: baseUrl +
              deleteCertificateUrl +
              email.value +
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
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
