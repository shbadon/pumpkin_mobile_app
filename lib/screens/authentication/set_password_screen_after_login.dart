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
import 'package:pumpkin/widgets/loader.dart';

class SetPasswordScreenAfterLogin extends StatefulWidget {
  const SetPasswordScreenAfterLogin({Key? key}) : super(key: key);

  @override
  State<SetPasswordScreenAfterLogin> createState() =>
      _SetPasswordScreenAfterLoginState();
}

class _SetPasswordScreenAfterLoginState
    extends State<SetPasswordScreenAfterLogin> {
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
                        buttonStatus: ButtonStatus.enabled,
                        isGeneralButton: true,
                        buttonText: "Continue",
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
                            setPasswordScreenController.setPasswordAfterLogin(
                                body: body);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            setPasswordScreenController.isLoading.value
                ? const Loader()
                : const Offstage()
          ],
        ),
      ),
    );
  }
}
