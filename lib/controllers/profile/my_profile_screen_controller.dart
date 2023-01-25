import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/storage_controller.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:pumpkin/models/response_models/company_details_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';

class MyProfileScreenController extends GetxController {
  RxBool isFaceIDEnabled = false.obs;
  RxBool isTwoFactorEnabled = false.obs;
  RxBool isLoading = false.obs;

  StorageController storageController =
      GetControllers.shared.getStorageController();
  Rx<AgentDetailsResponseModel> agentDetailsResponseModel =
      AgentDetailsResponseModel().obs;
  CompanyDetailsResponseModel companyDetailsResponseModel =
      CompanyDetailsResponseModel();

  @override
  void onInit() {
    getCompanyDetails();
    super.onInit();
  }

  // get profile details of the Agent whenever we enter the page
  getProfileDetails() async {
    debugPrint('****');
    try {
      isLoading.value = true;
      var responseBody = await CoreService().getAgentDetailsWithoutAuth(
          url: baseUrl +
              getAgentDetailsWithTokenUrl +
              storageController.getStotageInstance
                  .read(StorageKeys.accessToken));
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            getProfileDetails();
          }
        });
      } else {
        agentDetailsResponseModel.value =
            AgentDetailsResponseModel.fromJson(responseBody);
        isTwoFactorEnabled.value =
            agentDetailsResponseModel.value.isTWOFAEnabled;
        isFaceIDEnabled.value =
            agentDetailsResponseModel.value.isDeviceAuthEnabled;
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Call this when 2fa is turned onn and the agent needs to turn off
  disAble2fa() async {
    try {
      var responseBody =
          await CoreService().putWithAuth(url: baseUrl + disable2FaUrl);
      if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            disAble2fa();
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getCompanyDetails() async {
    try {
      var responseBody =
          await CoreService().getWithAuth(url: baseUrl + constUsUrl);
      if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            disAble2fa();
          }
        });
      } else {
        companyDetailsResponseModel =
            CompanyDetailsResponseModel.fromJson(responseBody['data']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
