import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/set_password_screen_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';

//*Note: This controller is used in both the SetPassword screen and the Set new passoword screen
class ChangePasswordScreenController extends GetxController {
  TextEditingController oldPasswordTextEditingController =
      TextEditingController();
  TextEditingController newPasswordTextEditingController =
      TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  RxBool isLoading = false.obs;
  late String email = "";
  Rx<SetPasswordScreenResponseModel> setPasswordScreenResponseModel =
      SetPasswordScreenResponseModel().obs;
  Rx<ButtonStatus> buttonStatus = ButtonStatus.enabled.obs;

  // Change password after user logged in from the My profile page
  changePassword(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + changePasswordUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            changePassword(body);
          }
        });
      } else {
        isLoading.value = false;
        buttonStatus.value = ButtonStatus.verified;
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
