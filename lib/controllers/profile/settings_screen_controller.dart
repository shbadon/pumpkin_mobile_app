import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/company_details_response_model.dart';

class SettingsScreenController extends GetxController {
  CompanyDetailsResponseModel companyDetailsResponseModel =
      CompanyDetailsResponseModel();
  @override
  void onInit() {
    companyDetailsResponseModel = Get.arguments[0];
    super.onInit();
  }
}
