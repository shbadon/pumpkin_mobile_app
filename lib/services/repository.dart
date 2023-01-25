import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/all_enum_response_model.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';

class EnumRepository{
  static getEnum(String type, List<EnumResponseModel> enumList) async {
    try {
      var responseBody =
      await CoreService().getWithoutAuth(url: baseUrl + enumUrl + type);
      if (responseBody != null) {
        List<dynamic> results = responseBody;
        enumList.clear();
        for (var item in results) {
          enumList.add(EnumResponseModel.fromJson(item));
        }
        debugPrint("enum:: $type length:: ${enumList.length.toString()}");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static findEnum(List<EnumResponseModel> enumList, var enumCode, bool isOrder, EnumResponseModel foundEnum){

    debugPrint("enumList::: ${enumList.length.toString()}");

    final found =
    enumList.firstWhere((element) =>
    element.code== enumCode,
        orElse: () {
          debugPrint("findEnum::: null");
          return EnumResponseModel();
        });



    debugPrint("findEnum::: ${found.description.toString()}");

    foundEnum = found;
  }

  static findEnum2(List<EnumResponseModel> enumList, var enumCode, bool isOrder, Rx<EnumResponseModel> foundEnum){

    debugPrint("enumList::: ${enumList.length.toString()}");

    final found =
    enumList.firstWhere((element) =>
    element.code== enumCode,
        orElse: () {
          debugPrint("findEnum::: null");
          return EnumResponseModel();
        });



    debugPrint("findEnum::: ${found.description.toString()}");

    foundEnum.value = found;
  }


}