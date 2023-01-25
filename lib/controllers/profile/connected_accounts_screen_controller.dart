import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/storage_controller.dart';
import 'package:pumpkin/models/response_models/agent_details_response_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pumpkin/models/send_models/connected_apple_send_model.dart';
import 'package:pumpkin/models/send_models/connected_facebook_send_model.dart';
import 'package:pumpkin/models/send_models/connected_google_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ConnectedAccountsScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFacebookConnected = false.obs;
  RxBool isGoogleConnected = false.obs;
  RxBool isAppleConnected = false.obs;
  AgentDetailsResponseModel agentDetailsResponseModel =
      AgentDetailsResponseModel();
  StorageController storageController =
      GetControllers.shared.getStorageController();

  @override
  void onInit() {
    agentDetailsResponseModel =
        Get.arguments[0]; //Argument to get agent details
    isFacebookConnected.value = agentDetailsResponseModel.isFbConnected ??
        false; // Boolean for the switch
    isGoogleConnected.value = agentDetailsResponseModel.isGoogleConnected ??
        false; // Boolean for the switch
    isAppleConnected.value = agentDetailsResponseModel.isAppleConnected ??
        false; // Boolean for the switch
    super.onInit();
  }

  // Function for facebook connect from the connect page in the profile section
  connectFacebook() async {
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

      ConnectedFacebookSendModel model = ConnectedFacebookSendModel(
          manualLoginAccessToken: GetStorage().read(StorageKeys.accessToken),
          accessToken: result.accessToken!.token.toString(),
          userId: result.accessToken!.userId.toString());
      try {
        isLoading.value = true;
        var responseBody = await CoreService().postWithAuth(
            url: baseUrl + connectFacebookUrl, body: model.toJson());
        if (responseBody == null) {
          isLoading.value = false;
        } else if (responseBody == 401) {
          CoreService()
              .getAccessToken(url: baseUrl + getAccessTokenUrl)
              .then((value) {
            if (value == null) {
              Get.offAllNamed(loginScreen);
            } else {
              connectFacebook();
            }
          });
        } else {
          isFacebookConnected.value = true;
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        debugPrint(e.toString());
      }
    }
  }

  // Connect apple from the connect page in the profile section
  connectApple() async {
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
      ConnectedAppleSendModel model = ConnectedAppleSendModel(
          manualLoginAccessToken: GetStorage().read(StorageKeys.accessToken),
          identityToken: credential.identityToken,
          authorizationCode: credential.authorizationCode,
          provider: "apple",
          givenName: credential.givenName ?? "myname");
      try {
        isLoading.value = true;
        var responseBody = await CoreService()
            .postWithAuth(url: baseUrl + connectAppleUrl, body: model.toJson());
        if (responseBody == null) {
          isLoading.value = false;
        } else if (responseBody == 401) {
          CoreService()
              .getAccessToken(url: baseUrl + getAccessTokenUrl)
              .then((value) {
            if (value == null) {
              Get.offAllNamed(loginScreen);
            } else {
              connectApple();
            }
          });
        } else {
          isAppleConnected.value = true;
          isLoading.value = false;
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

  // Connect the users google account from the profile section
  connectGoogle() async {
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
            ConnectedGoogleSendModel model = ConnectedGoogleSendModel(
                manualLoginAccessToken:
                    GetStorage().read(StorageKeys.accessToken),
                idToken: await account.user!.getIdToken(),
                accessToken: account.credential!.accessToken);
            isLoading.value = true;
            var responseBody = await CoreService().postWithAuth(
                url: baseUrl + connectGoogleUrl, body: model.toJson());
            if (responseBody == null) {
              isLoading.value = false;
            } else if (responseBody == 401) {
              CoreService()
                  .getAccessToken(url: baseUrl + getAccessTokenUrl)
                  .then((value) {
                if (value == null) {
                  Get.offAllNamed(loginScreen);
                } else {
                  connectGoogle();
                }
              });
            } else {
              isGoogleConnected.value = true;
              isLoading.value = false;
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
}
