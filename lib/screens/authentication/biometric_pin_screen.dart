import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/auntentication/biometric_pin_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';

// ignore: must_be_immutable
class BiometricPinScreen extends StatelessWidget {
  BiometricPinScreen({super.key});

  BiometricPinScreenController controller =
      GetControllers.shared.getBiometricPinScreenController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.back(result: 'keepDisabled');
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.darkIconcolor,
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Setup a PIN', style: defaultTheme.textTheme.headline3),
              const SizedBox(height: 12),
              Text('To enable or disable Face ID/ Touch ID setup PIN',
                  style: defaultTheme.textTheme.bodyText1),
              const SizedBox(height: 32),
              CustomTextField(
                maxLength: 4,
                type: InputFieldTypes.otp,
                controller: controller.pinTextEditingController,
                key: const Key("pin"),
              ),
              const SizedBox(height: 32),
              Obx(
                () => ButtonTypeOne(
                  key: const Key("setPin"),
                  buttonStatus: controller.buttonStatus.value,
                  isGeneralButton: false,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    controller.setPin();
                  },
                  enabledButtonText: 'Confirm',
                  disabledButtonText: 'Confirm',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
