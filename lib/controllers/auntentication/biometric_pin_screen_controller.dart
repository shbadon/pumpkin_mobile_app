import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/storage_controller.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/toast.dart';

class BiometricPinScreenController extends GetxController {
  TextEditingController pinTextEditingController = TextEditingController();
  TextEditingController pinConfirmTextEditingController =
      TextEditingController();
  TextEditingController otpTextEditingController = TextEditingController();

  Rx<ButtonStatus> buttonStatus = ButtonStatus.disabled.obs;
  Rx<ButtonStatus> confirmEmailbuttonStatus = ButtonStatus.disabled.obs;

  Rx<ButtonStatus> confirmbuttonStatus = ButtonStatus.disabled.obs;
  StorageController storageController =
      GetControllers.shared.getStorageController();
  RxBool needToEnableInDeviceAuth = false.obs;
  RxBool resendLoading = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    needToEnableInDeviceAuth.value = Get.arguments[0] == 'enableInDeviceAuth'
        ? true
        : false; //This argument is used to decide which function we need to call, if we need to enable or diable InDevice authentication
    // Listener added to check the length and based on the legth change the state of the button
    pinTextEditingController.addListener(() {
      if (pinTextEditingController.text.length == 4) {
        buttonStatus.value = ButtonStatus.enabled;
      } else {
        buttonStatus.value = ButtonStatus.disabled;
      }
    });
    // Listener added to check the length and based on the legth change the state of the button
    pinConfirmTextEditingController.addListener(() {
      if (pinConfirmTextEditingController.text.length == 4) {
        confirmbuttonStatus.value = ButtonStatus.enabled;
      } else {
        confirmbuttonStatus.value = ButtonStatus.disabled;
      }
    });
    // Listener added to check the length and based on the legth change the state of the button
    otpTextEditingController.addListener(() {
      if (otpTextEditingController.text.length == 6) {
        confirmEmailbuttonStatus.value = ButtonStatus.enabled;
      } else {
        confirmEmailbuttonStatus.value = ButtonStatus.disabled;
      }
    });
    super.onInit();
  }

  // First time user sets the PIN
  setPin() {
    Get.offAndToNamed(biometricPinConfirmScreen,
        arguments: [pinTextEditingController.text]);
  }

  // This function will generate the digital token, that we will store in local storage
  confirmPin(Map<String, dynamic> body) async {
    if (needToEnableInDeviceAuth.value) {
      // Enable the indeviceAuth
      try {
        if (pinTextEditingController.text !=
            pinConfirmTextEditingController.text) {
          showErrorToast("PIN don't match");
        } else {
          buttonStatus.value = ButtonStatus.verifying;
          var responseBody = await CoreService()
              .postWithAuth(url: baseUrl + generateDigitalTokenUrl, body: body);
          if (responseBody == null) {
            buttonStatus.value = ButtonStatus.error;
          } else if (responseBody == 401) {
            CoreService()
                .getAccessToken(url: baseUrl + getAccessTokenUrl)
                .then((value) {
              if (value == null) {
                Get.offAllNamed(loginScreen);
              } else {
                confirmPin(body);
              }
            });
          } else {
            storageController.getStotageInstance.write(StorageKeys.digitalToken,
                responseBody['digital_token']); //Storing digital token locally
            enableInDeviceAuth(body: {'isDeviceAuthenticationEnable': true});
          }
        }
      } catch (e) {
        buttonStatus.value = ButtonStatus.error;
        debugPrint(e.toString());
      }
    } else {
      // Diable the inDeviceAuth
      try {
        buttonStatus.value = ButtonStatus.verifying;
        var responseBody = await CoreService()
            .postWithAuth(url: baseUrl + disableInDeviceAuthUrl, body: body);
        if (responseBody == null) {
          buttonStatus.value = ButtonStatus.error;
        } else if (responseBody == 401) {
          CoreService()
              .getAccessToken(url: baseUrl + getAccessTokenUrl)
              .then((value) {
            if (value == null) {
              Get.offAllNamed(loginScreen);
            } else {
              confirmPin(body);
            }
          });
        } else {
          buttonStatus.value = ButtonStatus.verified;
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
        }
      } catch (e) {
        buttonStatus.value = ButtonStatus.error;
        debugPrint(e.toString());
      }
    }
  }

  // Emnable the indevice authentication (After getting the Digital token from server)
  enableInDeviceAuth({required Map<String, bool> body}) async {
    try {
      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + enableDeviceAuthUrl, body: body);
      if (responseBody == null)
        return; //if null then run the code beneath it //TODO: Need to check it
      buttonStatus.value = ButtonStatus.verified;
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    } catch (e) {
      buttonStatus.value = ButtonStatus.error;
      debugPrint(e.toString());
    }
  }

  // Send email to user to verify the email before resetting the PIN of Biometric
  sendEmail() async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService().putWithoutAuth(
        url: baseUrl +
            sendEmailToExistIdUrl +
            'VerifyEmail/' +
            storageController.getStotageInstance.read(StorageKeys.userEmail),
      );
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        Get.offAndToNamed(confirmEmailScreenForPinReset);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Resend the OTP to the registered email, this is used when the user forgets the PIN
  resendEmail() async {
    try {
      resendLoading.value = true;
      var responseBody = await CoreService().putWithoutAuth(
        url: baseUrl +
            sendEmailToExistIdUrl +
            'VerifyEmail/' +
            storageController.getStotageInstance.read(StorageKeys.userEmail),
      );
      if (responseBody == null) {
        resendLoading.value = false;
      } else {
        resendLoading.value = false;
        showInfoToast('Verification code sent');
      }
    } catch (e) {
      resendLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Verify email of the user before setting up a new PIN
  verifyEmail() async {
    try {
      confirmEmailbuttonStatus.value = ButtonStatus.verifying;
      var responseBody = await CoreService()
          .putWithoutAuth(url: baseUrl + verifyEmailCodeUrl, body: {
        'verification_code': otpTextEditingController.text,
        'email':
            storageController.getStotageInstance.read(StorageKeys.userEmail),
        'user_type': "agent"
      });
      if (responseBody == null) {
        confirmEmailbuttonStatus.value = ButtonStatus.error;
      } else {
        disableInDeviceAuth();
        confirmEmailbuttonStatus.value = ButtonStatus.verified;
        Get.offAndToNamed(biometricPinScreen,
            arguments: ['enableInDeviceAuth']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Functions to disable the inDevice Authentication
  disableInDeviceAuth() async {
    try {
      var responseBody = await CoreService().putWithAuth(
          url: baseUrl + enableDeviceAuthUrl,
          body: {'isDeviceAuthenticationEnable': false});
      if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            disableInDeviceAuth();
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
