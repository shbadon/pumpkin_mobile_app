import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/splash_screen_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/strings.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  SplashScreenController splashScreenController =
      GetControllers.shared.getSplashScreenController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
        .light); //This makes the status bar text color change
    return Scaffold(
      backgroundColor: AppColors.fourthColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              splashScreenPumpkin,
              scale: 5,
            ),
            AnimatedTextKit(
                onFinished: () {
                  splashScreenController.checIfNewUserOrExistingUser();
                },
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText('pumpkin',
                      speed: const Duration(milliseconds: 250),
                      textStyle: defaultTheme.textTheme.headline1!
                          .copyWith(color: Colors.white))
                ]),
          ],
        ),
      ),
    );
  }
}
