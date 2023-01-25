import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/profile/setup_profile_screen_controller.dart';
import 'package:pumpkin/models/send_models/setup_profile_screen_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({Key? key}) : super(key: key);

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  SetupProfileScreenController setupProfileScreenController =
      GetControllers.shared.getSetupProfileScreenController();
  final _setUpProfileKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 210,
                      child: Stack(
                        children: [
                          Container(
                            height: 160,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.setupProfileBG,
                            padding: const EdgeInsets.only(top: 50, left: 24),
                            child: Text('Setup your Profile',
                                style: defaultTheme.textTheme.headline3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.green,
                                backgroundImage: setupProfileScreenController
                                        .profilePictureUrl.isNotEmpty
                                    ? NetworkImage(setupProfileScreenController
                                        .profilePictureUrl
                                        .toString())
                                    : null,
                                child: setupProfileScreenController
                                        .profilePictureUrl.isEmpty
                                    ? Text(
                                        setupProfileScreenController
                                            .setPasswordScreenResponseModel
                                            .value
                                            .firstName
                                            .toString()
                                            .split('')
                                            .first,
                                        style: defaultTheme.textTheme.headline1!
                                            .copyWith(
                                                fontSize: 48,
                                                color: AppColors.white),
                                      )
                                    : const Offstage()),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _setUpProfileKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setupProfileScreenController.getImage();
                              },
                              child: Center(
                                child: Text('Add Profile Photo',
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
                                controller: setupProfileScreenController
                                    .firstNameTextEditingController,
                                hintText: "eg: John",
                                key: const Key('first name')),
                            const SizedBox(height: 24),
                            const FormFieldTitle(title: "Last Name*"),
                            const SizedBox(height: 9),
                            CustomTextField(
                                type: InputFieldTypes.lastNameWithClear,
                                controller: setupProfileScreenController
                                    .lastNameTextEditingController,
                                hintText: "eg: Doe",
                                key: const Key('last name')),
                            const SizedBox(height: 24),
                            const FormFieldTitle(title: "Date of Birth*"),
                            const SizedBox(height: 9),
                            CustomTextField(
                              type: InputFieldTypes.dob,
                              context: context,
                              controller: setupProfileScreenController
                                  .dateOfBirthTextEditingController,
                              hintText: "", //dd-mm-yyyy
                              key: const Key("dateOfBirth"),
                            ),
                            const SizedBox(height: 24),
                            const FormFieldTitle(title: "Gender*"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Obx(
                                    () => RadioListTile(
                                      title: Text("Male",
                                          style:
                                              defaultTheme.textTheme.bodyText1),
                                      activeColor: AppColors.orange,
                                      value: "Male",
                                      contentPadding: EdgeInsets.zero,
                                      groupValue: setupProfileScreenController
                                          .gender.value,
                                      onChanged: (value) {
                                        setupProfileScreenController
                                            .gender.value = value.toString();
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Obx(
                                    () => RadioListTile(
                                      title: Text("Female",
                                          style:
                                              defaultTheme.textTheme.bodyText1),
                                      activeColor: AppColors.orange,
                                      value: "Female",
                                      contentPadding: EdgeInsets.zero,
                                      groupValue: setupProfileScreenController
                                          .gender.value,
                                      onChanged: (value) {
                                        setupProfileScreenController
                                            .gender.value = value.toString();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            const FormFieldTitle(title: "Email*"),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Text(
                                      setupProfileScreenController.email.value,
                                      style: defaultTheme.textTheme.bodyText1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.validColor,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Text(
                                      '+' +
                                          setupProfileScreenController
                                              .countryCode.value +
                                          ' ' +
                                          setupProfileScreenController
                                              .mobileNumber.value,
                                      style: defaultTheme.textTheme.bodyText1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.validColor,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const FormFieldTitle(title: "Profile Message"),
                            const SizedBox(height: 9),
                            CustomTextField(
                                type: InputFieldTypes.textArea,
                                controller: setupProfileScreenController
                                    .profileMessageTextEditingController,
                                hintText: "",
                                key: const Key('Message')),
                            const SizedBox(height: 32),
                            ButtonTypeOne(
                              key: const Key("next"),
                              buttonStatus: ButtonStatus.enabled,
                              buttonText: "Next",
                              isGeneralButton: true,
                              onPressed: () {
                                if (_setUpProfileKey.currentState!.validate()) {
                                  Map<String, dynamic> body = SetupProfileScreenSendModel(
                                          firstName: setupProfileScreenController
                                              .firstNameTextEditingController
                                              .text,
                                          lastName: setupProfileScreenController
                                              .lastNameTextEditingController
                                              .text,
                                          dateOfBirth: setupProfileScreenController
                                              .dateOfBirthTextEditingController
                                              .text,
                                          gender: setupProfileScreenController
                                              .gender.value,
                                          profileMessage:
                                              setupProfileScreenController
                                                  .profileMessageTextEditingController
                                                  .text,
                                          email: setupProfileScreenController
                                              .email.value)
                                      .toJson();
                                  setupProfileScreenController
                                      .setupProfile(body);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              setupProfileScreenController.isLoading.value
                  ? const Loader()
                  : const Offstage()
            ],
          ),
        ),
      ),
    );
  }

  Widget countryPickerWidget() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: AppColors.black.withOpacity(0.08), width: 1)),
      child: CountryPickerDropdown(
        initialValue: "SG",
        onValuePicked: (Country value) {},
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 24),
        ),
        selectedItemBuilder: (country) {
          return Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 60),
                alignment: Alignment.center,
                child: Text(
                  '+${country.phoneCode}',
                  textAlign: TextAlign.center,
                  style: defaultTheme.textTheme.bodyText2!.copyWith(
                    color: AppColors.black.withOpacity(0.8),
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 1,
                color: AppColors.black.withOpacity(0.08),
              )
            ],
          );
        },
        sortComparator: (Country a, Country b) =>
            a.isoCode.compareTo(b.isoCode),
        itemBuilder: (country) {
          return Align(
            alignment: Alignment.center,
            child: Text(
              '+${country.phoneCode} (${country.isoCode})',
              textAlign: TextAlign.center,
              style: defaultTheme.textTheme.bodyText2!.copyWith(
                color: AppColors.black.withOpacity(0.6),
              ),
            ),
          );
        },
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
