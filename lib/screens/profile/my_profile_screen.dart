import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/profile/my_profile_screen_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/loader.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final controller = GetControllers.shared.getTwoFactorController();
  MyProfileScreenController myProfileScreenController =
      GetControllers.shared.getMyProfileScreenController();

  @override
  void initState() {
    myProfileScreenController.getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Obx(
            () => myProfileScreenController
                        .agentDetailsResponseModel.value.firstName !=
                    null
                ? SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 210,
                            child: Stack(
                              children: [
                                Image.asset(
                                  "assets/images/profile-bg.png",
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  height: 160,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .5,
                                  width: MediaQuery.of(context).size.width,
                                  // color: AppColors.setupProfileBG,
                                  padding:
                                      const EdgeInsets.only(top: 50, left: 24),
                                  child: Text('Profile',
                                      style: defaultTheme.textTheme.headline3),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: AppColors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: myProfileScreenController
                                                  .agentDetailsResponseModel
                                                  .value
                                                  .photo ==
                                              null
                                          ? CircleAvatar(
                                              radius: 53,
                                              backgroundColor: AppColors.green,
                                              //backgroundImage: const AssetImage("assets/images/avater.jpeg"),
                                              child: Text(
                                                myProfileScreenController
                                                    .agentDetailsResponseModel
                                                    .value
                                                    .firstName!
                                                    .split('')
                                                    .first,
                                                style: defaultTheme
                                                    .textTheme.headline1!
                                                    .copyWith(
                                                        fontSize: 48,
                                                        color: AppColors.white),
                                              ))
                                          : CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundImage: NetworkImage(
                                                  myProfileScreenController
                                                      .agentDetailsResponseModel
                                                      .value
                                                      .photo
                                                      .toString()),
                                              radius: 53,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                optionWidget(
                                    "My Account", "assets/icons/men.svg"),
                                optionWidget(
                                    "My Points", "assets/icons/points.svg"),
                                myProfileScreenController
                                            .agentDetailsResponseModel
                                            .value
                                            .registerType ==
                                        'manual'
                                    ? optionWidget("Change Password",
                                        "assets/icons/password.svg")
                                    : const Offstage(),
                                optionWidget("Connected Accounts",
                                    "assets/icons/accounts.svg"),
                                switchWidget(
                                    "Face ID / Touch ID",
                                    "assets/icons/face-id.svg",
                                    myProfileScreenController.isFaceIDEnabled),
                                switchWidget(
                                    "Two-Factor Authentication",
                                    "assets/icons/two-factor.svg",
                                    myProfileScreenController
                                        .isTwoFactorEnabled),
                                optionWidget(
                                    "Settings", "assets/icons/setting.svg"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(), //TODO: Show some good UI
          ),
          Obx(
            () => myProfileScreenController.isLoading.value
                ? const Loader()
                : const Offstage(),
          )
        ],
      ),
    );
  }

  Widget optionWidget(title, icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          switch (title) {
            case "My Account":
              Get.toNamed(myAccountScreen, arguments: [
                myProfileScreenController.agentDetailsResponseModel.value
              ])!
                  .then(
                      (value) => myProfileScreenController.getProfileDetails());
              break;
            case "Settings":
              Get.toNamed(settingsScreen, arguments: [
                myProfileScreenController.companyDetailsResponseModel
              ])!
                  .then(
                      (value) => myProfileScreenController.getProfileDetails());
              break;
            case "Connected Accounts":
              Get.toNamed(connectedScreen, arguments: [
                myProfileScreenController.agentDetailsResponseModel.value
              ])!
                  .then(
                      (value) => myProfileScreenController.getProfileDetails());
              break;
            case "Change Password":
              Get.toNamed(changePasswordScreen)!.then(
                  (value) => myProfileScreenController.getProfileDetails());
              break;
            case "My Points":
              Get.toNamed(myPointsScreen);
              break;
          }
        },
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
            const Icon(
              Icons.arrow_forward_ios_sharp,
              color: AppColors.iconBG,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget switchWidget(title, icon, RxBool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
        },
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
            Obx(() => CupertinoSwitch(
                activeColor: AppColors.validColor,
                value: isEnabled.value,
                onChanged: (value) {
                  isEnabled.value = value;
                  if (title == "Face ID / Touch ID") {
                    // Map<String, dynamic> body = {
                    //   'isDeviceAuthenticationEnabled': value
                    // };
                    if (!value) {
                      Get.toNamed(biometricPinConfirmScreen,
                              arguments: ['disableInDeviceAuth'])!
                          .then((value) =>
                              myProfileScreenController.getProfileDetails());
                    } else {
                      Get.toNamed(biometricPinScreen,
                              arguments: ['enableInDeviceAuth'])!
                          .then((value) {
                        if (value == 'keepDisabled') {
                          myProfileScreenController.isFaceIDEnabled.value =
                              false;
                        }
                      });
                    }
                  } else {
                    if (value) {
                      Get.toNamed(twofactorCodeScreen)!.then((value) =>
                          myProfileScreenController.getProfileDetails());
                    } else {
                      // Disable the TwoFA
                      myProfileScreenController.disAble2fa();
                    }
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget countryPickerWidget() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: AppColors.black.withOpacity(0.08), width: 1)),
      child: CountryPickerDropdown(
        initialValue: "SG",
        onValuePicked: (Country value) {},
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 24),
        ),
        selectedItemBuilder: (country) {
          return Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 60),
                alignment: Alignment.center,
                child: Text(
                  '+${country.phoneCode}',
                  textAlign: TextAlign.center,
                  style: defaultTheme.textTheme.bodyText2!.copyWith(
                    color: AppColors.black.withOpacity(0.8),
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 1,
                color: AppColors.black.withOpacity(0.08),
              )
            ],
          );
        },
        sortComparator: (Country a, Country b) =>
            a.isoCode.compareTo(b.isoCode),
        itemBuilder: (country) {
          return Align(
            alignment: Alignment.center,
            child: Text(
              '+${country.phoneCode} (${country.isoCode})',
              textAlign: TextAlign.center,
              style: defaultTheme.textTheme.bodyText2!.copyWith(
                color: AppColors.black.withOpacity(0.6),
              ),
            ),
          );
        },
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
