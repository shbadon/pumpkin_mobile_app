import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/profile/complete_profile_screen_controller.dart';
import 'package:pumpkin/models/send_models/certificate_award_send_model.dart';
import 'package:pumpkin/models/send_models/complete_profile_screen_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/buttons/button_type_two.dart';
import 'package:pumpkin/widgets/cards/certificate_and_award_card_widget.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  CompleteProfileScreenController completeProfileScreenController =
      GetControllers.shared.getCompleteProfileScreenController();
  final _certificateAndAwardSheetFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _completeProfileFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _completeProfileFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
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
                            ),
                            Text('Complete your Profile',
                                style: defaultTheme.textTheme.headline3),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const FormFieldTitle(title: "Company Name*"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.text,
                            controller: completeProfileScreenController
                                .companyNameTextEditingController,
                            hintText: "Company Name",
                            key: const Key('Company name')),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Agency Name*"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.text,
                            controller: completeProfileScreenController
                                .agencyNameTextEditingController,
                            hintText: "Agency Name",
                            key: const Key('Agency Name')),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Designation*"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.text,
                            controller: completeProfileScreenController
                                .designationTextEditingController,
                            hintText: "Designation",
                            key: const Key('Designation')),
                        const SizedBox(height: 24),
                        const FormFieldTitle(
                            title: "Accreditations/Certifications"),
                        const SizedBox(height: 9),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: completeProfileScreenController
                                .listOfCertificates.length,
                            itemBuilder: (context, index) {
                              return CertificateAndAwardCardWidget(
                                name: completeProfileScreenController
                                    .listOfCertificates[index].name!,
                                year: completeProfileScreenController
                                    .listOfCertificates[index].year!,
                                onPressed: () {
                                  completeProfileScreenController
                                      .deleteCertificate(
                                          completeProfileScreenController
                                              .listOfCertificates[index].id
                                              .toString());
                                },
                              );
                            }),
                        const SizedBox(height: 9),
                        ButtonTypeTwo(onPressed: () {
                          debugPrint("ButtonTypeTwo:: onPressed bottomSheet");
                          bottomSheet("Accreditations/Certifications", false);
                        }),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Awards"),
                        const SizedBox(height: 9),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: completeProfileScreenController
                                .listOfAwards.length,
                            itemBuilder: (context, index) {
                              return CertificateAndAwardCardWidget(
                                name: completeProfileScreenController
                                    .listOfAwards[index].name!,
                                year: completeProfileScreenController
                                    .listOfAwards[index].year!,
                                onPressed: () {
                                  completeProfileScreenController.deleteAward(
                                      completeProfileScreenController
                                          .listOfAwards[index].id
                                          .toString());
                                },
                              );
                            }),
                        const SizedBox(height: 9),
                        ButtonTypeTwo(onPressed: () {
                          bottomSheet("Awards", true);
                        }),
                        const SizedBox(height: 60),
                        ButtonTypeOne(
                          key: const Key("save"),
                          buttonStatus: ButtonStatus.enabled,
                          buttonText: "Save",
                          isGeneralButton: true,
                          onPressed: () {
                            if (_completeProfileFormKey.currentState!
                                .validate()) {
                              Map<String, dynamic> body =
                                  CompleteprofileScreenSendModel(
                                          companyName:
                                              completeProfileScreenController
                                                  .companyNameTextEditingController
                                                  .text,
                                          agencyName:
                                              completeProfileScreenController
                                                  .agencyNameTextEditingController
                                                  .text,
                                          designation:
                                              completeProfileScreenController
                                                  .designationTextEditingController
                                                  .text,
                                          email: completeProfileScreenController
                                              .email.value)
                                      .toJson();
                              completeProfileScreenController
                                  .completeProfile(body);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            completeProfileScreenController.isLoading.value
                ? const Loader()
                : const Offstage()
          ],
        ),
      ),
    );
  }

  Future bottomSheet(String title, bool isAwards) {
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
        return SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _certificateAndAwardSheetFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title,
                                style: defaultTheme.textTheme.headline4),
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                                completeProfileScreenController.clearFileds();
                              },
                              child: Text('Cancel',
                                  style: defaultTheme.textTheme.bodyText1!
                                      .copyWith(color: AppColors.orange)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Name*"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.text,
                            controller: completeProfileScreenController
                                .certificationAndAwardNameTextEditingController,
                            hintText: "",
                            key: const Key('name')),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Year*"),
                        const SizedBox(height: 9),
                        SizedBox(
                          width: 150,
                          child: CustomTextField(
                            type: InputFieldTypes.year,
                            context: context,
                            dateFormat: "yyyy",
                            controller: completeProfileScreenController
                                .certificationAncdAwardYearTextEditingController,
                            hintText: "eg: 2012", //dd-mm-yyyy
                            key: const Key("year"),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Description"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.textWitoutValidation,
                            controller: completeProfileScreenController
                                .certificationAncdAwardDescriptionTextEditingController,
                            hintText: "",
                            key: const Key('Description')),
                        const SizedBox(height: 18),
                        ButtonTypeOne(
                          key: const Key("Save"),
                          buttonStatus: ButtonStatus.enabled,
                          buttonText: "Save",
                          isGeneralButton: true,
                          onPressed: () {
                            if (_certificateAndAwardSheetFormKey.currentState!
                                .validate()) {
                              Map<String,
                                  dynamic> body = CertificateAndAwardSendModel(
                                      name: completeProfileScreenController
                                          .certificationAndAwardNameTextEditingController
                                          .text,
                                      year:
                                          completeProfileScreenController
                                              .certificationAncdAwardYearTextEditingController
                                              .text,
                                      description: completeProfileScreenController
                                          .certificationAncdAwardDescriptionTextEditingController
                                          .text,
                                      email: completeProfileScreenController
                                          .email.value)
                                  .toJson();
                              isAwards
                                  ? completeProfileScreenController.addAward(
                                      body, context)
                                  : completeProfileScreenController
                                      .addCertificate(body, context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget countryPickerWidget() {
  //   return Container(
  //     height: 45,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         border:
  //             Border.all(color: AppColors.black.withOpacity(0.08), width: 1)),
  //     child: CountryPickerDropdown(
  //       initialValue: "SG",
  //       onValuePicked: (Country value) {},
  //       icon: const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 8),
  //         child: Icon(Icons.keyboard_arrow_down_rounded, size: 24),
  //       ),
  //       selectedItemBuilder: (country) {
  //         return Row(
  //           children: [
  //             Container(
  //               constraints: const BoxConstraints(maxWidth: 60),
  //               alignment: Alignment.center,
  //               child: Text(
  //                 '+${country.phoneCode}',
  //                 textAlign: TextAlign.center,
  //                 style: defaultTheme.textTheme.bodyText2!.copyWith(
  //                   color: AppColors.black.withOpacity(0.8),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: 45,
  //               width: 1,
  //               color: AppColors.black.withOpacity(0.08),
  //             )
  //           ],
  //         );
  //       },
  //       sortComparator: (Country a, Country b) =>
  //           a.isoCode.compareTo(b.isoCode),
  //       itemBuilder: (country) {
  //         return Align(
  //           alignment: Alignment.center,
  //           child: Text(
  //             '+${country.phoneCode} (${country.isoCode})',
  //             textAlign: TextAlign.center,
  //             style: defaultTheme.textTheme.bodyText2!.copyWith(
  //               color: AppColors.black.withOpacity(0.6),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

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
