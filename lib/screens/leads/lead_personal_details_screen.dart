import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/lead_personal_detail_controller.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/forms/dropdown_form_field.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';
import 'package:pumpkin/widgets/loader.dart';

class LeadPersonalDetailsScreen extends StatefulWidget {
  const LeadPersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LeadPersonalDetailsScreen> createState() =>
      _LeadPersonalDetailsScreenState();
}

class _LeadPersonalDetailsScreenState extends State<LeadPersonalDetailsScreen> {
  LeadPersonalDetailsScreenController personalDetailsController =
      GetControllers.shared.getLeadPersonalDetailsScreenController();

  @override
  void initState() {
    setDetailsUpdateData();
    super.initState();
  }

  void setDetailsUpdateData() {
    Future.delayed(Duration.zero, () {
      personalDetailsController.isFromLeadProfile.value =
          Get.arguments != null ? Get.arguments[0] : false;
    });
  }

  final eduOverlayWidgetController = ExpandableOverlayWidgetController();
  final maritalStatusOverlayWidgetController =
      ExpandableOverlayWidgetController();
  final preferredLanguageOverlayWidgetController =
      ExpandableOverlayWidgetController();
  final citizenshipStatusOverlayWidgetController =
      ExpandableOverlayWidgetController();
  final riskProfileListOverlayWidgetController =
      ExpandableOverlayWidgetController();

  final countryOverlayWidgetController =
      ExpandableOverlayWidgetController();

  hideAllOverlayWidget() {
    eduOverlayWidgetController.hide();
    maritalStatusOverlayWidgetController.hide();
    preferredLanguageOverlayWidgetController.hide();
    citizenshipStatusOverlayWidgetController.hide();
    riskProfileListOverlayWidgetController.hide();
    countryOverlayWidgetController.hide();
  }

