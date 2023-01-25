import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class ForgotPasswordScreenController extends GetxController {
  TextEditingController emailTextEditingController = TextEditingController();
  RxBool isLoading = false.obs;

// get OTP for the email enterd in the text field
  getOtpForEmail({required String email, String userType = 'agent/'}) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().getWithoutAuth(
        url: baseUrl + forgotPasswordUrl + userType + email,
      );
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        // Navigate to the confirm Email screen
        await Get.toNamed(confirmEmailScreen, arguments: [
          email,
          'fromForgotPassword'
        ]); //The second argumnet we are passing to the confirm email screen because we need to check the navigation in confirm email screen, because there are multiple ways which navigate to the confirm email screen
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  getOtpForEmailAfterLogin(
      {required Map<String, dynamic> body, required String email}) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().putWithAuth(
          url: baseUrl + sendForgotPasswordEmailAfterLoginUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            getOtpForEmailAfterLogin(body: body, email: email);
          }
        });
      } else {
        isLoading.value = false;
        await Get.offAndToNamed(confirmEmailScreenAfterLogin,
            arguments: [email]);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
