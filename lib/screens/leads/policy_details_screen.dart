import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/policy_details_screen_controller.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/services/repository.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/forms/dropdown_enum_field.dart';
import 'package:pumpkin/widgets/forms/dropdown_form_field.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';

// ignore: must_be_immutable
class PolicyDetailsScreen extends StatefulWidget {
  PolicyDetailsScreen({super.key});

  @override
  State<PolicyDetailsScreen> createState() => _PolicyDetailsScreenState();
}

class _PolicyDetailsScreenState extends State<PolicyDetailsScreen> {
  final policyDetailsForm = GlobalKey<FormState>();

  PolicyDetailsScreenController policyDetailsScreenController =
      GetControllers.shared.getPolicyDetailsController();

  final overlayWidgetController = ExpandableOverlayWidgetController();

  @override
  void dispose() {
    policyDetailsScreenController.isFromLeadProfile.value = false;
    policyDetailsScreenController.policyID = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("ontap:: outside");
        overlayWidgetController.hide();
      },
      child: Scaffold(
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
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
                        overlayWidgetController.hide();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                      ),
                    ),
                    Text('Policy Details',
                        style: defaultTheme.textTheme.headline3),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        policyDetailsScreenController.onTapSave();
                      },
                      child: Text('Save',
                          style: defaultTheme.textTheme.headline5!
                              .copyWith(color: AppColors.primaryColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const FormFieldTitle(title: "Policy Number"),
                const SizedBox(height: 9),
                CustomTextField(
                    type: InputFieldTypes.text,
                    isValidationEnabled: false,
                    controller: policyDetailsScreenController
                        .policyNumberTextEditingController,
                    hintText: "",
                    key: const Key('policyNumber')),
                const SizedBox(height: 18),
                const FormFieldTitle(title: "Policy Name"),
                const SizedBox(height: 9),
                CustomTextField(
                    type: InputFieldTypes.text,
                    isValidationEnabled: false,
                    controller: policyDetailsScreenController
                        .policyNameTextEditingController,
                    hintText: "",
                    key: const Key('policyName')),
                const SizedBox(height: 18),
                const FormFieldTitle(title: "Annual Premium"),
                const SizedBox(height: 9),
                CustomTextField(
                    type: InputFieldTypes.money,
                    isValidationEnabled: false,
                    controller: policyDetailsScreenController
                        .annualPremiumTextEditingController,
                    hintText: "",
                    key: const Key('annualPremium')),
                const SizedBox(height: 18),
                const FormFieldTitle(title: "FYC"),
                const SizedBox(height: 9),
                CustomTextField(
                    type: InputFieldTypes.numberWithClear,
                    isValidationEnabled: false,
                    controller:
                        policyDetailsScreenController.fycTextEditingController,
                    hintText: "",
                    key: const Key('fyc')),
                const SizedBox(height: 18),
                const FormFieldTitle(title: "Payment Mode"),
                const SizedBox(height: 9),
                DropdownEnumField(
                  overlayWidgetController: overlayWidgetController,
                    list: GetControllers.shared
                        .getEnumController()
                        .paymentModeList
                        .value,
                    initialEnum: policyDetailsScreenController
                        .selectedPaymentMode.value),
                const SizedBox(height: 18),
                const FormFieldTitle(title: "Application Date"),
                const SizedBox(height: 9),
                CustomTextField(
                    context: context,
                    type: InputFieldTypes.date,
                    controller: policyDetailsScreenController
                        .applicationDateTextEditingController,
                    hintText: "",
                    dateFormat: "yyyy-MM-dd",
                    key: const Key('applicationDate')),
                const SizedBox(height: 18),
                const FormFieldTitle(title: "Remarks"),
                const SizedBox(height: 9),
                CustomTextField(
                    type: InputFieldTypes.textArea,
                    controller: policyDetailsScreenController
                        .remarksTextEditingController,
                    hintText: "",
                    key: const Key('remarks')),
                const SizedBox(height: 18),
                Row(
                  children: [
                    checkBoxWidget(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Indication of Inforce',
                        style: defaultTheme.textTheme.bodyText2!
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        )),
      ),
    );
  }

  //terms checkbox
  Widget checkBoxWidget() {
    return Obx(() => SizedBox(
          width: 24.0,
          height: 24.0,
          child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            side: MaterialStateBorderSide.resolveWith(
              (states) =>
                  const BorderSide(width: 1.5, color: AppColors.primaryColor),
            ),
            checkColor: AppColors.white,
            activeColor: AppColors.orange,
            value: policyDetailsScreenController
                .indicationOfInforceisChecked.value,
            onChanged: (value) {
              policyDetailsScreenController.indicationOfInforceisChecked.value =
                  value!;
            },
          ),
        ));
  }
}
