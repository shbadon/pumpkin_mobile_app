import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/send_models/enter_mobile_screen_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/toast.dart';

class ConfirmMobileScreenController extends GetxController {
  TextEditingController otpTextEditingController = TextEditingController();
  RxString mobileNumber = ''.obs;
  RxString countryCode = ''.obs;
  RxString countryCodeLabel = ''.obs;
  RxString email = ''.obs;
  RxBool resendLoading = false.obs;
  RxBool isMobileNumberChange = false.obs;
  String? source;

  Rx<ButtonStatus> buttonStatus = ButtonStatus.disabled.obs;
  @override
  void onInit() {
    isMobileNumberChange.value = Get.arguments.length == 6
        ? Get.arguments[5]
        : false; //Getting isMobileNumberChange as argument from my profile screen
    countryCodeLabel.value = Get.arguments[
        3]; //Getting the country code label as argument from previous screen
    mobileNumber.value = Get.arguments[
        2]; //Getting the mobile number as argument from previous screen
    countryCode.value = Get.arguments[
        1]; //Getting the country code as argument from previous screen
    email.value =
        Get.arguments[0]; //Getting the email as argument from previous screen
    source = Get.arguments[
        4]; //Getting the source, we are checking if it's from social auth, because if it is then, we don't show the set password screen
    // Adding listener to the otp textediting controller, based on which the Button state will change
    otpTextEditingController.addListener(() {
      if (otpTextEditingController.text.length == 6) {
        buttonStatus.value = ButtonStatus.enabled;
      } else {
        buttonStatus.value = ButtonStatus.disabled;
      }
    });
    super.onInit();
  }

  // API call that will verify the mobile number entered by the user in previous screen
  verifyMobile(Map<String, dynamic> body) async {
    try {
      buttonStatus.value = ButtonStatus.verifying;
      var responseBody = await CoreService()
          .putWithoutAuth(url: baseUrl + verifySmsCodeUrl, body: body);
      if (responseBody == null) {
        buttonStatus.value = ButtonStatus.error;
      } else {
        buttonStatus.value = ButtonStatus.verified;
        // Navigating to set-up password screen with email verified
        Future.delayed(const Duration(seconds: 2), () {
          source == null
              ? Get.toNamed(setPasswordScreen, arguments: [email.value])
              : Get.toNamed(mainDashBoardScreen);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // API call that will verify the mobile number entered by the user in previous screen
  verifyChangeMobileNumber(Map<String, dynamic> body) async {
    try {
      buttonStatus.value = ButtonStatus.verifying;
      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + verifySmsAfterLoginUrl, body: body);
      if (responseBody == null) {
        buttonStatus.value = ButtonStatus.error;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            verifyChangeMobileNumber(body);
          }
        });
      } else {
        buttonStatus.value = ButtonStatus.verified;
        // Navigating to set-up password screen with email verified
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(loginScreen);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Resenfd the mobile verification to the phone number
  resendMobileVerificationCode() async {
    try {
      resendLoading.value = true;
      var responseBody = await CoreService().putWithoutAuth(
          url: baseUrl + sendOtpToMobileUrl + email.value,
          body: EnterMobileScreenSendModel(
                  contryCode: countryCode.value,
                  countryLabel: countryCodeLabel.value,
                  mobile: mobileNumber.value)
              .toJson());
      if (responseBody != null) {
        resendLoading.value = false;
        showInfoToast('Verification code sent');
      } else {
        resendLoading.value = false;
      }
    } catch (e) {
      resendLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
