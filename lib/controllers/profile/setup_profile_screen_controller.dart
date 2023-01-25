import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pumpkin/models/response_models/set_password_screen_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class SetupProfileScreenController extends GetxController {
  TextEditingController firstNameTextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController dateOfBirthTextEditingController =
      TextEditingController();
  RxString gender = 'Male'.obs;
  TextEditingController profileMessageTextEditingController =
      TextEditingController();
  RxString mobileNumber = ''.obs;
  RxString countryCode = ''.obs;
  RxString email = ''.obs;

  Rx<SetPasswordScreenResponseModel> setPasswordScreenResponseModel =
      SetPasswordScreenResponseModel().obs;
  RxBool isLoading = false.obs;
  RxString profilePictureUrl = ''.obs;

  final picker = ImagePicker();
  Rx<File> images = File("").obs;

  @override
  void onInit() {
    setPasswordScreenResponseModel.value = Get.arguments[
        0]; //Arguments to get the response from the setpassword screen response model
    firstNameTextEditingController.text =
        setPasswordScreenResponseModel.value.firstName ?? '';
    lastNameTextEditingController.text =
        setPasswordScreenResponseModel.value.lastName ?? '';
    mobileNumber.value =
        setPasswordScreenResponseModel.value.mobileNumbers ?? '';
    countryCode.value = setPasswordScreenResponseModel.value.countryCode ?? '';
    email.value = setPasswordScreenResponseModel.value.email ?? '';
    super.onInit();
  }

  // Setup profile in the onboarding flow
  setupProfile(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .postWithoutAuth(url: baseUrl + setUpProfileUrl, body: body);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        // Navigating to set-up password screen with email verified
        Get.toNamed(completeProfileScreen,
            arguments: [setPasswordScreenResponseModel.value.email]);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Get image from the user device
  Future getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      debugPrint(pickedFile.path);
      images.value = File(pickedFile.path);
      uploadProfilePicture();
    } else {
      debugPrint('No image selected.');
    }
  }

  // Call the API to upload the image to the server
  uploadProfilePicture() async {
    isLoading.value = true;
    try {
      var responseBody = await CoreService().putFileWithoutAuth(
          upload: images.value.readAsBytesSync(),
          filename: images.value.path.split("/").last,
          url: baseUrl + updateProfilePicture + 'agent/' + email.value,
          key: 'upload');
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        profilePictureUrl.value = responseBody.toString();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
