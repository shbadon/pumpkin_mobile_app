import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/upload_file_screen_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';

class UploadFileScreenController extends GetxController {
  late FilePickerResult? filePickerResult;
  Rx<File> csvFile = File("").obs;
  RxBool isUploading = false.obs;
  RxString fileName = ''.obs;
  RxBool listLoading = false.obs;
  UploadFileScreenResponseModel uploadFileScreenResponseModel =
      UploadFileScreenResponseModel();
  RxList<OneFileModel> filesList = <OneFileModel>[].obs;

  // Get file from the users device
  Future getFile() async {
    filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      debugPrint(filePickerResult!.paths.toString());
      fileName.value = csvFile.value.path.split("/").last;
      csvFile.value = File(filePickerResult!.paths[0]!);
      uploadCSVFile();
    } else {
      debugPrint('File not selected.');
    }
  }

  // Call the API to upload the csv to the server
  uploadCSVFile() async {
    isUploading.value = true;
    try {
      var responseBody = await CoreService().postFileWithAuth(
          upload: csvFile.value.readAsBytesSync(),
          filename: csvFile.value.path.split("/").last,
          url: baseUrl + importLeadUrl,
          key: 'files');
      if (responseBody == null) {
        isUploading.value = false;
      } else {
        isUploading.value = false;
        getFilesList();
      }
    } catch (e) {
      isUploading.value = true;
      debugPrint(e.toString());
    }
  }

  // TODO: Need to add pagination
  getFilesList() async {
    listLoading.value = true;
    try {
      var responseBody =
          await CoreService().getWithAuth(url: baseUrl + getUploadedFilesUrl);
      if (responseBody == null) {
        listLoading.value = false;
      } else {
        uploadFileScreenResponseModel =
            UploadFileScreenResponseModel.fromJson(responseBody);
        filesList.value = uploadFileScreenResponseModel.filesList!;
        listLoading.value = false;
      }
    } catch (e) {
      listLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
