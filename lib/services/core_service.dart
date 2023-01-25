import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pumpkin/models/header_model.dart';
import 'package:pumpkin/models/response_models/get_access_token_response_model.dart';
import 'package:pumpkin/models/send_models/get_access_token_send_model.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/toast.dart';

class CoreService extends GetConnect {
  final getStotageInstance = GetStorage();
  GetAccessTokenResponseModel _getAccessTokenResponseModel =
      GetAccessTokenResponseModel();

  Future<dynamic> getWithoutAuth({required String url}) async {
    debugPrint("Url : $url");
    var data = await get(url);
    log("response : " + jsonEncode(data.body));
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      showErrorToast(data.body['message']);
      return null;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> getWithAuth({required String url}) async {
    var token = await GetStorage()
        .read(StorageKeys.accessToken); //get access token from local storage
    HeaderModel headerModel =
        HeaderModel(authorization: "Bearer " + token.toString());
    log("Header : " + headerModel.toJson().toString());
    debugPrint("Url : $url");
    var data = await get(url, headers: headerModel.toHeader());
    log("response : " + jsonEncode(data.body));
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      // showErrorToast(data.body['message']);
      return 401;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> postWithoutAuth(
      {Map<String, dynamic>? body, required String url}) async {
    debugPrint("Url : $url");
    log("Body : $body");
    var data = await post(url, body);
    // var data = await post(url, FormData(body!)); //*This is used for passing the body as form data

    log("response : ${jsonEncode(data.body)}");
    log("response : ${data.body['message']}");
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      showErrorToast(data.body['message']);
      return null;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> postWithAuth(
      {Map<String, dynamic>? body,
      Map<String, dynamic>? bodyRaw,
      required String url}) async {
    var token = await GetStorage()
        .read(StorageKeys.accessToken); //get access token from local storage
    HeaderModel headerModel =
        HeaderModel(authorization: "Bearer " + token.toString());
    log("Header : " + headerModel.toJson().toString());
    log("Url : $url");
    log("body : " + jsonEncode(body).toString());
    var data;
    if (body == null) {
      data = await post(url, null, headers: headerModel.toHeader());
    } else {
      data = await post(url, body, headers: headerModel.toHeader());
    }
    log("response : ${jsonEncode(data.body)}");
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      // showErrorToast(data.body['message']);
      return 401;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> putWithoutAuth(
      {Map<String, dynamic>? body, required String url}) async {
    debugPrint("Url : $url");
    debugPrint("Body : $body");
    var data = await put(url, body);
    // var data = await post(url, FormData(body!)); //This is used for passing the body as form data
    log("response : ${data.body}");
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      showErrorToast(data.body['message']);
      return null;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> putWithAuth(
      {Map<String, dynamic>? body, required String url}) async {
    var token = await GetStorage()
        .read(StorageKeys.accessToken); //get access token from local storage
    HeaderModel headerModel =
        HeaderModel(authorization: "Bearer " + token.toString());
    log("Header : " + headerModel.toJson().toString());
    debugPrint("Url : $url");
    log("body : " + jsonEncode(body).toString());
    var data;
    if (body == null) {
      data = await put(url, null, headers: headerModel.toHeader());
    } else {
      data = await put(url, body, headers: headerModel.toHeader());
    }
    log("response : ${jsonEncode(data.body)}");
    log("response code : ${data.status.code}");

    // ! When status code is 401
    if (data.status.isUnauthorized) {
      // showErrorToast(data.body['message']);
      return 401;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> putFileWithoutAuth({
    required List<int> upload,
    required String filename,
    required String url,
    required String key,
  }) async {
    final image = MultipartFile(
      upload,
      // contentType: "multipart/form-data",
      filename: filename,
    );
    debugPrint(url);
    debugPrint(filename);

    var data = await put(
      url,
      FormData({
        key: image,
      }),
    );
    log(data.statusCode.toString());
    log(data.body.toString());

    // ! When status code is 401
    if (data.status.isUnauthorized) {
      showErrorToast(data.body['message']);
      return null;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> postFileWithAuth({
    required List<int> upload,
    required String filename,
    required String url,
    required String key,
  }) async {
    var token = await GetStorage()
        .read(StorageKeys.accessToken); //get access token from local storage
    HeaderModel headerModel =
        HeaderModel(authorization: "Bearer " + token.toString());
    log("Header : " + headerModel.toJson().toString());
    debugPrint("Url : $url");

    final image = MultipartFile(
      upload,
      // contentType: "multipart/form-data",
      filename: filename,
      // contentType: "image/jpg"
    );
    debugPrint(url);
    debugPrint(filename);

    var data = await post(
        url,
        FormData({
          key: image,
        }),
        headers: headerModel.toHeaderFileUpload());
    log(data.statusCode.toString());
    log(data.body.toString());

    // ! When status code is 401
    if (data.status.isUnauthorized) {
      showErrorToast(data.body['message']);
      return null;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> deleteWithAuth(
      {Map<String, dynamic>? body, required String url}) async {
    var token = await GetStorage()
        .read(StorageKeys.accessToken); //get access token from local storage
    HeaderModel headerModel =
        HeaderModel(authorization: "Bearer " + token.toString());
    log("Header : ");
    debugPrint("Url : $url");
    var data = await delete(url, headers: headerModel.toHeader());
    log("response : ${data.body}");
    log("response code : ${data.status.code}");

    // ! When status code is 401
    if (data.status.isUnauthorized) {
      // showErrorToast(data.body['message']);
      return 401;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  Future<dynamic> deleteWithoutAuth(
      {Map<String, dynamic>? body, required String url}) async {
    debugPrint("Url : $url");
    var data = await delete(url);
    log("response : ${data.body}");
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      showErrorToast(data.body['message']);
      return null;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  // Get AccessToken with refreshToken
  //* Note: It send true if we are successfully able to get the accessToke from the refreshToken, or else null
  Future<dynamic> getAccessToken({required String url}) async {
    // Cresting model to send the refresh token in the body
    final body = GetAccessTokenSendModel(
        refreshToken: getStotageInstance.read(StorageKeys.refreshToken));
    debugPrint("Url : $url");
    var data = await post(url, body.toJson());
    log("response : ${data.body}");
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      // showErrorToast(data.body['message']);
      return null;
    } else if (data.status.hasError) {
      // showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      // showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      // showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      // showErrorToast(data.body['message']);
      return null;
    } else {
      // Decode json and put it in model
      _getAccessTokenResponseModel =
          GetAccessTokenResponseModel.fromJson(data.body);
      // Add it to the localStorage
      getStotageInstance.write(
          StorageKeys.accessToken, _getAccessTokenResponseModel.accessToken);
      getStotageInstance.write(
          StorageKeys.refreshToken, _getAccessTokenResponseModel.refreshToken);
      return true;
    }
  }

  // This is only used to get Agent details with access token in the pathparameter
  Future<dynamic> getAgentDetailsWithoutAuth({required String url}) async {
    debugPrint("Url : $url");
    var data = await get(url);
    log("response : ${data.body}");
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      return 401;
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }

  // This function is added only socila auth for the flow of 2FA
  Future<dynamic> postWithoutAuthForSocialAuth(
      {Map<String, dynamic>? body, required String url}) async {
    debugPrint("Url : $url");
    log("Body : $body");
    var data = await post(url, body);
    // var data = await post(url, FormData(body!)); //*This is used for passing the body as form data

    log("response : ${jsonEncode(data.body)}");
    log("response : ${data.body['message']}");
    log("response code : ${data.status.code}");
    // ! When status code is 401
    if (data.status.isUnauthorized) {
      if (data.body['name'] == 'OTP_ERROR') {
        return '2fa_enabled';
      } else {
        showErrorToast(data.body['message']);
        return null;
      }
    } else if (data.status.hasError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is 500
    else if (data.status.isServerError) {
      showErrorToast(data.body['message']);
      return null;
    }
    // ! When status code is null
    else if (data.status.connectionError) {
      showErrorToast(data.body['message'] ?? AppLabels.genericErrorMessage);
      return null;
    }
    // ! When status code is 404
    else if (data.status.isNotFound) {
      showErrorToast(data.body['message']);
      return null;
    } else {
      return data.body;
    }
  }
}
