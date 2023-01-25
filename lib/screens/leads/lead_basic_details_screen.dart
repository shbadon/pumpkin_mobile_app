import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/lead_basic_details_controller.dart';
import 'package:pumpkin/controllers/tags_controller.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/chips/chips.dart';
import 'package:pumpkin/widgets/chips/chips_with_close.dart';
import 'package:pumpkin/widgets/dialog/popupAlertDialog.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/forms/dropdown_form_field.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';
import 'package:pumpkin/widgets/loader.dart';
import 'package:pumpkin/widgets/toast.dart';

class LeadBasicDetailsScreen extends StatefulWidget {
  const LeadBasicDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LeadBasicDetailsScreen> createState() => _LeadBasicDetailsScreenState();
}

class _LeadBasicDetailsScreenState extends State<LeadBasicDetailsScreen> {
  LeadBasicDetailsScreenController basicDetailsController =
      GetControllers.shared.getLeadBasicDetailsScreenController();
  TagsController tagsController = GetControllers.shared.getTagsController();

  final addDetailsFormKey = GlobalKey<FormState>();
  final addTagFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    tagsController.getAllTagsforAgent();
    setDetailsUpdateData();
    super.initState();
  }

  void setDetailsUpdateData() {
    basicDetailsController.isFromLeadProfile.value = Get.arguments != null ? Get.arguments[0] : false;
  }

  final overlayWidgetController = ExpandableOverlayWidgetController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("ontap:: outside");
        overlayWidgetController.hide();
      },
      child: Scaffold(
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
                              overlayWidgetController.hide();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.black,
                              size: 18,
                            ),
                          ),
                          Text('Basic Details',
                              style: defaultTheme.textTheme.headline3),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (addDetailsFormKey.currentState!.validate()) {
                                // If the form is valid, then send value to server and move to next screen

                                showPopupAlertDialogForSeedDone(
                                    basicDetailsController
                                        .remarksTextEditingController,
                                    context: context, buttonTap: () {
                                  Get.back();
                                  if (basicDetailsController
                                      .isFromLeadProfile.value) {
                                    basicDetailsController.detailsUpdate();
                                  } else {
                                    basicDetailsController.save();
                                  }
                                });
                              } else {
                                // Show error message if the terms and condition is not agreed
                                //showErrorToast(AppLabels.fillAllInformation);
                              }
                            },
                            child: Text(
                                basicDetailsController.isFromLeadProfile.value
                                    ? 'Update'
                                    : 'Save',
                                style: defaultTheme.textTheme.headline5!
                                    .copyWith(color: AppColors.primaryColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Obx(
                        () => Align(
                            alignment: Alignment.bottomCenter,
                            child: basicDetailsController
                                    .images.value.path.isNotEmpty
                                ? CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: FileImage(
                                        basicDetailsController.images.value),
                                    radius: 50,
                                  )
                                : basicDetailsController
                                        .profilePictureUrl.value.isNotEmpty
                                    ? CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        foregroundImage: NetworkImage(
                                            basicDetailsController
                                                .profilePictureUrl.value),
                                        radius: 50,
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppColors.green,
                                        child: Text(
                                          "No image",
                                          style: defaultTheme
                                              .textTheme.bodyText2!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: AppColors.white),
                                        ))),
                      ),
                      const SizedBox(height: 25),
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          basicDetailsController.getImage();
                        },
                        child: Center(
                          child: basicDetailsController
                                      .agentDetailsResponseModel.photo ==
                                  null
                              ? Text('Add Profile Photo',
                                  style: defaultTheme.textTheme.bodyText1!
                                      .copyWith(
                                          color: AppColors.orange,
                                          fontWeight: FontWeight.w600))
                              : Text('Edit Profile Photo',
                                  style: defaultTheme.textTheme.bodyText1!
                                      .copyWith(
                                          color: AppColors.orange,
                                          fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Form(
                          key: addDetailsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 32),
                              const FormFieldTitle(title: "First Name*"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                  type: InputFieldTypes.firstNameWithClear,
                                  controller: basicDetailsController
                                      .firstNametextEditingController,
                                  hintText: "eg: John",
                                  key: const Key('first name')),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Last Name*"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                  type: InputFieldTypes.lastNameWithClear,
                                  controller: basicDetailsController
                                      .lastNameTextEditingController,
                                  hintText: "eg: Doe",
                                  key: const Key('last name')),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Add Tags"),
                              const SizedBox(height: 9),
                              Obx(
                                () => Wrap(
                                  children: List.generate(
                                      basicDetailsController
                                          .selectedTagsList.length,
                                      (index) => InkWell(
                                            onTap: index == 0
                                                ? () {
                                                    bottomSheetOne('Add Tag',
                                                        context, addTagFormKey);
                                                    // basicDetailsController
                                                    //     .openTagBottomSheet();
                                                  }
                                                : null,
                                            child: MyChipWithClose(
                                              chipText: index == 0
                                                  ? '   +   '
                                                  : basicDetailsController
                                                      .selectedTagsList[index]
                                                      .name
                                                      .toString(),
                                              labelStyle: index == 0
                                                  ? defaultTheme
                                                      .textTheme.bodyText1!
                                                      .copyWith(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontSize: 20)
                                                  : null,
                                              borderColor: index == 0
                                                  ? AppColors.iconBG
                                                  : null,
                                              backgroundColor: index == 0
                                                  ? Colors.transparent
                                                  : null,
                                              onDelete: index == 0
                                                  ? null
                                                  : () {
                                                      basicDetailsController
                                                          .selectedTagsList
                                                          .removeAt(index);
                                                      // basicDetailsController
                                                      //     .tempTagList
                                                      //     .removeAt(index);
                                                    },
                                            ),
                                          )),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Gender*"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: RadioListTile(
                                      title: Text("Male",
                                          style:
                                              defaultTheme.textTheme.bodyText1),
                                      activeColor: AppColors.orange,
                                      value: "male",
                                      contentPadding: EdgeInsets.zero,
                                      groupValue: basicDetailsController.gender,
                                      onChanged: (value) {
                                        setState(() {
                                          basicDetailsController.gender =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: RadioListTile(
                                      title: Text("Female",
                                          style:
                                              defaultTheme.textTheme.bodyText1),
                                      activeColor: AppColors.orange,
                                      value: "female",
                                      contentPadding: EdgeInsets.zero,
                                      groupValue: basicDetailsController.gender,
                                      onChanged: (value) {
                                        setState(() {
                                          basicDetailsController.gender =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Date of Birth"),
                      const SizedBox(height: 9),
                      CustomTextField(
                        type: InputFieldTypes.dob,
                        dateFormat: "yyyy-MM-dd",
                        context: context,
                        controller: basicDetailsController
                            .dateOfBirthTextEditingController,
                        hintText: "",
                        //dd-mm-yyyy
                        key: const Key("dateOfBirth"),
                      ),
                      const SizedBox(height: 24),
                      const Divider(
                        height: 1,
                        endIndent: 30,
                        indent: 30,
                      ),
                      const SizedBox(height: 24),
                      Text("Address",
                          style: defaultTheme.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 15),
                      const FormFieldTitle(title: "Zip Code"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.text,
                          autoValidate: false,
                          controller: basicDetailsController
                              .zipCodeTextEditingController,
                          hintText: "Zip Code",
                          key: const Key('Zip Code')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Address line 1"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.text,
                          controller: basicDetailsController
                              .addressLine1TextEditingController,
                          hintText: "Address line 1",
                          key: const Key('Address line 1')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Address line 2"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.text,
                          controller:
                              basicDetailsController.addressLine2Controller,
                          hintText: "Address line 2",
                          key: const Key('Address line 2')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Country"),
                      const SizedBox(height: 9),
                      DropdownFormField(
                          overlayWidgetController: overlayWidgetController,
                          list: GetControllers.shared.getEnumController().countryList,
                          selectedValueController: basicDetailsController
                              .countryTextEditingController),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => basicDetailsController.isLoading.value
                  ? const Loader()
                  : const Offstage(),
            )
          ],
        ),
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
}

// This Bottom sheet is to add the Tags
Future bottomSheetOne(String title, context, addTagFormKey) {
  LeadBasicDetailsScreenController basicDetailsController =
      GetControllers.shared.getLeadBasicDetailsScreenController();
  TagsController tagsController = GetControllers.shared.getTagsController();

  return showModalBottomSheet(
    context: context,
    // color is applied to main screen when modal bottom screen is displayed
    //barrierColor: Colors.greenAccent,
    //background color for modal bottom screen
    backgroundColor: AppColors.white,
    //elevates modal bottom screen
    elevation: 10,
    isScrollControlled: true,
    // gives rounded corner to modal bottom screen
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      // UDE : SizedBox instead of Container for whitespaces
      return StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: defaultTheme.textTheme.headline4),
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                              basicDetailsController.makeIsSelectedFalse(
                                  tagsController.tagsRespnseModel.value);
                            },
                            child: Text('Cancel',
                                style: defaultTheme.textTheme.bodyText1!
                                    .copyWith(
                                        color: AppColors.orange,
                                        fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      tagsController.tagsRespnseModel.value.tags!.length
                              .isEqual(0)
                          ? Center(
                              child: Text(
                                '',
                                style: defaultTheme.textTheme.bodyText1,
                              ),
                            )
                          : Text(
                              'Select Tags',
                              style: defaultTheme.textTheme.bodyText1,
                            ),
                      Obx(
                        () => tagsController.tagsRespnseModel.value.tags == null
                            ? Center(
                                child: Text(
                                'Fetching Tags...',
                                style: defaultTheme.textTheme.bodyText1,
                              ))
                            : Wrap(
                                children: List.generate(
                                    tagsController
                                        .tagsRespnseModel.value.tags!.length,
                                    (index) => InkWell(
                                        onTap: () {
                                          if (tagsController
                                                  .tagsRespnseModel
                                                  .value
                                                  .tags![index]
                                                  .isSelected ==
                                              false) {
                                            // If tags is not selected then select the tag and add to the list
                                            setState(() {
                                              tagsController
                                                  .tagsRespnseModel
                                                  .value
                                                  .tags![index]
                                                  .isSelected = true;
                                            });
                                            // Add tag to the temp list to show in UI when clicked on save button
                                            // basicDetailsController.tempTagList
                                            //     .addIf(
                                            //         !basicDetailsController
                                            //             .selectedTagsList
                                            //             .contains(tagsController
                                            //                 .tagsRespnseModel
                                            //                 .value
                                            //                 .tags![index]),
                                            //         tagsController
                                            //             .tagsRespnseModel
                                            //             .value
                                            //             .tags![index]);
                                            // debugPrint(basicDetailsController
                                            //     .tempTagList
                                            //     .toString());
                                            basicDetailsController
                                                .selectedTagsList
                                                .addIf(
                                                    !basicDetailsController
                                                        .selectedTagsList
                                                        .contains(tagsController
                                                            .tagsRespnseModel
                                                            .value
                                                            .tags![index]),
                                                    tagsController
                                                        .tagsRespnseModel
                                                        .value
                                                        .tags![index]);
                                          } else {
                                            // If tags is selected then de-select the tag
                                            setState(() {
                                              tagsController
                                                  .tagsRespnseModel
                                                  .value
                                                  .tags![index]
                                                  .isSelected = false;
                                            });
                                            // Remove the tag from the tags list
                                            basicDetailsController
                                                .selectedTagsList
                                                .remove(tagsController
                                                    .tagsRespnseModel
                                                    .value
                                                    .tags![index]);
                                          }
                                        },
                                        child: Obx(
                                          () => MyChips(
                                            chipText: tagsController
                                                .tagsRespnseModel
                                                .value
                                                .tags![index]
                                                .name!,
                                            isSelected: tagsController
                                                .tagsRespnseModel
                                                .value
                                                .tags![index]
                                                .isSelected,
                                          ),
                                        ))),
                              ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showPopupAlertForEditTag(
                                  'Add New Tag',
                                  basicDetailsController
                                      .addTagTextEditingController,
                                  'Add',
                                  'Cancel', rightButtonTap: () {
                                // If textediting controller is not empty
                                if (basicDetailsController
                                    .addTagTextEditingController
                                    .text
                                    .isNotEmpty) {
                                  Map<String, dynamic> body = {
                                    'name': basicDetailsController
                                        .addTagTextEditingController.text
                                  };
                                  tagsController.addTag(
                                      body: body, context: context);
                                } else {
                                  // If textEditing controller is empty
                                  showErrorToast('Please enter a Tag');
                                }
                              });
                            },
                            child: MyChipWithClose(
                              chipText: '   +   ',
                              backgroundColor: Colors.transparent,
                              borderColor: AppColors.iconBG,
                              labelStyle: defaultTheme.textTheme.bodyText1!
                                  .copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 20),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(manageTagsScreen)!.then((value) {
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              'Manage Tags',
                              style: defaultTheme.textTheme.bodyText1!.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonTypeOne(
                        key: const Key("Save"),
                        buttonStatus: ButtonStatus.enabled,
                        buttonText: "Save",
                        isGeneralButton: true,
                        onPressed: () {
                          Navigator.pop(context);
                          basicDetailsController.makeIsSelectedFalse(
                              tagsController.tagsRespnseModel.value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
