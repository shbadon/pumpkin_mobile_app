import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:pumpkin/models/response_models/set_password_screen_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/toast.dart';

class SplashScreenController extends GetxController {
  final getStotageInstance = GetStorage();
  Rx<AgentDetailsResponseModel> agentDetailsResponseModel =
      AgentDetailsResponseModel().obs;
  RxBool isDeviceAuthEnabled = false.obs;
  RxBool isTWOFAEnabled = false.obs;

  // This function is used to check if the user is an old user or a new user, based on that we navigate the user to the respective screen
  // If the user is mew user then we navigate the user to the walkthrough screen
  // If the user is old user then we navigate to the respective screen based on the completion of profile, if everything is complete then navigate to dashboard screen
  void checIfNewUserOrExistingUser() {
    debugPrint(getStotageInstance.read(StorageKeys.newUser).toString());
    try {
      if (getStotageInstance.read(StorageKeys.newUser) == null ||
          getStotageInstance.read(StorageKeys.newUser) == true) {
        Get.offAndToNamed(walkthroughScreen);
      } else {
        loginUserWithAccessToken();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // This function is used to login the user with the access token
  // If there is no access token stored locally then the user will be navigated to loginScreen
  // If there is access token stored locally then we will get the user data with the accessToken
  loginUserWithAccessToken() async {
    try {
      if (getStotageInstance.read(StorageKeys.accessToken) == null ||
          getStotageInstance.read(StorageKeys.accessToken) == '') {
        if (getStotageInstance.read(StorageKeys.userEmail) != null) {
          getAgentDetailsWithEmail(); //Get agent details with email, to check if biometric is enabled or not
        } else {
          isDeviceAuthEnabled.value =
              false; //Since accessToken is not here we cannot check the inDevice auth is enabled or not
          Get.offAndToNamed(loginScreen);
        }
      } else {
        getUserDataWithAccessToken();
      }
    } catch (e) {
      // Get.offAndToNamed(loginScreen);
      debugPrint(e.toString());
    }
  }

  // Function to get the user data with the accessToken stored locally
  getUserDataWithAccessToken() async {
    try {
      var responseBody = await CoreService().getAgentDetailsWithoutAuth(
        url: baseUrl +
            getAgentDetailsWithTokenUrl +
            getStotageInstance.read(StorageKeys.accessToken),
      );
      if (responseBody == null) {
        Get.offAndToNamed(loginScreen);
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            getUserDataWithAccessToken();
          }
        });
      } else {
        //Get the agent details and check the status of the account and then navigate the user to respectie page
        agentDetailsResponseModel.value =
            AgentDetailsResponseModel.fromJson(responseBody);
        isDeviceAuthEnabled.value = agentDetailsResponseModel.value
            .isDeviceAuthEnabled; //Assigning the value we got from agentDetails with accessToken
        checkPageNavigation(
            agentDetailsResponseModel: agentDetailsResponseModel.value);
      }
    } catch (e) {
      // Get.offAndToNamed(loginScreen);
      debugPrint(e.toString());
    }
  }

  // Check the status of completion of the Agent profile, based on the level of completion we will navigate to the respective page.
  // Eg: If email not verified will navigate to confirm email screen (First we will call the API to send the verification code to the email entered during login)
  checkPageNavigation({
    required AgentDetailsResponseModel agentDetailsResponseModel,
  }) async {
    try {
      if (agentDetailsResponseModel.status == 0 &&
          agentDetailsResponseModel.designamtion != null) {
        showErrorToast('Account locked, contact admin');
        Get.offAndToNamed(loginScreen);
      } else if (agentDetailsResponseModel.status == 0 ||
          agentDetailsResponseModel.status == null) {
        if (agentDetailsResponseModel.isEmailVerified == 0) {
          sendOtpToEmail(agentDetailsResponseModel
              .email!); //Sending OTP to the email address entered in the LoginScreen
          Get.offAndToNamed(confirmEmailScreen, arguments: [
            agentDetailsResponseModel.email!
          ]); //Passing email as argument to verify email screen
        } else if (agentDetailsResponseModel.isMobileVerified == 0) {
          Get.offAndToNamed(enterMobileNumberScreen, arguments: [
            agentDetailsResponseModel.email!
          ]); //Passing email as argument to the enterMobileNumber screen, so that user can verify the number (API requires the email)
        } else if (agentDetailsResponseModel.isPasswordSet == false) {
          Get.offAndToNamed(setPasswordScreen,
              arguments: [agentDetailsResponseModel.email]);
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
          // TODO: Navigate to dashboard with agent details or call API in dashboard to get the agent details
          Get.offAndToNamed(mainDashBoardScreen);
        }
      } else if (agentDetailsResponseModel.isTWOFAEnabled) {
        Get.offAndToNamed(twofactorConfirmationScreen,
            arguments: [null, 'fromSplashScreen']);
      } else if (agentDetailsResponseModel.isMobileVerified == 0) {
        Get.offAndToNamed(enterMobileNumberScreen, arguments: [
          agentDetailsResponseModel.email!,
          'FromSocilaAuth'
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
        // This will run if Status is 1 instead of 0, which means the user has completed all the profile information
        // TODO: Navigate to dashboard to agent details
        if (getStotageInstance.read(StorageKeys.accessToken) == null ||
            getStotageInstance.read(StorageKeys.accessToken) == '') {
          Get.offAndToNamed(
              loginScreen); //Even if everything is okay for the account, the user still manually logged out and we removed the accessToken from the storage, so user will be navigated to login page
        } else {
          Get.offAndToNamed(
              mainDashBoardScreen); //If acccessToken is present the  user will be navigated to main dashboard
        }
      }
    } catch (e) {
      // Get.offAndToNamed(loginScreen);
      debugPrint(e.toString());
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

  // Get user details with email
  getAgentDetailsWithEmail() async {
    try {
      var responseBody = await CoreService().getWithoutAuth(
        url: baseUrl +
            getAgentDetailsUrl +
            getStotageInstance.read(StorageKeys.userEmail),
      );
      if (responseBody == null) {
        Get.offAndToNamed(loginScreen);
      } else {
        //Get the agent details and check the status of the account and then navigate the user to respectie page
        agentDetailsResponseModel.value =
            AgentDetailsResponseModel.fromJson(responseBody);
        isDeviceAuthEnabled.value = agentDetailsResponseModel.value
            .isDeviceAuthEnabled; //Assigning the value we got from agentDetails with accessToken
        checkPageNavigation(
            agentDetailsResponseModel: agentDetailsResponseModel.value);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
