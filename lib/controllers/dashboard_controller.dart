import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:pumpkin/controllers/enum_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';

class DashboardController extends GetxController {
  EnumController controller = GetControllers.shared.getEnumController();
  //Index to maintain on which tab the app is through bottom navigation Bar
  RxInt pageIndex = 0.obs;

  // Update the index based on tapping the item in the bottom navigation bar
  void onItemTapped(int index) {
    pageIndex.value = index;
    debugPrint(pageIndex.value.toString());
  }
}
