import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/splash_screen_controller.dart';
import 'package:pumpkin/controllers/storage_controller.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:pumpkin/models/response_models/login_screen_response_model.dart';
import 'package:pumpkin/models/response_models/set_password_screen_response_model.dart';
import 'package:pumpkin/models/send_models/apple_verify_send_model.dart';
import 'package:pumpkin/models/send_models/facebook_verify_send_model.dart';
import 'package:pumpkin/models/send_models/google_verify_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/toast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenController extends GetxController {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  String countryCode = AppLabels.defaultCountryCode;
  RxBool isLoading = false.obs;
  Rx<AgentDetailsResponseModel> agentDetailsResponseModel =
      AgentDetailsResponseModel().obs;
  Rx<LoginScreenResponseModel> loginScreenResponseModel =
      LoginScreenResponseModel().obs;

  final LocalAuthentication localAuthentication =
      LocalAuthentication(); //This is used for in device authentication
  final getStotageInstance = GetStorage();
  final SplashScreenController _splashScreenController =
      GetControllers.shared.getSplashScreenController();
  StorageController storageController =
      GetControllers.shared.getStorageController();

  @override
  void onInit() {
    debugLogin();
    super.onInit();
  }

  debugLogin() {
    if (kDebugMode) {
      emailTextEditingController.text = "ghoshnilotpal8@gmail.com";
      passwordTextEditingController.text = "Abcd*123456";
    }
  }

  debugLoginShohel() {
    if (kDebugMode) {
      emailTextEditingController.text = "shohel01716@gmail.com";
      passwordTextEditingController.text = "Pass#321";
    }
  }

  // Get agent Account status, this function is called when the login button is pressed
  // Based on the status of the agent's account we will direct the agent/user to the respective page
  getAgemtAccountStatus(Map<String, dynamic> body) async {
    //Body will contain email and password or phone Number and password
    try {
      isLoading.value = true;
      var responseBody = await CoreService().getWithoutAuth(
        url: baseUrl + getAgentDetailsUrl + body['email'],
      );
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        agentDetailsResponseModel.value =
            AgentDetailsResponseModel.fromJson(responseBody);
        getStotageInstance.write(StorageKeys.newUser, false);
        // checkPageNavigation(
        //     agentDetailsResponseModel: agentDetailsResponseModel.value,
        //     body: body);

        // Here we are checking if the agent has the twoFA enabled or not, if it is enabled then we navigate the user to 2fa screen and then call the login API
        if (agentDetailsResponseModel.value.isTWOFAEnabled) {
          // Storing email in local storage, to use for inDevice auth
          getStotageInstance.write(
              StorageKeys.userEmail, agentDetailsResponseModel.value.email);
          // If 2fa is enabled then we navigate the user to the verify twoFactor screen, after that to main dashboard
          Get.toNamed(twofactorConfirmationScreen,
              arguments: [body, 'fromLoginScreen']);
          isLoading.value = false;
        } else {
          callLoginToCheckEmailAndPassword(body);
        }
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  callLoginToCheckEmailAndPassword(body) async {
    try {
      var responseBody = await CoreService()
          .postWithoutAuth(url: baseUrl + loginUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        checkPageNavigation(
            agentDetailsResponseModel: agentDetailsResponseModel.value,
            body: body);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // This function is used to send the agent/user to the respective page based on the account status
  checkPageNavigation(
      {required AgentDetailsResponseModel agentDetailsResponseModel,
      required Map<String, dynamic> body}) async {
    // This will run if Status is 0 instead of 1
    if (agentDetailsResponseModel.status == 0 &&
        agentDetailsResponseModel.designamtion != null) {
      showErrorToast('Account locked, contact admin');
      isLoading.value = false;
    } else if (agentDetailsResponseModel.status == 0 ||
        agentDetailsResponseModel.status == null) {
      if (agentDetailsResponseModel.isEmailVerified == 0) {
        sendOtpToEmail(body[
            'email']); //Sending OTP to the email address entered in the LoginScreen
        Get.offAndToNamed(confirmEmailScreen, arguments: [
          body['email'],
          'fromLoginScreen'
          //This argument is passed because, the confimr Email screen expects a argument(To check the pageSource and then navigate to proper screen)
        ]); //Passing email as argument to verify email screen
      } else if (agentDetailsResponseModel.isMobileVerified == 0) {
        Get.offAndToNamed(enterMobileNumberScreen, arguments: [
          body['email']
        ]); //Passing email as argument to the enterMobileNumber screen, so that user can verify the number
      } else if (agentDetailsResponseModel.isPasswordSet == false) {
        Get.offAndToNamed(setPasswordScreen, arguments: [
          agentDetailsResponseModel.email
        ]); //Naviagte the user to set password screen if password is not present for the user and pass the email as an argument
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
          body['email']
        ]); //Passing email as argument to the complete profile screen, so that user can complete the profile
      } else {
        login(body);
        // Get.offAllNamed(
        //     mainDashBoardScreen); //Navigating to the dashboard screen
      }
    } else if (agentDetailsResponseModel.isTWOFAEnabled) {
      // Storing email in local storage, to use for inDevice auth
      getStotageInstance.write(
          StorageKeys.userEmail, agentDetailsResponseModel.email);
      // If 2fa is enabled then we navigate the user to the verify twoFactor screen, after that to main dashboard
      Get.toNamed(twofactorConfirmationScreen,
          arguments: [body, 'fromLoginScreen']);
    } else {
      // Storing email in local storage, to use for inDevice auth
      getStotageInstance.write(
          StorageKeys.userEmail, agentDetailsResponseModel.email);
      // This will run if Status is 1 instead of 0
      login(body);
      // Get.offAllNamed(mainDashBoardScreen); //Navigating to the dashboard screen
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

  // Login function with which Login API will be called
  login(Map<String, dynamic> body) async {
    try {
      var responseBody = await CoreService()
          .postWithoutAuth(url: baseUrl + loginUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        loginScreenResponseModel.value =
            LoginScreenResponseModel.fromJson(responseBody);
        loginScreenResponseModel.value.accessToken;
        isLoading.value = false;
        getStotageInstance.write(
            StorageKeys.accessToken,
            loginScreenResponseModel
                .value.accessToken); //Store access token in local storage
        getStotageInstance.write(
            StorageKeys.refreshToken,
            loginScreenResponseModel
                .value.refreshToken); //Store refresh token in local storage
        isLoading.value = false;
        Get.offAllNamed(
            mainDashBoardScreen); //Navigating to the dashboard screen
        // checkPageNavigation(
        //     agentDetailsResponseModel: agentDetailsResponseModel.value,
        //     body: body);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Function for facebook login
  facebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      debugPrint(result.accessToken.toString());
      debugPrint(result.accessToken!.token.toString());
      debugPrint(result.accessToken!.applicationId.toString());
      debugPrint(result.accessToken!.userId.toString());
      debugPrint(result.status.toString());
      debugPrint(result.status.name);
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      debugPrint(userData.values.toString());

      FacebookVerifySendModel model = FacebookVerifySendModel(
          accessToken: result.accessToken!.token.toString(),
          userId: result.accessToken!.userId.toString());
      try {
        isLoading.value = true;
        var responseBody = await CoreService().postWithoutAuthForSocialAuth(
            url: baseUrl + facebookVerifyUrl, body: model.toJson());
        if (responseBody == null) {
          isLoading.value = false;
        } else if (responseBody == '2fa_enabled') {
          isLoading.value = false;
          Get.toNamed(twofactorConfirmationScreen,
              arguments: [model.toJson(), 'fromLoginScreenFacebook']);
        } else {
          loginScreenResponseModel.value =
              LoginScreenResponseModel.fromJson(responseBody);
          loginScreenResponseModel.value.accessToken;
          isLoading.value = false;
          getStotageInstance.write(
              StorageKeys.accessToken,
              loginScreenResponseModel
                  .value.accessToken); //Store access token in local storage
          getStotageInstance.write(
              StorageKeys.refreshToken,
              loginScreenResponseModel
                  .value.refreshToken); //Store refresh token in local storage
          getStotageInstance.write(
              StorageKeys.newUser, false); //Setting new user as false
          getAgentDetailsAfterSocialAuth();
        }
      } catch (e) {
        isLoading.value = false;
        debugPrint(e.toString());
      }
    }
  }

  inDeviceAuthentication() async {
    bool authenticated = false;
    try {
      // Note: If there is accessToken in local storage, the  with that accessToken we will check if inDeviceAuth is enabled or not for the account,
      // if it is not enabled we will throw error and tell the user to login, if there is no accessToken also then we will throw error and tel user to login
      if (getStotageInstance.read(StorageKeys.userEmail) == null) {
        showInfoToast('Unable to login with Biometric');
      } else {
        isLoading.value == true;
        getAgentDetailsWithEmailForBioMetric()
            .then((AgentDetailsResponseModel agentDetailsResponseModel) async {
          if (agentDetailsResponseModel.isDeviceAuthEnabled) {
            authenticated = await localAuthentication.authenticate(
              localizedReason: 'Please authenticate to Login',
            );
            debugPrint(authenticated.toString());
            if (authenticated == true) {
              getAccessTokenFromDigitalTokenForInDeviceAuth();
            } else {
              isLoading.value == false;
            }
          } else {
            isLoading.value == false;
            showInfoToast('Biometric is disabled for you!');
          }
        });
      }
    } catch (e) {
      isLoading.value == false;
      debugPrint("error using biometric auth: $e");
    }
  }

  handleAppleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
        //WebAuthenticationOptions(clientId: clientId, redirectUri: redirectUri)
      ],
      state: 'Login',
    );

    if (kDebugMode) {
      print("Apple login credential:: " + credential.toString());
      print("Apple login authorizationCode:: " + credential.authorizationCode);
      log("Apple login identityToken:: " + credential.identityToken.toString());
      print("Apple login userIdentifier:: " +
          credential.userIdentifier.toString());
      print("Apple login email:: " + credential.email.toString());
      print("Apple login givenName:: " + credential.givenName.toString());
      print("Apple login state:: " + credential.state.toString());
    }

    if (credential.authorizationCode != null) {
      AppleVerifySendModel model = AppleVerifySendModel(
          identityToken: credential.identityToken,
          authorizationCode: credential.authorizationCode,
          givenName: credential.givenName ?? "myname");
      try {
        isLoading.value = true;
        var responseBody = await CoreService().postWithoutAuthForSocialAuth(
            url: baseUrl + appleVerifyUrl, body: model.toJson());
        if (responseBody == null) {
          isLoading.value = false;
        } else if (responseBody == '2fa_enabled') {
          isLoading.value = false;
          Get.toNamed(twofactorConfirmationScreen,
              arguments: [model.toJson(), 'fromLoginScreenApple']);
        } else {
          loginScreenResponseModel.value =
              LoginScreenResponseModel.fromJson(responseBody);
          loginScreenResponseModel.value.accessToken;
          isLoading.value = false;
          getStotageInstance.write(
              StorageKeys.accessToken,
              loginScreenResponseModel
                  .value.accessToken); //Store access token in local storage
          getStotageInstance.write(
              StorageKeys.refreshToken,
              loginScreenResponseModel
                  .value.refreshToken); //Store refresh token in local storage
          getStotageInstance.write(
              StorageKeys.newUser, false); //Setting new user as false
          getAgentDetailsAfterSocialAuth();
        }
      } catch (e) {
        isLoading.value = false;
        debugPrint(e.toString());
      }
    } else {
      debugPrint("error credential not found!");
    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  handleGoogle(isLogin) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential).then((account) async {
          try {
            GoogleVerifySendModel model = GoogleVerifySendModel(
                idToken: await account.user!.getIdToken(),
                accessToken: account.credential!.accessToken);
            isLoading.value = true;
            var responseBody = await CoreService().postWithoutAuthForSocialAuth(
                url: baseUrl + googleVerifyUrl, body: model.toJson());
            if (responseBody == null) {
              isLoading.value = false;
            } else if (responseBody == '2fa_enabled') {
              isLoading.value = false;
              Get.toNamed(twofactorConfirmationScreen,
                  arguments: [model.toJson(), 'fromLoginScreenGoogle']);
            } else {
              loginScreenResponseModel.value =
                  LoginScreenResponseModel.fromJson(responseBody);
              loginScreenResponseModel.value.accessToken;
              isLoading.value = false;
              getStotageInstance.write(
                  StorageKeys.accessToken,
                  loginScreenResponseModel
                      .value.accessToken); //Store access token in local storage
              getStotageInstance.write(
                  StorageKeys.refreshToken,
                  loginScreenResponseModel.value
                      .refreshToken); //Store refresh token in local storage
              getStotageInstance.write(
                  StorageKeys.newUser, false); //Setting new user as false
              getAgentDetailsAfterSocialAuth();
            }
          } catch (e) {
            isLoading.value = false;
            debugPrint(e.toString());
          }
        });
      } on FirebaseAuthException catch (error) {
        debugPrint('Code : ${error.code}\nMassage : ${error.message}');
      }
    } else {
      debugPrint("googleUser:: null");
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
        getStotageInstance.write(
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
    } else if (agentDetailsResponseModel.isTWOFAEnabled) {
      Get.offAndToNamed(twofactorConfirmationScreen,
          arguments: [null, 'fromSplashScreen']);
    } else {
      Get.offAndToNamed(mainDashBoardScreen);
    }
  }

  Future<AgentDetailsResponseModel>
      getAgentDetailsWithEmailForBioMetric() async {
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
      }
      return agentDetailsResponseModel.value;
    } catch (e) {
      debugPrint(e.toString());
      return AgentDetailsResponseModel();
    }
  }

  // This function is used to login user with biometric
  // This function is used to get the accessTokena and refreshToken with the digitalToken store
  getAccessTokenFromDigitalTokenForInDeviceAuth() async {
    try {
      var responseBody = await CoreService().postWithoutAuth(
          url: baseUrl + getAccessTokenFromDigitalTokenUrl,
          body: {
            'digital_token': storageController.getStotageInstance
                .read(StorageKeys.digitalToken)
          });
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        loginScreenResponseModel.value =
            LoginScreenResponseModel.fromJson(responseBody);
        getStotageInstance.write(
            StorageKeys.accessToken,
            loginScreenResponseModel
                .value.accessToken); //Store access token in local storage
        getStotageInstance.write(
            StorageKeys.refreshToken,
            loginScreenResponseModel
                .value.refreshToken); //Store refresh token in local storage
        isLoading.value = false;
        Get.offAllNamed(
            mainDashBoardScreen); //Navigating to the dashboard screen
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
