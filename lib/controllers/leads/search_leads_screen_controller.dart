import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/lead_list_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class SearchLeadsScreenController extends GetxController {
  TextEditingController searchTextEditingController = TextEditingController();
  RxBool isLoading = false.obs;
  RxList<OneLeadResponseModel> leadList = <OneLeadResponseModel>[].obs;
  Rx<LeadListResponseModel> leadListResponseModel = LeadListResponseModel().obs;

  searchLeads(String value) async {
    try {
      isLoading.value = true;
      var responseBody =
          await CoreService().getWithAuth(url: baseUrl + searchLead + value);
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            searchLeads(value);
          }
        });
      } else {
        leadList.clear();
        isLoading.value = false;
        leadListResponseModel.value =
            LeadListResponseModel.fromJson(responseBody);
        leadList.value = leadListResponseModel.value.leadsList ?? [];
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;

      debugPrint(e.toString());
    }
  }
}
