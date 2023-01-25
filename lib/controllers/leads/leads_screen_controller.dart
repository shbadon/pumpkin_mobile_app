import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/lead_list_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class LeadsScreenController extends GetxController {
  RxBool hideBackground = false.obs;
  RxBool isLoading = false.obs;
  Rx<LeadListResponseModel> leadListResponseModel = LeadListResponseModel().obs;
  RxList<OneLeadResponseModel> leadList = <OneLeadResponseModel>[].obs;
  RxString? allLeadCount = '0'.obs;
  RxString? seedLeadCount = '0'.obs;
  RxString? saplingLeadCount = '0'.obs;
  RxString? flowerLeadCount = '0'.obs;
  RxString? pumpkinLeadCount = '0'.obs;
  ScrollController scrollController = ScrollController();
  RxString currentLeadStageTab = 'seed'.obs;

  @override
  onInit() {
    scrollController.addListener(pagination);
    super.onInit();
  }

  getLeads(String leadStage) async {
    currentLeadStageTab.value =
        leadStage; //When tab chnages we set the value to a variable for filtering purpose
    try {
      leadList.clear();
      var responseBody = await CoreService()
          .getWithAuth(url: baseUrl + getLeadsUrl + leadStage);
      if (responseBody == null) {
        isLoading.value = false;
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            getLeads(leadStage);
          }
        });
      } else {
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

  getMoreLeads() async {
    try {
      if (leadListResponseModel.value.next != null) {
        var responseBody = await CoreService()
            .getWithAuth(url: leadListResponseModel.value.next!);
        if (responseBody == null) {
        } else if (responseBody == 401) {
          CoreService()
              .getAccessToken(url: baseUrl + getAccessTokenUrl)
              .then((value) {
            if (value == null) {
              Get.offAllNamed(loginScreen);
            } else {
              getMoreLeads();
            }
          });
        } else {
          leadListResponseModel.value =
              LeadListResponseModel.fromJson(responseBody);
          leadList.addAll(leadListResponseModel.value.leadsList ??
              []); //Add ing the more items to the lead list
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      //add api for load the more data according to new page
      getMoreLeads();
    }
  }

  // Get all the lead counts Stage specific and total lead count
  getLeadCount() async {
    try {
      var responseBody =
          await CoreService().getWithAuth(url: baseUrl + getAllLeadCountUrl);
      if (responseBody == null) {
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            getLeadCount();
          }
        });
      } else {
        // Not created any models as basic details only
        allLeadCount?.value = responseBody['totalLeads'].toString();
        seedLeadCount?.value = responseBody['groupLeads']['seed'] == null
            ? '0'
            : responseBody['groupLeads']['seed'].toString();
        saplingLeadCount?.value = responseBody['groupLeads']['sapling'] == null
            ? '0'
            : responseBody['groupLeads']['sapling'].toString();
        flowerLeadCount?.value = responseBody['groupLeads']['flower'] == null
            ? '0'
            : responseBody['groupLeads']['flower'].toString();
        pumpkinLeadCount?.value = responseBody['groupLeads']['pumpkin'] == null
            ? '0'
            : responseBody['groupLeads']['pumpkin'].toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Filter the lead based on the status of the screen
  filterLeadBasedOnStatus({required bool? status}) async {
    if (status == null) {
      getLeads(currentLeadStageTab.value);
    } else {
      try {
        isLoading.value = true;
        var respomseBody = await CoreService().getWithAuth(
            url: baseUrl +
                getLeadsUrl +
                currentLeadStageTab.value +
                '&status=$status');
        if (respomseBody == null) {
          isLoading.value = false;
        } else if (respomseBody == 401) {
          CoreService()
              .getAccessToken(url: baseUrl + getAccessTokenUrl)
              .then((value) {
            if (value == null) {
              Get.offAllNamed(loginScreen);
            } else {
              getLeadCount();
            }
          });
        } else {
          leadList.clear();
          leadListResponseModel.value =
              LeadListResponseModel.fromJson(respomseBody);
          leadList.value = leadListResponseModel.value.leadsList ?? [];
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        debugPrint(e.toString());
      }
    }
  }
}
