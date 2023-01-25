import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/confirm_mobile_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/send_models/verify_change_mobile_send_model.dart';
import 'package:pumpkin/models/send_models/verify_mobile_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';

class ConfirmMobileScreen extends StatefulWidget {
  const ConfirmMobileScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmMobileScreen> createState() => _ConfirmMobileScreenState();
}

class _ConfirmMobileScreenState extends State<ConfirmMobileScreen> {
  ConfirmMobileScreenController confirmMobileScreenController =
      GetControllers.shared.getConfirmMobileScreenController();

  @override
  void initState() {
    //setArguments();
    super.initState();
  }

  setArguments(){
    confirmMobileScreenController.isMobileNumberChange.value = Get.arguments.length == 5
        ? Get.arguments[4]
        : false; //Getting isMobileNumberChange as argument from my profile screen
    confirmMobileScreenController.countryCodeLabel.value = Get.arguments[
    3]; //Getting the country code label as argument from previous screen
    confirmMobileScreenController.mobileNumber.value = Get.arguments[
    2]; //Getting the mobile number as argument from previous screen
    confirmMobileScreenController.countryCode.value = Get.arguments[
    1]; //Getting the country code as argument from previous screen
    confirmMobileScreenController.email.value =
    Get.arguments[0]; //Getting the email as argument from previous screen
    confirmMobileScreenController.source = Get.arguments[
    4]; //Getting the source, we are checking if it's from social auth, because if it is then, we don't show the set password screen
  }

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
              Text('Confirm your Mobile Number',
                  style: defaultTheme.textTheme.headline3),
              const SizedBox(height: 12),
              Wrap(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => RichText(
                        text: TextSpan(
                            text: 'Please enter the OTP sent to ',
                            style: defaultTheme.textTheme.bodyText1?.copyWith(
                              color: AppColors.black.withOpacity(0.6),
                            ),
                            children: [
                              TextSpan(
                                text: '+' +
                                    confirmMobileScreenController
                                        .countryCode.value +
                                    ' ' +
                                    confirmMobileScreenController
                                        .mobileNumber.value,
                                style:
                                    defaultTheme.textTheme.bodyText1?.copyWith(
                                  color: AppColors.orange,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Get.back();
                      },
                      child: Image.asset(editIcon, height: 24, width: 24)),
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
                        text: 'Didn’t receive OTP?  ',
                        style: defaultTheme.textTheme.subtitle2,
                        children: [
                          TextSpan(
                            text: 'Resend',
                            style: defaultTheme.textTheme.subtitle2?.copyWith(
                              color: confirmMobileScreenController
                                      .resendLoading.value
                                  ? AppColors.otpBG
                                  : AppColors.orange,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                HapticFeedback.lightImpact();
                                confirmMobileScreenController
                                    .resendMobileVerificationCode();
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
                  buttonStatus:
                      confirmMobileScreenController.buttonStatus.value,
                  isGeneralButton: false,
                  onPressed: () {
                    HapticFeedback.lightImpact();

                    //body for register mobile verify
                    Map<String, dynamic> body = VerifyMobileSendModel(
                            verificationCode: confirmMobileScreenController
                                .otpTextEditingController.text,
                            countryCode:
                                confirmMobileScreenController.countryCode.value,
                            countryCodeLabel: confirmMobileScreenController
                                .countryCodeLabel.value,
                            mobileNumber: confirmMobileScreenController
                                .mobileNumber.value,
                            email: confirmMobileScreenController.email.value)
                        .toJson();

                    //body for change mobile number verify
                    Map<String, dynamic> changeMobileBody = VerifyChangeMobileSendModel(
                        verificationCode: confirmMobileScreenController
                            .otpTextEditingController.text,
                        countryCode:
                        confirmMobileScreenController.countryCode.value,
                        countryCodeLabel: confirmMobileScreenController
                            .countryCodeLabel.value,
                        mobileNumber: confirmMobileScreenController
                            .mobileNumber.value)
                        .toJson();

                    //for change mobile number verify
                    if (confirmMobileScreenController
                        .isMobileNumberChange.value) {
                      confirmMobileScreenController
                          .verifyChangeMobileNumber(changeMobileBody);
                    } else {
                      //for register mobile verify
                      confirmMobileScreenController.verifyMobile(body);
                    }
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
      type: InputFieldTypes.otp,
      maxLength: 6,
      controller: confirmMobileScreenController.otpTextEditingController,
      key: const Key("otp"),
    );
  }
}
