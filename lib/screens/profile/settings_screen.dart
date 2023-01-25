import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/profile/settings_screen_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/dialog/popupAlertDialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GetStorage temInstance = GetStorage();
  SettingsScreenController settingsScreenController =
      GetControllers.shared.getSettingsScreenController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
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
                      Text('Settings', style: defaultTheme.textTheme.headline3),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                optionWidget("Contact Us", "assets/icons/contact.svg"),
                optionWidget("Log Out", "assets/icons/logout.svg"),
                optionWidget(
                    "Delete Account", "assets/icons/delete_account.svg"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
            case "Contact Us":
              showGeneralDialogue(
                  context: context,
                  body: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: defaultTheme.textTheme.bodyText1!
                                      .copyWith(color: AppColors.primaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                splashScreenPumpkin,
                                scale: 5,
                              ),
                              Text(
                                'pumpkin',
                                style: defaultTheme.textTheme.headline1!
                                    .copyWith(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Version: 0.1.0 (17)',
                                style: defaultTheme.textTheme.bodyText2,
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.iconBG.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                titleValueRow(
                                    'Company Name:',
                                    settingsScreenController
                                            .companyDetailsResponseModel
                                            .companyName ??
                                        ''),
                                titleValueRow(
                                    'Contact Number:',
                                    '+${settingsScreenController.companyDetailsResponseModel.countryCode ?? ''} '
                                        '${settingsScreenController.companyDetailsResponseModel.phone ?? ''}'),
                                titleValueRow(
                                    'Company Email:',
                                    settingsScreenController
                                        .companyDetailsResponseModel
                                        .companyEmail!),
                                titleValueRow(
                                    'Company Address:',
                                    settingsScreenController
                                        .companyDetailsResponseModel
                                        .companyAddress!),
                                titleValueRow(
                                    'Website',
                                    settingsScreenController
                                        .companyDetailsResponseModel.website!),
                                titleValueRow('', 'Privacy Policy',
                                    isLink: true,
                                    link: settingsScreenController
                                        .companyDetailsResponseModel.policy),
                                titleValueRow('', 'Terms and Conditions',
                                    isLink: true,
                                    link: settingsScreenController
                                        .companyDetailsResponseModel.terms),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
              break;
            case "Log Out":
              showPopupAlertConfirmDialog(
                  "Log Out",
                  "Are you sure you want to Log out?",
                  "Log Out",
                  "Cancel", rightButtonTap: () {
                HapticFeedback.lightImpact();
                Get.back();
                temInstance.remove(StorageKeys.accessToken);
                Get.offAllNamed(loginScreen);
              });
              break;
            case "Delete Account":
              showPopupAlertConfirmDialog(
                  "Delete Account",
                  "Are you sure you want to delete your account?",
                  "Delete",
                  "Cancel", rightButtonTap: () {
                HapticFeedback.lightImpact();
                Get.back();
              }, height: 131);
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
            )
          ],
        ),
      ),
    );
  }

  Widget titleValueRow(String titile, String value,
      {bool isLink = false, String? link}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              titile,
              style: defaultTheme.textTheme.bodyText2!.copyWith(
                  color: AppColors.iconBG, overflow: TextOverflow.visible),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.09,
        ),
        Expanded(
          flex: 7,
          child: isLink
              ? InkWell(
                  onTap: () {
                    // TODO: Navigate to url
                  },
                  child: Text(
                    value,
                    style: defaultTheme.textTheme.bodyText1!.copyWith(
                        overflow: TextOverflow.visible,
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              : Text(
                  value,
                  style: defaultTheme.textTheme.bodyText1!
                      .copyWith(overflow: TextOverflow.visible),
                ),
        ),
      ],
    );
  }
}
