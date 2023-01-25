import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalkthroughScreen extends StatelessWidget {
  const WalkthroughScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
        .dark); //This makes the status bar text color change
    PageController pageController = PageController();
    return Scaffold(
      backgroundColor: AppColors.splashScaffoldColor,
      body: SafeArea(
          child: Stack(
        children: [
          PageView(
            controller: pageController,
            children: const [
              SeedPage(),
              SaplingPage(),
              FlowerPage(),
              SingleChildScrollView(child: PumpkinScreen())
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 4,
                effect: const WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    type: WormType.thin,
                    activeDotColor: AppColors.primaryColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.offAndToNamed(signupScreen);
                },
                child: Text(
                  'Skip',
                  style: defaultTheme.textTheme.bodyText1,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class SeedPage extends StatelessWidget {
  const SeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.center, child: Image.asset(seed)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Text(
                  'Seed',
                  style:
                      defaultTheme.textTheme.headline1!.copyWith(fontSize: 36),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Manage the leads,\nand let it grow! ',
                style: defaultTheme.textTheme.subtitle2!.copyWith(fontSize: 20),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SaplingPage extends StatelessWidget {
  const SaplingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.center, child: Image.asset(sapling)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Text(
                  'Sapling',
                  style: defaultTheme.textTheme.headline1!
                      .copyWith(fontSize: 36, color: AppColors.validColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Make efforts and let them\nknow 0 to 1 about your services!',
                style: defaultTheme.textTheme.subtitle2!
                    .copyWith(fontSize: 20, overflow: TextOverflow.visible),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class FlowerPage extends StatelessWidget {
  const FlowerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.center, child: Image.asset(flower)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Text(
                  'Flower',
                  style: defaultTheme.textTheme.headline1!
                      .copyWith(fontSize: 36, color: AppColors.secondaryColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Here, they are 80% sure.\nHelp them go to 100% by\nbacking up with trust! ',
                style: defaultTheme.textTheme.subtitle2!.copyWith(fontSize: 20),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PumpkinScreen extends StatelessWidget {
  const PumpkinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.topCenter, child: Image.asset(confetti)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(alignment: Alignment.center, child: Image.asset(pumpkin)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ButtonTypeOne(
                  buttonText: 'Get Started',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Get.offAndToNamed(signupScreen);
                  },
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Text(
                  'Pumpkin',
                  style: defaultTheme.textTheme.headline1!
                      .copyWith(fontSize: 36, color: AppColors.primaryColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'All yours now!\nNurture and pamper them!',
                style: defaultTheme.textTheme.subtitle2!.copyWith(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
