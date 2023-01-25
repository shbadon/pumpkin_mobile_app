import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';

class EnterMobileScreenController extends GetxController {
  TextEditingController mobilenumberTextEditingController =
      TextEditingController();
  Rx<ButtonStatus> buttonStatus = ButtonStatus.disabled.obs;
  RxString email = ''.obs;
  late String? countryCode;
  late String? countryCodeLabel;
  RxBool isLoading = false.obs;
  String? source;
  @override
  void onInit() {
    countryCode = AppLabels.defaultCountryCode;
    countryCodeLabel = AppLabels.defaultCountryLabel;
    email.value = Get.arguments == null
        ? ''
        : Get.arguments[
            0]; // Get the arguments from the previous screen which is email
    source = Get.arguments != null && Get.arguments.length > 1
        ? Get.arguments[1]
        : null;
    // Add listener to the mobile number textediting controller, based on which the button status will change
    mobilenumberTextEditingController.addListener(() {
      if (mobilenumberTextEditingController.text.length > 5) {
        buttonStatus.value = ButtonStatus.enabled;
      } else {
        buttonStatus.value = ButtonStatus.disabled;
      }
    });
    super.onInit();
  }

  // Function that calls the API to send the verification code to the mobile number entered by the user
  sendOtptoMobile(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().putWithoutAuth(
          url: baseUrl + sendOtpToMobileUrl + email.value, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        // Naviogate to the confirmed mobile screen with arguments
        Get.toNamed(confirmMobileScreen, arguments: [
          email.value,
          body['country_code'],
          body['mobile'],
          body['country_code_label'],
          source //Passing this argument because we don't need to show password screen for social auth flow
        ]);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
