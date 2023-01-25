import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/toast.dart';

class ConfirmEmailScreenController extends GetxController {
  TextEditingController otpTextEditingController = TextEditingController();
  RxString email = ''.obs;
  Rx<ButtonStatus> buttonStatus = ButtonStatus.disabled.obs;
  late String pageSource;
  RxBool resendLoading = false.obs;

  @override
  void onInit() {
    // Get the argument from the previous screen, i.e email
    email.value = Get.arguments == null
        ? ''
        : Get.arguments[
            0]; //In the 0th element we get the email id with which we registered
    pageSource = Get.arguments.length > 1 ? Get.arguments[1] : '';
    // Listener added to check the length and based on the legth change the state of the button
    otpTextEditingController.addListener(() {
      if (otpTextEditingController.text.length == 6) {
        buttonStatus.value = ButtonStatus.enabled;
      } else {
        buttonStatus.value = ButtonStatus.disabled;
      }
    });
    super.onInit();
  }

  // This function calls the API to verify the email with verification code sent to the email entered by the user
  verifyEmail(Map<String, dynamic> body) async {
    try {
      buttonStatus.value = ButtonStatus.verifying;
      var responseBody = pageSource == 'FromMyAccount'
          ? await CoreService()
              .putWithAuth(url: baseUrl + verifyEmailAfterLoginUrl, body: body)
          : await CoreService()
              .putWithoutAuth(url: baseUrl + verifyEmailCodeUrl, body: body);
      if (responseBody == null) {
        buttonStatus.value = ButtonStatus.error;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            verifyEmail(body);
          }
        });
      } else {
        buttonStatus.value = ButtonStatus.verified;
        // Navigating to enter mobile number screen with email verified
        Future.delayed(const Duration(seconds: 2), () {
          pageSource == 'fromForgotPassword'
              ? Get.toNamed(setNewPasswordScreen, arguments: [body['email']])
              : pageSource == 'FromMyAccount'
                  ? Get.offAllNamed(loginScreen)
                  : Get.toNamed(enterMobileNumberScreen,
                      arguments: [body['email']]);
        });
      }
    } catch (e) {
      buttonStatus.value = ButtonStatus.enabled;
      debugPrint(e.toString());
    }
  }

  // Resend OTP function
  resendOtp() async {
    try {
      resendLoading.value = true;
      var responseBody = pageSource == 'fromForgotPassword'
          ? await CoreService().putWithoutAuth(
              url: baseUrl +
                  resendEmailCodeUrl +
                  'ResetPassword/' +
                  email
                      .value) // Resend OTP API call when we come to confirm email screen from Login page and click on forgot password
          : pageSource == 'FromMyAccount'
              ? await CoreService()
                  .putWithAuth(url: baseUrl + changeEmailAfterLoginUrl, body: {
                  'email': email.value
                }) //Call this API when we are changing the email from the my account screen
              : await CoreService().putWithoutAuth(
                  url: baseUrl +
                      resendEmailCodeUrl +
                      'VerifyEmail/' +
                      email
                          .value); // Resend OTP API call when we come to confirm email screen other than forgotPassword screen
      if (responseBody != null) {
        resendLoading.value = false;
        showInfoToast('Verification code sent');
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            resendOtp();
          }
        });
      } else {
        resendLoading.value = false;
      }
    } catch (e) {
      resendLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Verify email function when user wants to verify it after user has loggedIn and change password and go to forgot password
  verifyEmailAfterLogin({required Map<String, dynamic> body}) async {
    try {
      buttonStatus.value = ButtonStatus.verifying;
      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + verifyEmailAfterLoginUrl, body: body);
      if (responseBody == null) {
        buttonStatus.value = ButtonStatus.error;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            verifyEmailAfterLogin(body: body);
          }
        });
      } else {
        buttonStatus.value = ButtonStatus.verified;
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAndToNamed(setPasswordScreenAfterLogin);
        });
      }
    } catch (e) {
      buttonStatus.value = ButtonStatus.enabled;
      debugPrint(e.toString());
    }
  }

  // This function is used to resend the OTP in email after login when user tries to change the email
  resentOtpAfterLogin(Map<String, dynamic> body) async {
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
            resentOtpAfterLogin(body);
          }
        });
      } else {
        showInfoToast('Verification code sent');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// This function is used to resend the OTP in email after login when user tries to resend OTP for change password
  newResendOTPAfterLogin(
      {required Map<String, dynamic> body, required String email}) async {
    try {
      resendLoading.value = true;
      var responseBody = await CoreService().putWithAuth(
          url: baseUrl + sendForgotPasswordEmailAfterLoginUrl, body: body);
      if (responseBody == null) {
        resendLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            newResendOTPAfterLogin(body: body, email: email);
          }
        });
      } else {
        resendLoading.value = false;
        showInfoToast('Verification code sent');
      }
    } catch (e) {
      resendLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
