import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/biometric_pin_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';

class ConfirmEmailScreenForPinReset extends StatefulWidget {
  const ConfirmEmailScreenForPinReset({Key? key}) : super(key: key);

  @override
  State<ConfirmEmailScreenForPinReset> createState() =>
      _ConfirmEmailScreenForPinResetState();
}

class _ConfirmEmailScreenForPinResetState
    extends State<ConfirmEmailScreenForPinReset> {
  BiometricPinScreenController biometricPinScreenController =
      GetControllers.shared.getBiometricPinScreenController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text('Confirm your Email Address',
                  style: defaultTheme.textTheme.headline3),
              const SizedBox(height: 12),
              Wrap(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text:
                            'Please enter the OTP sent to your registered email',
                        style: defaultTheme.textTheme.bodyText1?.copyWith(
                          color: AppColors.black.withOpacity(0.6),
                        ),
                        // children: [
                        // TextSpan(
                        //   text: confirmEmailScreenController.email.value,
                        //   style:
                        //       defaultTheme.textTheme.bodyText1?.copyWith(
                        //     color: AppColors.orange,
                        //   ),
                        // ),
                        // ]
                      ),
                    ),
                  ),
                  // InkWell(
                  //     onTap: () {
                  //       HapticFeedback.lightImpact();
                  //       Get.back();
                  //     },
                  //     child: Image.asset(editIcon, height: 24, width: 24)),
                ],
              ),
              const SizedBox(height: 32),
              textFieldWidget(),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Obx(
                  () => RichText(
                    text: TextSpan(
                        text: "Didn’t receive OTP?  ",
                        style: defaultTheme.textTheme.subtitle2,
                        children: [
                          TextSpan(
                            text: 'Resend',
                            style: defaultTheme.textTheme.subtitle2?.copyWith(
                              color: biometricPinScreenController
                                      .resendLoading.value
                                  ? AppColors.otpBG
                                  : AppColors.orange,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                HapticFeedback.lightImpact();
                                biometricPinScreenController.resendEmail();
                              },
                          ),
                        ]),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => ButtonTypeOne(
                  key: const Key("verify"),
                  buttonStatus: biometricPinScreenController
                      .confirmEmailbuttonStatus.value,
                  isGeneralButton: false,
                  onPressed: () {
                    biometricPinScreenController.verifyEmail();
                  },
                  enabledButtonText: 'Verify',
                  disabledButtonText: 'Verify',
                  errorButtonText: 'Verification failed',
                  verifyingButtonText: 'Verifying',
                  verifiedButtonText: 'Verified',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //otp field segment
  Widget textFieldWidget() {
    return CustomTextField(
      maxLength: 6,
      type: InputFieldTypes.otp,
      controller: biometricPinScreenController.otpTextEditingController,
      key: const Key("otp"),
    );
  }
}
