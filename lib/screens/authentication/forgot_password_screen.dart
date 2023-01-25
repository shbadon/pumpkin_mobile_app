import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/forgot_password_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  ForgotPasswordScreenController forgotPasswordScreenController =
      GetControllers.shared.getForgotpasswordScreenController();
  @override
  Widget build(BuildContext context) {
    final _emailFormKey = GlobalKey<FormState>();
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: Container(
                // margin:
                //     EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _emailFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (() {
                              HapticFeedback.lightImpact();
                              Get.back();
                            }),
                            icon: Icon(
                              Icons.close,
                              color: defaultTheme.iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Forgot Password',
                        style: defaultTheme.textTheme.headline2,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your registered email address below to receive reset instructions.',
                        style: defaultTheme.textTheme.bodyText1?.copyWith(
                            color: AppColors.black.withOpacity(0.6),
                            overflow: TextOverflow.visible),
                      ),
                      const SizedBox(height: 32),
                      const FormFieldTitle(title: "Email"),
                      const SizedBox(height: 9),
                      CustomTextField(
                          type: InputFieldTypes.emailWithClear,
                          controller: forgotPasswordScreenController
                              .emailTextEditingController,
                          hintText: "eg: johndoe@mail.com",
                          key: const Key('email')),
                      const SizedBox(height: 32),
                      ButtonTypeOne(
                        key: const Key("confirm"),
                        buttonText: 'Continue',
                        onPressed: () {
                          if (_emailFormKey.currentState!.validate()) {
                            // If the form is valid, then send value to server and move to next screen
                            forgotPasswordScreenController.getOtpForEmail(
                                email: forgotPasswordScreenController
                                    .emailTextEditingController.text);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            forgotPasswordScreenController.isLoading.value
                ? const Loader()
                : const Offstage()
          ],
        ),
      ),
    );
  }
}
