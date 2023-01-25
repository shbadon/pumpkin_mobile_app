import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/response_models/tags_response_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class TagsController extends GetxController {
  Rx<TagsResponseModel> tagsRespnseModel = TagsResponseModel().obs;
  RxBool isLoading = false.obs;
  RxList<OneTag> tagsListToSelectFrom = <OneTag>[OneTag(id: -1, name: 'Add')]
      .obs; //We have a byDefault value for the add button

  // This function is used to get all the tags for the logged in agent
  getAllTagsforAgent() async {
    try {
      var responseBody =
          await CoreService().getWithAuth(url: baseUrl + getAllTagsUrl);
      if (responseBody == null) {
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            // Get.offAllNamed(loginScreen); // Not required to call this here
          } else {
            getAllTagsforAgent();
          }
        });
      } else {
        tagsRespnseModel.value = TagsResponseModel.fromJson(responseBody);
        tagsListToSelectFrom.addAll(tagsRespnseModel.value.tags!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Add a tag
  addTag({required Map<String, dynamic> body, context}) async {
    try {
      var responseBody = await CoreService()
          .postWithAuth(url: baseUrl + addTagUrl, body: body);
      if (responseBody == null) {
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            addTag(body: body);
          }
        });
      } else {
        Navigator.pop(context);
        getAllTagsforAgent();
        GetControllers.shared
            .getLeadBasicDetailsScreenController()
            .addTagTextEditingController
            .clear();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Edit a tag
  editTags(String tagId, Map<String, dynamic> body, context) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + updateTagUrl + tagId, body: body);
      if (responseBody == null) {
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            editTags(tagId, body, context);
          }
        });
      } else {
        getAllTagsforAgent();
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Edit a tag
  deleteTag(String tagId, context) async {
    try {
      isLoading.value = true;
      var responseBody = await CoreService()
          .deleteWithAuth(url: baseUrl + updateTagUrl + tagId);
      if (responseBody == null) {
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            deleteTag(tagId, context);
          }
        });
      } else {
        getAllTagsforAgent();
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
