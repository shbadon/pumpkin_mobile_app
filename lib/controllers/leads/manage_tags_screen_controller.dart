import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/tags_controller.dart';

class ManageTagsScreenController extends GetxController {
  TextEditingController tagsEditTextEditingController = TextEditingController();
  TagsController tagsController = GetControllers.shared.getTagsController();
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    tagsController.getAllTagsforAgent();
    super.onInit();
  }
}
