import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/toast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  final controller = GetControllers.shared.getTwoFactorController();

  @override
  void initState() {
    controller.useAuthenticatorApp();
    super.initState();
  }

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
              height: 80,
            ),
            Text(
              'Two Factor Authentication',
              style: defaultTheme.textTheme.headline2,
            ),
            const SizedBox(height: 12),
            Text(
              'Download the Authentication App (Google Authenticator) to scan this QR Code or enter the code manually into your app.',
              style: defaultTheme.textTheme.bodyText1?.copyWith(
                  color: AppColors.black.withOpacity(0.6),
                  overflow: TextOverflow.visible),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.height * 0.2,
                child: Obx(
                  () => controller.twoFactorEnableResponseModel.value.secret !=
                          null
                      ? QrImage(
                          data: controller
                              .twoFactorEnableResponseModel.value.otpauthUrl!,
                          version: QrVersions.auto,
                          size: 200.0,
                        )
                      : Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/QR_with_URL_to_article_about_QR-code_%28Swedish%29.svg/333px-QR_with_URL_to_article_about_QR-code_%28Swedish%29.svg.png?20141014230826'),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text(
              'OR',
              style: defaultTheme.textTheme.subtitle1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text(
              'Enter this code into your Authentication App',
              style: defaultTheme.textTheme.bodyText1?.copyWith(
                  color: AppColors.black.withOpacity(0.6),
                  overflow: TextOverflow.visible),
            ),
            const SizedBox(height: 12),
            Obx(
              () => controller.twoFactorEnableResponseModel.value.secret == null
                  ? const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.twoFactorEnableResponseModel.value.secret!,
                          style: defaultTheme.textTheme.subtitle2,
                        ),
                        InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              FlutterClipboard.copy(controller
                                      .twoFactorEnableResponseModel
                                      .value
                                      .secret!)
                                  .then((value) => showSuccessToast("Copied"));
                            },
                            child: const Icon(
                              Icons.copy,
                              size: 18,
                            ))
                      ],
                    ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ButtonTypeOne(
              buttonText: 'Use Authenticator App',
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.launchAuthenticatorApp();
              },
            )
          ],
        ),
      )),
    );
  }
}