  @override
  void dispose() {
    hideAllOverlayWidget();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("ontap:: outside");
        hideAllOverlayWidget();
      },
      child: WillPopScope(
        onWillPop: () async {
          hideAllOverlayWidget();
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.back();
                              hideAllOverlayWidget();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.black,
                              size: 18,
                            ),
                          ),
                          Text('Personal Details',
                              style: defaultTheme.textTheme.headline3),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              personalDetailsController.save();
                            },
                            child: Text(
                                personalDetailsController
                                        .isFromLeadProfile.value
                                    ? 'Update'
                                    : 'Save',
                                style: defaultTheme.textTheme.headline5!
                                    .copyWith(color: AppColors.primaryColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: Get.height * 0.825,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormFieldTitle(title: "Educational Field"),
                              const SizedBox(height: 9),
                              dropDown(
                                  overlayWidgetController: eduOverlayWidgetController,
                                  type: "education",
                                  enumList: GetControllers.shared
                                      .getEnumController()
                                      .educationList
                                      .value,
                                  selectedEnum:
                                      personalDetailsController.selectedEducational),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Occupation"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                  type: InputFieldTypes.text,
                                  isValidationEnabled: false,
                                  controller: personalDetailsController
                                      .occupationTextEditingController,
                                  hintText: "eg: Doe",
                                  key: const Key('Occupation')),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Annual Income"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                  type: InputFieldTypes.money,
                                  isValidationEnabled: false,
                                  controller: personalDetailsController
                                      .annualIncomeTextEditingController,
                                  hintText: "eg: \$100000",
                                  key: const Key('Annual Income')),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Marital Status"),
                              const SizedBox(height: 9),
                              dropDown(
                                  overlayWidgetController:
                                      maritalStatusOverlayWidgetController,
                                  type: "marital",
                                  enumList: GetControllers.shared
                                      .getEnumController()
                                      .maritalList
                                      .value,
                                  selectedEnum: personalDetailsController
                                      .selectedMaritalStatus),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Preferred Language"),
                              const SizedBox(height: 9),
                              dropDown(
                                  overlayWidgetController:
                                      preferredLanguageOverlayWidgetController,
                                  type: "preferredLanguage",
                                  enumList: GetControllers.shared
                                      .getEnumController()
                                      .preferredLanguageList
                                      .value,
                                  selectedEnum: personalDetailsController
                                      .selectedPreferredLanguage),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Country of Residence"),
                              const SizedBox(height: 9),
                              DropdownFormField(
                                overlayWidgetController: countryOverlayWidgetController,
                                  list:
                                      personalDetailsController.countryResidenceList,
                                  selectedValueController: personalDetailsController
                                      .countryOfResidenceTextEditingController),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Citizenship Status"),
                              const SizedBox(height: 9),
                              dropDown(
                                  overlayWidgetController:
                                      citizenshipStatusOverlayWidgetController,
                                  type: "citizenshipStatus",
                                  enumList: GetControllers.shared
                                      .getEnumController()
                                      .citizenshipStatusList
                                      .value,
                                  selectedEnum: personalDetailsController
                                      .selectedCitizenshipStatus),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Risk Profile"),
                              const SizedBox(height: 9),
                              dropDown(
                                  overlayWidgetController:
                                      riskProfileListOverlayWidgetController,
                                  type: "riskProfile",
                                  enumList: GetControllers.shared
                                      .getEnumController()
                                      .riskProfileList
                                      .value,
                                  selectedEnum:
                                      personalDetailsController.selectedRiskProfile),
                              const SizedBox(height: 24),
                              checkBoxWidget(personalDetailsController.isNominations,
                                  "Nominations"),
                              const SizedBox(height: 24),
                              checkBoxWidget(
                                  personalDetailsController.isWill, "Will"),
                              const SizedBox(height: 24),
                              checkBoxWidget(personalDetailsController.isLPA,
                                  "LPA (Lasting Power of Attorney)"),
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => personalDetailsController.isLoading.value
                    ? const Loader()
                    : const Offstage(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDown(
      {required ExpandableOverlayWidgetController overlayWidgetController,
      required String type,
      required List<EnumResponseModel> enumList,
      required Rx<EnumResponseModel> selectedEnum}) {
    return Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 1.0),
            borderRadius: const BorderRadius.all(
                Radius.circular(10) //                 <--- border radius here
                )),
        child: ExpandableOverlayWidget(
          controller: overlayWidgetController,
          elevation: 4,
          //shadowColor: AppColors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: AppColors.white,
          duration: const Duration(milliseconds: 280),
          gap: 4,
          onStatesChange: (value) {
            if (type == "marital") {
              eduOverlayWidgetController.hide();
              preferredLanguageOverlayWidgetController.hide();
              citizenshipStatusOverlayWidgetController.hide();
              riskProfileListOverlayWidgetController.hide();
            } else if (type == "education") {
              maritalStatusOverlayWidgetController.hide();
              preferredLanguageOverlayWidgetController.hide();
              citizenshipStatusOverlayWidgetController.hide();
              riskProfileListOverlayWidgetController.hide();
            } else if (type == "preferredLanguage") {
              maritalStatusOverlayWidgetController.hide();
              eduOverlayWidgetController.hide();
              citizenshipStatusOverlayWidgetController.hide();
              riskProfileListOverlayWidgetController.hide();
            } else if (type == "citizenshipStatus") {
              maritalStatusOverlayWidgetController.hide();
              eduOverlayWidgetController.hide();
              preferredLanguageOverlayWidgetController.hide();
              riskProfileListOverlayWidgetController.hide();
            } else if (type == "riskProfile") {
              maritalStatusOverlayWidgetController.hide();
              eduOverlayWidgetController.hide();
              preferredLanguageOverlayWidgetController.hide();
              citizenshipStatusOverlayWidgetController.hide();
            }
          },
          parentWidget: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: Obx(() => Text(
                          selectedEnum.value.description.toString(),
                          style: defaultTheme.textTheme.bodyText1!
                              .copyWith(color: AppColors.textFieldTitleColor),
                        ))),
                const AnimatedRotation(
                  duration: Duration(milliseconds: 260),
                  curve: Curves.fastOutSlowIn,
                  turns: 0.0,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.pointTableBodyColor,
                  ),
                )
              ],
            ),
          ),

          overlayWidget: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            //padding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(maxHeight: 165),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: true,
                itemCount: enumList.length,
                itemBuilder: (_, index) {
                  return item(
                      overlayWidgetController: overlayWidgetController,
                      type: type,
                      value: enumList.elementAt(index),
                      selectedEnum: selectedEnum);
                }),
          ),
        ));
  }

  Widget item(
      {required ExpandableOverlayWidgetController overlayWidgetController,
      required EnumResponseModel value,
      required String type,
      required Rx<EnumResponseModel> selectedEnum}) {
    return InkWell(
      onTap: () {
        overlayWidgetController.hide();
        selectedEnum.value = value;
        /*if (type == "education") {
          selectedEnum.value = value;
        } else if (type == "marital") {
          personalDetailsController.selectedMaritalStatus.value = value;
        }*/
      },
      //style: AppButtonStyles.flat,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        decoration: BoxDecoration(
          color: selectedEnum.value == value
              ? AppColors.orange.withOpacity(0.3)
              : AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value.description.toString(),
          style: defaultTheme.textTheme.bodyText1!.copyWith(
              color: selectedEnum.value == value
                  ? AppColors.orange
                  : AppColors.textFieldTitleColor),
        ),
      ),
    );
  }

  //terms checkbox
  Widget checkBoxWidget(RxBool checkBox, String checkBoxName) {
    return Obx(() => Row(
          children: [
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                side: MaterialStateBorderSide.resolveWith(
                  (states) =>
                      const BorderSide(width: 1.5, color: AppColors.orange),
                ),
                checkColor: AppColors.white,
                activeColor: AppColors.orange,
                value: checkBox.value,
                onChanged: (value) {
                  checkBox.value = value!;
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                checkBoxName,
                style: defaultTheme.textTheme.bodyText2!.copyWith(fontSize: 12),
              ),
            ),
          ],
        ));
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
}
