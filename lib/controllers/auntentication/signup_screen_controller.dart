import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:get/get.dart';
import 'package:pumpkin/utils/strings.dart';

class SignupScreenController extends GetxController {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  RxBool agreewithTandC = true.obs;
  RxBool isLoading = false
      .obs; //This boolean is responsible for showing the Loader in the screen
  final getStotageInstance = GetStorage();
  signUp(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .postWithoutAuth(url: baseUrl + registerUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        getStotageInstance.write(StorageKeys.newUser, false);
        // Navigating to confrimation of email screen and passing Email with which we registered
        Get.toNamed(confirmEmailScreen, arguments: [
          body['email'],
          'fromSignup'
        ]); //The second argumnet we are passing to the confirm email screen because we need to check the navigation in confirm email screen, because there are multiple ways which navigate to the confirm email screen
      }
    } catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
    }
  }
}
