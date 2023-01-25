import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/set_password_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/send_models/set_password_screen_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  SetPasswordScreenController setPasswordScreenController =
      GetControllers.shared.getSetPasswordScreenController();
  final _setPasswordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _setPasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text('Setup New Password',
                          style: defaultTheme.textTheme.headline3),
                      const SizedBox(height: 32),
                      const FormFieldTitle(title: "Password"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.passWord,
                          controller: setPasswordScreenController
                              .passwordTextEditingController,
                          hintText: 'Enter password',
                          key: const Key('password')),
                      const SizedBox(height: 25),
                      const FormFieldTitle(title: "Confirm Password"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.confirmPassWord,
                          controller: setPasswordScreenController
                              .confirmPasswordTextEditingController,
                          // Setting the confirm password textfield validator seperately as we need to access the passwordTextField controller to match the password
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLabels.passwordRequired;
                            } else if (setPasswordScreenController
                                    .passwordTextEditingController.text !=
                                value) {
                              return AppLabels.passwordDontMatch;
                            } else {
                              return null;
                            }
                          },
                          hintText: 'Enter password',
                          key: const Key('confirmPassword')),
                      const SizedBox(height: 32),
                      ButtonTypeOne(
                        key: const Key("verify"),
                        buttonStatus:
                            setPasswordScreenController.buttonStatus.value,
                        isGeneralButton: false,
                        buttonText: "Submit",
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          if (_setPasswordFormKey.currentState!.validate()) {
                            Map<String,
                                dynamic> body = SetPasswordScreenSendModel(
                                    email: setPasswordScreenController.email,
                                    newPassword: setPasswordScreenController
                                        .passwordTextEditingController.text,
                                    confirmPassword: setPasswordScreenController
                                        .confirmPasswordTextEditingController
                                        .text)
                                .toJson();
                            setPasswordScreenController.setNewPassword(body);
                          }
                        },
                        enabledButtonText: 'Submit',
                        disabledButtonText: 'Submit',
                        errorButtonText: 'Failed to submit',
                        verifyingButtonText: 'Submitting',
                        verifiedButtonText: 'Password changed  successfully',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // setPasswordScreenController.isLoading.value
            //     ? const Loader()
            //     : const Offstage()
          ],
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
