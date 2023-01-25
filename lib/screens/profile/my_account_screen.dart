import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/profile/my_account_screen_controller.dart';
import 'package:pumpkin/models/send_models/certificate_award_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/buttons/button_type_two.dart';
import 'package:pumpkin/widgets/cards/certificate_and_award_card_widget.dart';
import 'package:pumpkin/widgets/dialog/popupAlertDialog.dart';
import 'package:pumpkin/widgets/forms/country_picker.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';
import 'package:pumpkin/widgets/toast.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  MyAccountScreenController myAccountScreenController =
      GetControllers.shared.getMyAccountScreenController();
  final _certificateAndAwardSheetFormKey = GlobalKey<FormState>();

  final _profileUpdateFormKey = GlobalKey<FormState>();
  final _emailUpdateFormKey = GlobalKey<FormState>();
  final _mobileUpdateFormKey = GlobalKey<FormState>();

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
                  key: _profileUpdateFormKey,
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
                          Text('My Account',
                              style: defaultTheme.textTheme.headline3),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (_profileUpdateFormKey.currentState!
                                  .validate()) {
                                // If the form is valid, then send value to server and move to next screen
                                myAccountScreenController.save();
                              } else {
                                // Show error message if the terms and condition is not agreed
                                showErrorToast(AppLabels.fillAllInformation);
                              }
                            },
                            child: Text('Save',
                                style: defaultTheme.textTheme.headline5!
                                    .copyWith(color: AppColors.primaryColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Obx(
                        () => Align(
                          alignment: Alignment.bottomCenter,
                          child: myAccountScreenController
                                  .profilePictureUrl.isEmpty
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.green,
                                  child: Text(
                                    myAccountScreenController
                                        .agentDetailsResponseModel.firstName!
                                        .split('')
                                        .first,
                                    style: defaultTheme.textTheme.headline1!
                                        .copyWith(
                                            fontSize: 48,
                                            color: AppColors.white),
                                  ))
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: NetworkImage(
                                      myAccountScreenController
                                          .profilePictureUrl.value
                                          .toString()),
                                  radius: 50,
                                ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          myAccountScreenController.getImage();
                        },
                        child: Center(
                          child: myAccountScreenController
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
                      const SizedBox(height: 32),
                      const FormFieldTitle(title: "First Name*"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.firstNameWithClear,
                          controller: myAccountScreenController
                              .firstNametextEditingController,
                          hintText: "eg: John",
                          key: const Key('first name')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Last Name*"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.lastNameWithClear,
                          controller: myAccountScreenController
                              .lastNameTextEditingController,
                          hintText: "eg: Doe",
                          key: const Key('last name')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Date of Birth*"),
                      const SizedBox(height: 9),
                      CustomTextField(
                        type: InputFieldTypes.dob,
                        context: context,
                        controller: myAccountScreenController
                            .dateOfBirthTextEditingController,
                        hintText: "",
                        //dd-mm-yyyy
                        key: const Key("dateOfBirth"),
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
                                  style: defaultTheme.textTheme.bodyText1),
                              activeColor: AppColors.orange,
                              value: "male",
                              contentPadding: EdgeInsets.zero,
                              groupValue: myAccountScreenController.gender,
                              onChanged: (value) {
                                setState(() {
                                  myAccountScreenController.gender =
                                      value.toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: RadioListTile(
                              title: Text("Female",
                                  style: defaultTheme.textTheme.bodyText1),
                              activeColor: AppColors.orange,
                              value: "female",
                              contentPadding: EdgeInsets.zero,
                              groupValue: myAccountScreenController.gender,
                              onChanged: (value) {
                                setState(() {
                                  myAccountScreenController.gender =
                                      value.toString();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      const FormFieldTitle(title: "Email Address*"),
                      const SizedBox(height: 9),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 3),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.borderColor, width: 1.0),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(
                                    10) //                 <--- border radius here
                                )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              myAccountScreenController
                                  .emailTextEditingController.text,
                              style: defaultTheme.textTheme.bodyText1,
                            ),
                            InkWell(
                              onTap: myAccountScreenController
                                          .agentDetailsResponseModel
                                          .registerType ==
                                      'manual'
                                  ? () {
                                      changeEmailBottomSheet();
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.validColor,
                                  ),
                                  const SizedBox(width: 10),
                                  myAccountScreenController
                                              .agentDetailsResponseModel
                                              .registerType ==
                                          'manual'
                                      ? Text('Change',
                                          style: defaultTheme
                                              .textTheme.headline5!
                                              .copyWith(
                                                  color:
                                                      AppColors.primaryColor))
                                      : Text('Change',
                                          style: defaultTheme
                                              .textTheme.headline5!
                                              .copyWith(
                                                  color: AppColors.iconBG)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Mobile Number*"),
                      const SizedBox(height: 9),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 3),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.borderColor, width: 1.0),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(
                                    10) //                 <--- border radius here
                                )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '+' +
                                  myAccountScreenController.countryCode! +
                                  ' ' +
                                  myAccountScreenController
                                      .mobileNumberTextEditingController.text,
                              style: defaultTheme.textTheme.bodyText1,
                            ),
                            InkWell(
                              onTap: () {
                                changeMobileBottomSheet();
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.validColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Text('Change',
                                      style: defaultTheme.textTheme.headline5!
                                          .copyWith(
                                              color: AppColors.primaryColor)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Profile Message"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.textArea,
                          controller: myAccountScreenController
                              .profileMessageTextEditingController,
                          hintText: "",
                          key: const Key('Message')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Company Name*"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.text,
                          controller: myAccountScreenController
                              .companyNameTextEditingController,
                          hintText: "Company Name",
                          key: const Key('Company name')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Agency Name*"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.text,
                          controller: myAccountScreenController
                              .agencyNameTextEditingController,
                          hintText: "Agency Name",
                          key: const Key('Agency Name')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Designation*"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.text,
                          controller: myAccountScreenController
                              .designationTextEditingController,
                          hintText: "Designation",
                          key: const Key('Designation')),
                      const SizedBox(height: 24),
                      const FormFieldTitle(
                          title: "Accreditations/Certifications"),
                      const SizedBox(height: 9),
                      Obx(
                        () => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: myAccountScreenController
                                .listOfCertificates.length,
                            itemBuilder: (context, index) {
                              return CertificateAndAwardCardWidget(
                                name: myAccountScreenController
                                    .listOfCertificates[index].name!,
                                year: myAccountScreenController
                                    .listOfCertificates[index].year!,
                                onPressed: () {
                                  showPopupAlertConfirmDialog(
                                      "Delete",
                                      "Are you sure you want to delete your Certification?",
                                      "Delete",
                                      "Cancel", rightButtonTap: () {
                                    HapticFeedback.lightImpact();
                                    Get.back();
                                    myAccountScreenController.deleteCertificate(
                                        myAccountScreenController
                                            .listOfCertificates[index].id
                                            .toString());
                                  }, height: 131);
                                },
                              );
                            }),
                      ),
                      const SizedBox(height: 5),
                      ButtonTypeTwo(onPressed: () {
                        debugPrint("ButtonTypeTwo:: onPressed bottomSheet");
                        addBottomSheet("Accreditations/Certifications", false);
                      }),
                      const SizedBox(height: 24),
                      const FormFieldTitle(title: "Awards"),
                      const SizedBox(height: 9),
                      Obx(
                        () => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                myAccountScreenController.listOfAwards.length,
                            itemBuilder: (context, index) {
                              return CertificateAndAwardCardWidget(
                                name: myAccountScreenController
                                    .listOfAwards[index].name!,
                                year: myAccountScreenController
                                    .listOfAwards[index].year!,
                                onPressed: () {
                                  showPopupAlertConfirmDialog(
                                      "Delete",
                                      "Are you sure you want to delete your Award?",
                                      "Delete",
                                      "Cancel", rightButtonTap: () {
                                    HapticFeedback.lightImpact();
                                    Get.back();
                                    myAccountScreenController.deleteAward(
                                        myAccountScreenController
                                            .listOfAwards[index].id
                                            .toString());
                                  }, height: 131);
                                },
                              );
                            }),
                      ),
                      const SizedBox(height: 5),
                      ButtonTypeTwo(onPressed: () {
                        addBottomSheet("Awards", true);
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => myAccountScreenController.isLoading.value
                ? const Loader()
                : const Offstage(),
          )
        ],
      ),
    );
  }

  Future addBottomSheet(String title, bool isAwards) {
    return showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: AppColors.white,
      //elevates modal bottom screen
      elevation: 10,
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
                                myAccountScreenController.clearFileds();
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
                            type: InputFieldTypes.fullnameWithClear,
                            controller: myAccountScreenController
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
                            controller: myAccountScreenController
                                .certificationAncdAwardYearTextEditingController,
                            hintText: "eg: 2012",
                            //dd-mm-yyyy
                            key: const Key("year"),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const FormFieldTitle(title: "Description"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.textWitoutValidation,
                            controller: myAccountScreenController
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
                                      name: myAccountScreenController
                                          .certificationAndAwardNameTextEditingController
                                          .text,
                                      year:
                                          myAccountScreenController
                                              .certificationAncdAwardYearTextEditingController
                                              .text,
                                      description: myAccountScreenController
                                          .certificationAncdAwardDescriptionTextEditingController
                                          .text,
                                      email: myAccountScreenController
                                          .agentDetailsResponseModel.email!)
                                  .toJson();
                              isAwards
                                  ? myAccountScreenController.addAward(
                                      body, context)
                                  : myAccountScreenController.addCertificate(
                                      body, context);
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

  Future changeMobileBottomSheet() {
    return showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: AppColors.white,
      //elevates modal bottom screen
      elevation: 10,
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
                    key: _mobileUpdateFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Change Mobile Number",
                                style: defaultTheme.textTheme.headline4),
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',
                                  style: defaultTheme.textTheme.bodyText1!
                                      .copyWith(color: AppColors.orange)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Enter the new Mobile Number for verification.',
                          style: defaultTheme.textTheme.bodyText1?.copyWith(
                              color: AppColors.black.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 32),
                        const FormFieldTitle(title: "Mobile Number*"),
                        const SizedBox(height: 9),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryPicker(
                              onCountryCodeSelected: (value) {
                                myAccountScreenController.changeCountryCode =
                                    value;
                              },
                              onCountryLabelSelected: (value) {
                                myAccountScreenController.countryCodeLabel =
                                    value;
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: CustomTextField(
                                    type: InputFieldTypes.numberWithClear,
                                    controller: myAccountScreenController
                                        .changeMobileNumberTextEditingController,
                                    hintText: "eg: 6784883897",
                                    key: const Key('phone'))),
                          ],
                        ),
                        const SizedBox(height: 18),
                        ButtonTypeOne(
                          key: const Key("Save"),
                          buttonStatus: ButtonStatus.enabled,
                          buttonText: "Save",
                          isGeneralButton: true,
                          onPressed: () {
                            if (_mobileUpdateFormKey.currentState!.validate()) {
                              // If the form is valid, then send value to server and move to next screen
                              myAccountScreenController.changeMobileSave();
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

  Future changeEmailBottomSheet() {
    return showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: AppColors.white,
      //elevates modal bottom screen
      elevation: 10,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change Email Address",
                              style: defaultTheme.textTheme.headline4),
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: defaultTheme.textTheme.bodyText1!
                                    .copyWith(color: AppColors.orange)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Enter the new email address for verification.',
                        style: defaultTheme.textTheme.bodyText1
                            ?.copyWith(color: AppColors.black.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 32),
                      const FormFieldTitle(title: "Email"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.emailWithClear,
                          controller: myAccountScreenController
                              .changeEmailTextEditingController,
                          hintText: "Enter email",
                          key: const Key('email_phone')),
                      const SizedBox(height: 18),
                      ButtonTypeOne(
                        key: const Key("Save"),
                        buttonStatus: ButtonStatus.enabled,
                        buttonText: "Save",
                        isGeneralButton: true,
                        onPressed: () {
                          Map<String, dynamic> body = {
                            'email': myAccountScreenController
                                .changeEmailTextEditingController.text
                          };
                          myAccountScreenController.changeEmail(context, body);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
