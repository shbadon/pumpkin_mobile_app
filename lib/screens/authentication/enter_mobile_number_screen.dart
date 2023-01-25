import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pumpkin/controllers/auntentication/enter_mobile_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/models/send_models/enter_mobile_screen_send_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/country_picker.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

class EnterMobileNumberScreen extends StatefulWidget {
  const EnterMobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<EnterMobileNumberScreen> createState() =>
      _EnterMobileNumberScreenState();
}

class _EnterMobileNumberScreenState extends State<EnterMobileNumberScreen> {
  EnterMobileScreenController enterMobileScreenController =
      GetControllers.shared.getEmterMobileScreenController();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text('Finish Signing Up',
                        style: defaultTheme.textTheme.headline3),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your Mobile Number to receive OTP.',
                      style: defaultTheme.textTheme.bodyText1
                          ?.copyWith(color: AppColors.black.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountryPicker(
                          onCountryCodeSelected: (value) {
                            enterMobileScreenController.countryCode = value;
                          },
                          onCountryLabelSelected: (value) {
                            enterMobileScreenController.countryCodeLabel =
                                value;

                            debugPrint("countryLabel:: " +
                                enterMobileScreenController.countryCodeLabel
                                    .toString());
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: CustomTextField(
                                type: InputFieldTypes.numberWithClear,
                                controller: enterMobileScreenController
                                    .mobilenumberTextEditingController,
                                hintText: "eg: 6784883897",
                                key: const Key('phone'))),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Obx(
                      () => ButtonTypeOne(
                        key: const Key("verify"),
                        buttonStatus:
                            enterMobileScreenController.buttonStatus.value,
                        isGeneralButton: false,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Map<String, dynamic> body =
                              EnterMobileScreenSendModel(
                                      contryCode: enterMobileScreenController
                                          .countryCode
                                          .toString(),
                                      countryLabel: enterMobileScreenController
                                          .countryCodeLabel
                                          .toString(),
                                      mobile: enterMobileScreenController
                                          .mobilenumberTextEditingController
                                          .text)
                                  .toJson();
                          enterMobileScreenController.sendOtptoMobile(body);
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
            enterMobileScreenController.isLoading.value
                ? const Loader()
                : const Offstage()
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
