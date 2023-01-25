import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/add_lead_screen_controller.dart';
import 'package:pumpkin/controllers/leads/policy_details_screen_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/buttons/button_type_three.dart';
import 'package:pumpkin/widgets/loader.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({Key? key}) : super(key: key);

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  AddLeadScreenController addLeadScreenController =
      GetControllers.shared.getAddLeadScreenController();

  final addDetailsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: addDetailsFormKey,
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.black,
                                  size: 18,
                                ),
                              ),
                              Text('Add Lead',
                                  style: defaultTheme.textTheme.headline3),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 32),
                          ButtonTypeThree(
                              isDisableButton: addLeadScreenController
                                  .hasLeadId(), //Disable the button if there is lead ID
                              buttonText: "Basic Details",
                              onPressed: () {
                                Get.toNamed(leadBasicDetailsScreen);
                              }),
                          const SizedBox(height: 9),
                          ButtonTypeThree(
                              isDisableButton:
                                  addLeadScreenController.hasNotLeadID(),
                              buttonText: "Contacts",
                              onPressed: () {
                                addLeadScreenController
                                    .leadValidation(leadContactsScreen);
                              }),
                          const SizedBox(height: 9),
                          ButtonTypeThree(
                              isDisableButton:
                                  addLeadScreenController.hasNotLeadID(),
                              buttonText: "Personal Details",
                              onPressed: () {
                                addLeadScreenController
                                    .leadValidation(leadPersonalDetailsScreen);
                              }),
                          const SizedBox(height: 9),
                          ButtonTypeThree(
                              isDisableButton:
                                  addLeadScreenController.hasNotLeadID(),
                              buttonText: "Dependants",
                              onPressed: () {
                                addLeadScreenController
                                    .leadValidation(leadDependantsScreen);
                                //Get.toNamed(leadDependantsScreen);
                              }),
                          const SizedBox(height: 9),
                          ButtonTypeThree(
                              buttonText: "Policy Details",
                              isDisableButton:
                                  addLeadScreenController.hasNotLeadID(),
                              onPressed: () {
                                addLeadScreenController
                                    .leadValidation(policyDetailsScreen);
                              }),
                          const SizedBox(height: 24),
                        ],
                      )),
                ),
              ),
            ),
          ),
          Obx(
            () => addLeadScreenController.isLoading.value
                ? const Loader()
                : const Offstage(),
          )
        ],
      ),
    );
  }

  Widget buttonWidget() {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: 320,
        height: 52,
        color: AppColors.orange,
      ),
    );
  }

  Widget textFieldWidget() {
    return Container(
      width: 320,
      height: 52,
      color: AppColors.black.withOpacity(0.1),
    );
  }

  @override
  void dispose() {
    Get.delete<AddLeadScreenController>();
    GetControllers.shared.getPolicyDetailsController().clearAllFields();
    GetControllers.shared.getLeadContactsScreenController().clearAllFields();
    GetControllers.shared
        .getLeadPersonalDetailsScreenController()
        .clearAllFields();
    super.dispose();
  }
}
