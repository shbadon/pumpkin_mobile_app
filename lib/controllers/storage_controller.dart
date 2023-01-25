import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

// Get the storage instance of the application allover the application
class StorageController extends GetxController {
  late final GetStorage getStotageInstance;

  @override
  void onInit() {
    getStotageInstance = GetStorage();
    super.onInit();
  }
}
