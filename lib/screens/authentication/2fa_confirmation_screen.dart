import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';

class TwoFactorConfirmationScreen extends StatefulWidget {
  const TwoFactorConfirmationScreen({super.key});

  @override
  State<TwoFactorConfirmationScreen> createState() =>
      _TwoFactorConfirmationScreenState();
}

class _TwoFactorConfirmationScreenState
    extends State<TwoFactorConfirmationScreen> {
  final controller = GetControllers.shared.getTwoFactorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              height: 20,
            ),
            Text(
              'Enter Confirmation Code',
              style: defaultTheme.textTheme.headline2,
            ),
            const SizedBox(height: 12),
            Text(
              'Enter the confirmation code that you see on the Authentication App.',
              style: defaultTheme.textTheme.bodyText1?.copyWith(
                  color: AppColors.black.withOpacity(0.6),
                  overflow: TextOverflow.visible),
            ),
            const SizedBox(height: 32),
            CustomTextField(
                type: InputFieldTypes.otp,
                controller: controller.otpController,
                key: const Key('2faCode')),
            const SizedBox(height: 32),
            Obx(() => ButtonTypeOne(
                  isGeneralButton: false,
                  buttonStatus: controller.buttonStatus.value,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    controller.verifyCode();
                  },
                  enabledButtonText: 'Verify',
                  disabledButtonText: 'Verify',
                  errorButtonText: 'Verification failed',
                  verifiedButtonText: 'Verified',
                  verifyingButtonText: 'Verifying',
                ))
          ],
        ),
      )),
    );
  }
}
