import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/send_models/chnage_password_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final changePasswordScreenController =
      GetControllers.shared.getChangePasswordScreenController();
  final _setPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(
        () => SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _setPasswordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Get.back();
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.black,
                                size: 18,
                              ),
                              Text('Change Password',
                                  style: defaultTheme.textTheme.headline3),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const FormFieldTitle(title: "Old Password"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.passWord,
                            controller: changePasswordScreenController
                                .oldPasswordTextEditingController,
                            hintText: 'Enter your old password',
                            key: const Key('password')),
                        const SizedBox(height: 9),
                        Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Get.toNamed(forgotPasswordScreenAfterLogin);
                                },
                                child: Text(
                                  "Forgot Password",
                                  style: defaultTheme.textTheme.headline5!
                                      .copyWith(color: AppColors.orange),
                                ))),
                        const SizedBox(height: 25),
                        const FormFieldTitle(title: "New Password"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.passWord,
                            controller: changePasswordScreenController
                                .newPasswordTextEditingController,
                            hintText: 'Enter your new password',
                            key: const Key('newPassword')),
                        const SizedBox(height: 25),
                        const FormFieldTitle(title: "Confirm New Password"),
                        const SizedBox(height: 9),
                        CustomTextField(
                            type: InputFieldTypes.passWord,
                            controller: changePasswordScreenController
                                .confirmPasswordTextEditingController,
                            // Setting the confirm password textfield validator seperately as we need to access the passwordTextField controller to match the password
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLabels.passwordRequired;
                              } else if (changePasswordScreenController
                                      .newPasswordTextEditingController.text !=
                                  value) {
                                return AppLabels.passwordDontMatch;
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Enter confirm password',
                            key: const Key('confirmPassword')),
                        const SizedBox(height: 32),
                        ButtonTypeOne(
                          key: const Key("verify"),
                          buttonStatus:
                              changePasswordScreenController.buttonStatus.value,
                          isGeneralButton: false,
                          verifiedButtonText: 'Password changed successfully',
                          enabledButtonText: 'Save',
                          disabledButtonText: 'Save',
                          errorButtonText: 'Failed to save',
                          verifyingButtonText: 'Saving password',
                          buttonText: "Save",
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            if (_setPasswordFormKey.currentState!.validate()) {
                              Map<String, dynamic> body =
                                  ChangePasswordSendModel(
                                confirmPassword: changePasswordScreenController
                                    .confirmPasswordTextEditingController.text,
                                oldPassword: changePasswordScreenController
                                    .oldPasswordTextEditingController.text,
                                newPassword: changePasswordScreenController
                                    .newPasswordTextEditingController.text,
                              ).toJson();
                              changePasswordScreenController
                                  .changePassword(body);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              changePasswordScreenController.isLoading.value
                  ? const Loader()
                  : const Offstage()
            ],
          ),
        ),
      ),
    );
  }
}
