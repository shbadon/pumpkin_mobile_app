import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class MyPointsListScreen extends StatefulWidget {
  const MyPointsListScreen({Key? key}) : super(key: key);

  @override
  State<MyPointsListScreen> createState() => _MyPointsListScreenState();
}

class _MyPointsListScreenState extends State<MyPointsListScreen> {
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
                    Row(
                      children: [
                        Text('Jan 1st',
                            style: defaultTheme.textTheme.headline3),
                        const SizedBox(width: 10),
                        Text('15 Points',
                            style: defaultTheme.textTheme.headline3!.copyWith(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
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
                pointItem("assets/icons/calender.svg", "Appointment",
                    "James Saris", "Business", "+5", "Jan 01, 10:30 am"),
                pointItem("assets/icons/phone.svg", "call Cold-Call",
                    "James Saris", "", "+2", "Jan 01, 10:30 am"),
                pointItem("assets/icons/calender.svg", "Appointment",
                    "James Saris", "Business", "+5", "Jan 01, 10:30 am"),
                pointItem("assets/icons/phone.svg", "call Cold-Call",
                    "James Saris", "", "+2", "Jan 01, 10:30 am"),
                pointItem("assets/icons/calender.svg", "Appointment",
                    "James Saris", "Business", "+5", "Jan 01, 10:30 am"),
                pointItem("assets/icons/phone.svg", "call Cold-Call",
                    "James Saris", "", "+2", "Jan 01, 10:30 am"),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pointItem(icon, title, subTitle, status, points, date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.profileIconBG,
                  child: SvgPicture.asset(
                    icon,
                  )),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: defaultTheme.textTheme.headline5),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(status,
                          style: defaultTheme.textTheme.headline5
                              ?.copyWith(color: AppColors.orange)),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(subTitle, style: defaultTheme.textTheme.bodyText2),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: AppColors.secondaryColor,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(points,
                          style: defaultTheme.textTheme.bodyText2
                              ?.copyWith(color: AppColors.orange)),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(date,
                      style: defaultTheme.textTheme.bodyText2
                          ?.copyWith(color: AppColors.focusColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            height: 2,
            color: AppColors.dividerColor,
          )
        ],
      ),
    );
  }
}
