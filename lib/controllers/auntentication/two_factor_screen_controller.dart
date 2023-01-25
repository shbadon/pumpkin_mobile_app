import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/storage_controller.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:pumpkin/models/response_models/login_screen_response_model.dart';
import 'package:pumpkin/models/response_models/set_password_screen_response_model.dart';
import 'package:pumpkin/models/response_models/two_factor_enable_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class TwoFactorScreenController extends GetxController {
  RxBool isFaceIDEnabled = false.obs;
  RxBool isTwoFactorEnabled = false.obs;
  RxBool isLoading = false.obs;
  Rx<ButtonStatus> buttonStatus = ButtonStatus.disabled.obs;

  var otpController = TextEditingController();

  var twoFactorEnableResponseModel = TwoFactorEnableResponseModel().obs;
  Map<String, dynamic> loginBody = {};
  String source = '';
  Rx<LoginScreenResponseModel> loginScreenResponseModel =
      LoginScreenResponseModel().obs;
  Rx<AgentDetailsResponseModel> agentDetailsResponseModel =
      AgentDetailsResponseModel().obs;
  StorageController storageController =
      GetControllers.shared.getStorageController();

  @override
  void onInit() {
    otpController.addListener(() {
      if (otpController.text.length == 6) {
        buttonStatus.value = ButtonStatus.enabled;
      } else {
        buttonStatus.value = ButtonStatus.disabled;
      }
    });
    getArguments();
    super.onInit();
  }

  getArguments() {
    if (Get.arguments != null) {
      if (Get.arguments[0] == null) {
        source = Get.arguments[1];
      } else {
        loginBody = Get.arguments[0];
        source = Get.arguments[1];
      }
    }
  }

  Future<void> useAuthenticatorApp() async {
    try {
      isLoading.value = true;
      var responseBody =
          await CoreService().postWithAuth(url: baseUrl + enable2FaUrl);
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            useAuthenticatorApp();
          }
        });
      } else {
        twoFactorEnableResponseModel.value =
            TwoFactorEnableResponseModel.fromJson(responseBody);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // The verification of codes takes places for three scenarios,
  // One is while eneabling the 2FA
  // Another is if 2FA is ebabled then we come to this screen from login screen and run the login function here and pass the verification code and push the user to main dashboard
  // The third scenario is when we navigate from the splash screen (When the user opens the app and sees splash screen), we check if 2fa enabled and if enabled then navigate to confirmation screen and then to main dashboard
  Future<void> verifyCode() async {
    // This function is called when the 2FA is enabled and user needs to verify the account with 2FA code to navigate to the main dashboard
    if (source == 'fromLoginScreen') {
      loginBody.addIf(otpController.text.isNotEmpty,
          'twoFactorAuthenticationCode', otpController.text);
      try {
        buttonStatus.value = ButtonStatus.verifying;
        var responseBody = await CoreService()
            .postWithoutAuth(url: baseUrl + loginUrl, body: loginBody);
        if (responseBody == null) {
          buttonStatus.value = ButtonStatus.error;
        } else {
          loginScreenResponseModel.value =
              LoginScreenResponseModel.fromJson(responseBody);
          loginScreenResponseModel.value.accessToken;
          isLoading.value = false;
          storageController.getStotageInstance.write(
              StorageKeys.accessToken,
              loginScreenResponseModel
                  .value.accessToken); //Store access token in local storage
          storageController.getStotageInstance.write(
              StorageKeys.refreshToken,
              loginScreenResponseModel
                  .value.refreshToken); //Store refresh token in local storage
          buttonStatus.value = ButtonStatus.verified;
          Get.offAllNamed(
              mainDashBoardScreen); //Navigating to the main dashboard screen
        }
      } catch (e) {
        buttonStatus.value = ButtonStatus.enabled;
        debugPrint(e.toString());
      }
    }
    // This is the screnario when we navigate from splash screen and then after verifying we move to main dashboard
    else if (source == 'fromSplashScreen') {
      try {
        buttonStatus.value = ButtonStatus.verifying;

        var responseBody = await CoreService()
            .putWithAuth(url: baseUrl + check2FaStatusUrl + otpController.text);
        if (responseBody == null) {
          buttonStatus.value = ButtonStatus.error;
        } else if (responseBody == 401) {
          CoreService()
              .getAccessToken(url: baseUrl + getAccessTokenUrl)
              .then((value) {
            if (value == null) {
              Get.offAllNamed(loginScreen);
            } else {
              verifyCode();
            }
          });
        } else {
          buttonStatus.value = ButtonStatus.verified;
          Get.offAllNamed(
              mainDashBoardScreen); //Navigating to the main dashboard screen
        }
      } catch (e) {
        buttonStatus.value = ButtonStatus.enabled;
        debugPrint(e.toString());
      }
    }
    // Login through google when 2fa is enabled
    else if (source == 'fromLoginScreenGoogle') {
      loginBody.addIf(otpController.text.isNotEmpty,
          'twoFactorAuthenticationCode', otpController.text);
      var responseBody = await CoreService().postWithoutAuthForSocialAuth(
          url: baseUrl + googleVerifyUrl, body: loginBody);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        loginScreenResponseModel.value =
            LoginScreenResponseModel.fromJson(responseBody);
        loginScreenResponseModel.value.accessToken;
        isLoading.value = false;
        storageController.getStotageInstance.write(
            StorageKeys.accessToken,
            loginScreenResponseModel
                .value.accessToken); //Store access token in local storage
        storageController.getStotageInstance.write(
            StorageKeys.refreshToken,
            loginScreenResponseModel
                .value.refreshToken); //Store refresh token in local storage
        getAgentDetailsAfterSocialAuth();
      }
    } else if (source == 'fromLoginScreenFacebook') {
      loginBody.addIf(otpController.text.isNotEmpty,
          'twoFactorAuthenticationCode', otpController.text);
      var responseBody = await CoreService().postWithoutAuthForSocialAuth(
          url: baseUrl + facebookVerifyUrl, body: loginBody);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        loginScreenResponseModel.value =
            LoginScreenResponseModel.fromJson(responseBody);
        loginScreenResponseModel.value.accessToken;
        isLoading.value = false;
        storageController.getStotageInstance.write(
            StorageKeys.accessToken,
            loginScreenResponseModel
                .value.accessToken); //Store access token in local storage
        storageController.getStotageInstance.write(
            StorageKeys.refreshToken,
            loginScreenResponseModel
                .value.refreshToken); //Store refresh token in local storage
        getAgentDetailsAfterSocialAuth();
      }
    } else if (source == 'fromLoginScreenApple') {
      loginBody.addIf(otpController.text.isNotEmpty,
          'twoFactorAuthenticationCode', otpController.text);
      var responseBody = await CoreService().postWithoutAuthForSocialAuth(
          url: baseUrl + appleVerifyUrl, body: loginBody);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        loginScreenResponseModel.value =
            LoginScreenResponseModel.fromJson(responseBody);
        loginScreenResponseModel.value.accessToken;
        isLoading.value = false;
        storageController.getStotageInstance.write(
            StorageKeys.accessToken,
            loginScreenResponseModel
                .value.accessToken); //Store access token in local storage
        storageController.getStotageInstance.write(
            StorageKeys.refreshToken,
            loginScreenResponseModel
                .value.refreshToken); //Store refresh token in local storage
        getAgentDetailsAfterSocialAuth();
      }
    }
    // This is the screnario when we want to verify the code for enabling the 2FA
    else {
      debugPrint("ontap verifyCode api");

      try {
        buttonStatus.value = ButtonStatus.verifying;

        var responseBody = await CoreService()
            .putWithAuth(url: baseUrl + check2FaStatusUrl + otpController.text);
        if (responseBody == null) {
          buttonStatus.value = ButtonStatus.error;
        } else if (responseBody == 401) {
          CoreService()
              .getAccessToken(url: baseUrl + getAccessTokenUrl)
              .then((value) {
            if (value == null) {
              Get.offAllNamed(loginScreen);
            } else {
              verifyCode();
            }
          });
        } else {
          buttonStatus.value = ButtonStatus.verified;
          Get.offAllNamed(loginScreen); //Navigating to the login screen
        }
      } catch (e) {
        buttonStatus.value = ButtonStatus.enabled;
        debugPrint(e.toString());
      }
    }
  }

  void launchAuthenticatorApp() async {
    String authenticatorLink =
        twoFactorEnableResponseModel.value.otpauthUrl.toString();
    Get.toNamed(
        twofactorConfirmationScreen); //Navigating to the dashboard screen
    if (!await launchUrl(Uri.parse(authenticatorLink))) {
      throw 'Could not launch $authenticatorLink';
    }
  }

  // Here we will get the agent account details based on the accessToken and check the navigation based on that
  getAgentDetailsAfterSocialAuth() async {
    try {
      isLoading.value = false;
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
            getAgentDetailsAfterSocialAuth();
          }
        });
      } else {
        agentDetailsResponseModel.value =
            AgentDetailsResponseModel.fromJson(responseBody);

        // Storing email in local storage, to use for inDevice auth
        storageController.getStotageInstance.write(
            StorageKeys.userEmail, agentDetailsResponseModel.value.email);
        checkPageNavigationForSocialAuth(
            agentDetailsResponseModel: agentDetailsResponseModel.value);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  checkPageNavigationForSocialAuth(
      {required AgentDetailsResponseModel agentDetailsResponseModel}) {
    if (agentDetailsResponseModel.isEmailVerified == 0) {
      sendOtpToEmail(agentDetailsResponseModel
          .email!); //Sending OTP to the email address entered in the LoginScreen
      Get.offAndToNamed(confirmEmailScreen, arguments: [
        agentDetailsResponseModel.email!
      ]); //Passing email as argument to verify email screen
    } else if (agentDetailsResponseModel.isMobileVerified == 0) {
      Get.offAndToNamed(enterMobileNumberScreen, arguments: [
        agentDetailsResponseModel.email!,
        'FromSocilaAuth'
        //Passing this argument because we don't need to show password screen for social auth flow
      ]); //Passing email as argument to the enterMobileNumber screen, so that user can verify the number (API requires the email)
    } else if (agentDetailsResponseModel.dateOfBirth == null) {
      Get.offAndToNamed(setupProfileScreen, arguments: [
        SetPasswordScreenResponseModel(
          email: agentDetailsResponseModel.email,
          firstName: agentDetailsResponseModel.firstName,
          lastName: agentDetailsResponseModel.lastName,
          mobileNumbers: agentDetailsResponseModel.mobile,
          countryCode: agentDetailsResponseModel.countryCode,
        )
      ]); //Passing SetPasswordScreen response model as argument to the setup profile screen, so that user can complete the profile
    } else if (agentDetailsResponseModel.designamtion == null) {
      Get.offAndToNamed(completeProfileScreen, arguments: [
        agentDetailsResponseModel.email!
      ]); //Passing email as argument to the complete profile screen, so that user can complete the profile
    } else {
      Get.offAndToNamed(mainDashBoardScreen);
    }
  }

  // This function is used to send OTP to the email, when user has not verified the email address
  sendOtpToEmail(String email) async {
    try {
      var responseBody = await CoreService().putWithoutAuth(
          url: baseUrl + resendEmailCodeUrl + 'VerifyEmail/' + email);
      if (responseBody != null) {
        showInfoToast('Verification code sent');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
