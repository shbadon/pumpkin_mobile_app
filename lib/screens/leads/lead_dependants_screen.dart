import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/lead_dependants_controller.dart';
import 'package:pumpkin/models/response_models/lead_dependents_response_model.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/services/repository.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/buttons/button_type_two.dart';
import 'package:pumpkin/widgets/forms/country_picker.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/forms/dropdown_enum_field.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';
import 'package:pumpkin/widgets/listTile/list_tile_dependant.dart';
import 'package:pumpkin/widgets/loader.dart';

class LeadDependantsScreen extends StatefulWidget {
  const LeadDependantsScreen({Key? key}) : super(key: key);

  @override
  State<LeadDependantsScreen> createState() => _LeadDependantsScreenState();
}

class _LeadDependantsScreenState extends State<LeadDependantsScreen> {
  LeaddependantsScreenController dependantsController =
      GetControllers.shared.getLeaddependantsScreenController();

  final addFormKey = GlobalKey<FormState>();

  @override
  void initState() {

    setDetailsUpdateData();

    super.initState();
  }

  void setDetailsUpdateData() {
    log("Lead:: setDetailsUpdateData");
    Future.delayed(const Duration(microseconds: 100), () {
      if (Get.arguments != null && Get.arguments.length == 3) {
        LeadModel leadModel = Get.arguments[2];
        GetControllers.shared.getAddLeadScreenController().leadID.value =
            leadModel.id.toString();
        dependantsController.getDependants();
        log("Lead:: " + leadModel.toJson().toString());
      } else {
        log("Lead:: setDetailsUpdateData null");
        dependantsController.getDependants();
      }
    });
  }

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
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.black,
                            size: 18,
                          ),
                        ),
                        Text('Dependants',
                            style: defaultTheme.textTheme.headline3),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            // If the form is valid, then send value to server and move to next screen
                            dependantsController.save();
                          },
                          child: Text('Save',
                              style: defaultTheme.textTheme.headline5!
                                  .copyWith(color: AppColors.primaryColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Obx(
                      () => dependantsController.dependentsList.isEmpty
                          ? const Offstage()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  dependantsController.dependentsList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: ListTileDependant(
                                    icon: "assets/icons/filter.svg",
                                    name: dependantsController
                                        .dependentsList[index].name,
                                    email: dependantsController
                                        .dependentsList[index].email,
                                    phone:
                                        "+${dependantsController.dependentsList[index].countryCode} ${dependantsController.dependentsList[index].mobile}",
                                    relation: dependantsController
                                        .dependentsList[index].relationship,
                                    onPressedDelete: () {
                                      debugPrint(index.toString());
                                      debugPrint("onPressedDelete:: ");
                                      dependantsController.dependentsList
                                          .removeAt(index);
                                    },
                                    onPressedEdit: () {
                                      debugPrint(index.toString());
                                      debugPrint("onPressedEdit:: ");
                                      addDependantBottomSheet(
                                          "Edit Dependants",
                                          true,
                                          dependantsController
                                              .dependentsList[index],
                                          index);
                                    },
                                  ),
                                );
                              }),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => dependantsController.dependentsList.isEmpty
                          ? Center(
                              child: ButtonTypeTwo(
                                  buttonText: 'Add Dependants !',
                                  onPressed: () {
                                    addDependantBottomSheet("Add Dependants",
                                        false, OneDependentModel(), 0);
                                  }),
                            )
                          : ButtonTypeTwo(onPressed: () {
                              addDependantBottomSheet("Add Dependants", false,
                                  OneDependentModel(), 0);
                            }),
                    ),
                    const SizedBox(height: 160),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => dependantsController.isLoading.value
                ? const Loader()
                : const Offstage(),
          )
        ],
      ),
    );
  }

  Future addDependantBottomSheet(
      String title, bool isUpdate, OneDependentModel model, int index) {
    if (isUpdate) {
      dependantsController.nameTextEditingController.text =
          model.name.toString();
      dependantsController.mobileNumberTextEditingController.text =
          model.mobile.toString();
      dependantsController.countryCode = model.countryCode.toString();
      dependantsController.countryCodeLabel = model.countryLabel.toString();
      dependantsController.emailTextEditingController.text =
          model.email.toString();
      dependantsController.selectedReletionship.description =
          model.relationship.toString();
    }

    return Get.bottomSheet(
      isScrollControlled: true,
      //elevation: 5,
      //ignoreSafeArea: false,
      //persistent: true,
      backgroundColor: Colors.transparent,
      SizedBox(
        height: Get.height * 0.7,
        child: Container(
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Form(
              key: addFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: defaultTheme.textTheme.headline4),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Get.back();
                            dependantsController.clearAllFields();
                          },
                          child: Text('Cancel',
                              style: defaultTheme.textTheme.headline5!
                                  .copyWith(color: AppColors.primaryColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Name*"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.fullnameWithClear,
                        controller:
                            dependantsController.nameTextEditingController,
                        hintText: "eg: John Doe",
                        key: const Key('name')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Email Address*"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.emailWithClear,
                        controller:
                            dependantsController.emailTextEditingController,
                        hintText: "eg: johndoe@mail.com",
                        key: const Key('email')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Mobile Number*"),
                    const SizedBox(height: 9),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountryPicker(
                          initCountryLabel:
                              isUpdate ? model.countryLabel : "SG",
                          onCountryCodeSelected: (value) {
                            dependantsController.countryCode = value;
                          },
                          onCountryLabelSelected: (value) {
                            dependantsController.countryCodeLabel = value;
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: CustomTextField(
                                type: InputFieldTypes.numberWithClear,
                                controller: dependantsController
                                    .mobileNumberTextEditingController,
                                hintText: "eg: 6784883897",
                                key: const Key('phone'))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Relationship with Lead"),
                    const SizedBox(height: 9),
                    DropdownEnumField(
                      overlayWidgetController: ExpandableOverlayWidgetController(),
                        list: GetControllers.shared.getEnumController().relationList.value,
                        initialEnum: dependantsController.selectedReletionship),
                    const SizedBox(height: 30),
                    ButtonTypeOne(
                      key: const Key("Save"),
                      buttonStatus: ButtonStatus.enabled,
                      buttonText: "Save",
                      isGeneralButton: true,
                      onPressed: () {
                        if (addFormKey.currentState!.validate()) {
                          if (isUpdate) {
                            dependantsController.updateDependant(index);
                          } else {
                            dependantsController.add(context);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
