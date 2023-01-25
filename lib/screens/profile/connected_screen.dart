import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/widgets/loader.dart';

class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({Key? key}) : super(key: key);

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  final controller =
      GetControllers.shared.getConnectedAccountScreenController();

  @override
  Widget build(BuildContext context) {
    debugPrint(controller.agentDetailsResponseModel.registerType);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          Text('Connected Accounts',
                              style: defaultTheme.textTheme.headline3),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    switchWidget("Connect Google", "assets/icons/google.svg",
                        controller.isGoogleConnected),
                    switchWidget(
                        "Connect Facebook",
                        "assets/icons/facebook.svg",
                        controller.isFacebookConnected),
                    switchWidget("Connect Apple", "assets/icons/apple.svg",
                        controller.isAppleConnected),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Obx(() =>
              controller.isLoading.value ? const Loader() : const Offstage())
        ],
      ),
    );
  }

  Widget switchWidget(title, icon, RxBool isEnable) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.profileIconBG,
              //backgroundImage: const AssetImage("assets/images/avater.jpeg"),
              child: SvgPicture.asset(
                icon,
              )),
          const SizedBox(
            width: 15,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: defaultTheme.textTheme.headline4!.copyWith(
              color: AppColors.black.withOpacity(0.8),
            ),
          ),
          const Spacer(),
          Obx(() => Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                    activeColor: AppColors.validColor,
                    value: isEnable.value,
                    onChanged: (value) {
                      //isEnable.value = value;
                      if (value) {
                        switch (title) {
                          case "Connect Google":
                            controller.connectGoogle();
                            break;
                          case "Connect Facebook":
                            controller.connectFacebook();
                            break;
                          case "Connect Apple":
                            controller.connectApple();
                            break;
                        }
                      }
                    }),
              )),
        ],
      ),
    );
  }
}
