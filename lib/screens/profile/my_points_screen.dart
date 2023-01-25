import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class MyPointsScreen extends StatefulWidget {
  const MyPointsScreen({Key? key}) : super(key: key);

  @override
  State<MyPointsScreen> createState() => _MyPointsScreenState();
}

class _MyPointsScreenState extends State<MyPointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.black,
                              size: 18,
                            ),
                          ),
                          Text('My Points',
                              style: defaultTheme.textTheme.headline3),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.toNamed(pointTableScreen);
                            },
                            child: Text('Point Table',
                                style: defaultTheme.textTheme.headline4!
                                    .copyWith(color: AppColors.secondaryColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text('Daily Points Achived',
                            style: defaultTheme.textTheme.headline4),
                      ),
                      const SizedBox(height: 32),
                      Center(
                          child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                              width: 130,
                              height: 130,
                              child: CircularProgressIndicator(
                                value: .6,
                                strokeWidth: 15,
                                color: AppColors.secondaryColor,
                                backgroundColor: AppColors.myPointProgress,
                              )),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('15',
                                      style: defaultTheme.textTheme.headline2),
                                  Text('/20',
                                      style: defaultTheme.textTheme.headline4),
                                ],
                              ),
                              Text('Points',
                                  style: defaultTheme.textTheme.subtitle2),
                            ],
                          ),
                        ],
                      )),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Your Total Points : ',
                              style: defaultTheme.textTheme.subtitle2),
                          Text('600', style: defaultTheme.textTheme.headline4),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                ClipRect(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Text('Points History',
                                style: defaultTheme.textTheme.headline4),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.borderColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                children: [
                                  Text('January',
                                      style: defaultTheme.textTheme.headline5!
                                          .copyWith(
                                              color: AppColors.secondaryColor)),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.iconBG,
                                    size: 18,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          height: 2,
                          color: AppColors.textFieldHintTextColor,
                        ),
                        const SizedBox(height: 32),
                        pointItem("Jan 1st", "5/20 Points"),
                        pointItem("Jan 2nd", "7/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                        pointItem("Jan 3rd", "10/20 Points"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pointItem(date, points) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(myPointsListScreen);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: [
            Text(date, style: defaultTheme.textTheme.bodyText2),
            const Spacer(),
            Text(points, style: defaultTheme.textTheme.bodyText2),
            const SizedBox(width: 10),
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
}
