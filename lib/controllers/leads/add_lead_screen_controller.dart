import 'package:get/get.dart';
import 'package:pumpkin/widgets/toast.dart';

class AddLeadScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxString leadID = "".obs;
  //this id only dev purpose. want to remove t his line when go prod
  //RxString leadID = "dd0f5546-b7d3-4ecf-a827-00df625b216b".obs;

  void leadValidation(String route) {
    if (leadID.value.isNotEmpty) {
      Get.toNamed(route);
      return;
    }
  }

  bool hasNotLeadID() {
    if (leadID.value.isEmpty) {
      return true;
    }
    return false;
  }

  bool hasLeadId() {
    if (leadID.value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
