import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/biometric_pin_screen_controller.dart';
import 'package:pumpkin/controllers/device_id_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/loader.dart';

// ignore: must_be_immutable
class BiometricPinConfirmScreen extends StatelessWidget {
  BiometricPinConfirmScreen({super.key});

  BiometricPinScreenController controller =
      GetControllers.shared.getBiometricPinScreenController();
  DeviceIDController deviceIDController =
      GetControllers.shared.getDeviceIdController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Text('Confirm PIN',
                        style: defaultTheme.textTheme.headline3),
                    const SizedBox(height: 32),
                    CustomTextField(
                      maxLength: 4,
                      type: InputFieldTypes.otp,
                      controller: controller.pinConfirmTextEditingController,
                      key: const Key("pin"),
                    ),
                    const SizedBox(height: 8),
                    !controller.needToEnableInDeviceAuth.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    controller.sendEmail();
                                  },
                                  child: Text(
                                    'Forgot PIN',
                                    style: defaultTheme.textTheme.bodyText1!
                                        .copyWith(
                                            color: AppColors.primaryColor,
                                            decoration:
                                                TextDecoration.underline),
                                  )),
                            ],
                          )
                        : const Offstage(),
                    const SizedBox(height: 20),
                    Obx(
                      () => ButtonTypeOne(
                        key: const Key("setPin"),
                        buttonStatus: controller.confirmbuttonStatus.value,
                        isGeneralButton: false,
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          Map<String, dynamic> body = {
                            "device_id": await deviceIDController.getId(),
                            "digital_token_pin":
                                controller.pinConfirmTextEditingController.text
                          };
                          controller.confirmPin(body);
                        },
                        enabledButtonText: 'Confirm',
                        disabledButtonText: 'Confirm',
                        errorButtonText: 'Error',
                        verifiedButtonText: 'PIN confirmed',
                        verifyingButtonText: 'Confirming',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() =>
              controller.isLoading.value ? const Loader() : const Offstage()),
        ],
      ),
    );
  }
}
