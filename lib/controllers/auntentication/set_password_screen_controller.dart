import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pumpkin/models/response_models/set_password_screen_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';

//*Note: This controller is used in both the SetPassword screen and the Set new passoword screen
class SetPasswordScreenController extends GetxController {
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  RxBool isLoading = false.obs;
  late String email;
  Rx<SetPasswordScreenResponseModel> setPasswordScreenResponseModel =
      SetPasswordScreenResponseModel().obs;
  final getStotageInstance = GetStorage();
  Rx<ButtonStatus> buttonStatus = ButtonStatus.enabled.obs;

  @override
  void onInit() {
    email = Get.arguments != null ? Get.arguments[0] : '';
    super.onInit();
  }

  // This function is called from the Set password screen, when user goes to registration flow
  setPassword(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .putWithoutAuth(url: baseUrl + setUpPasswordUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        // Navigating to complete profile screen and passing Email with which we registered
        setPasswordScreenResponseModel.value =
            SetPasswordScreenResponseModel.fromJson(responseBody);
        getStotageInstance.write(StorageKeys.accessToken,
            setPasswordScreenResponseModel.value.accessToken);
        getStotageInstance.write(StorageKeys.refreshToken,
            setPasswordScreenResponseModel.value.refreshToken);
        await Get.toNamed(setupProfileScreen,
            arguments: [setPasswordScreenResponseModel.value]);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // This function is called from the Set New password screen, when user goes to forget password flow
  setNewPassword(Map<String, dynamic> body) async {
    try {
      buttonStatus.value = ButtonStatus.verifying;
      var responseBody = await CoreService()
          .putWithoutAuth(url: baseUrl + setUpPasswordUrl, body: body);
      if (responseBody == null) {
        buttonStatus.value = ButtonStatus.error;
      } else {
        buttonStatus.value = ButtonStatus.verified;
        // Navigating to complete profile screen and passing Email with which we registered
        setPasswordScreenResponseModel.value =
            SetPasswordScreenResponseModel.fromJson(responseBody);
        getStotageInstance.write(StorageKeys.accessToken,
            setPasswordScreenResponseModel.value.accessToken);
        getStotageInstance.write(StorageKeys.refreshToken,
            setPasswordScreenResponseModel.value.refreshToken);
        Future.delayed(const Duration(seconds: 2), () async {
          await Get.offAllNamed(loginScreen);
        });
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  setPasswordAfterLogin({required Map<String, dynamic> body}) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + setupPasswordAfterLoginUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            setPasswordAfterLogin(body: body);
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
}
