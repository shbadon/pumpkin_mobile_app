import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

class PointTableScreen extends StatefulWidget {
  const PointTableScreen({Key? key}) : super(key: key);

  @override
  State<PointTableScreen> createState() => _PointTableScreenState();
}

class _PointTableScreenState extends State<PointTableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0)),
                          color: AppColors.black,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/coin.png",
                              width: 36,
                            ),
                            const SizedBox(width: 10),
                            Text('Point Table',
                                style: defaultTheme.textTheme.headline2
                                    ?.copyWith(color: AppColors.white)),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Get.back();
                              },
                              child: const Icon(Icons.close,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                      itemHead(),
                      const Divider(
                        height: 2,
                        color: AppColors.dividerColor,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Warm Call*", "1"),
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Cold Call*", "0.5"),
                            itemBody("Appointment(Non Business)", "0.5"),
                            itemBody("Appointment(Business)", "0.5"),
                            itemBody("Appointment( Closed)", "0.5"),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0)),
                          color: AppColors.profileIconBG,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cold Call*- Calls done at seed stage",
                                style: defaultTheme.textTheme.bodyText2
                                    ?.copyWith(
                                        color: AppColors.pointTableBodyColor)),
                            const SizedBox(height: 10),
                            Text(
                                "Warm Call*- Calls done at Sapling, Flower and Pumpkin stages",
                                style: defaultTheme.textTheme.bodyText2
                                    ?.copyWith(
                                        color: AppColors.pointTableBodyColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemHead() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Row(
        children: [
          Text("Event", style: defaultTheme.textTheme.subtitle2),
          const Spacer(),
          Text("Points", style: defaultTheme.textTheme.subtitle2),
        ],
      ),
    );
  }

  Widget itemBody(event, points) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 17, right: 17, bottom: 10),
      child: Row(
        children: [
          Text(event,
              style: defaultTheme.textTheme.bodyText1
                  ?.copyWith(color: AppColors.pointTableBodyColor)),
          const Spacer(),
          Text(points,
              style: defaultTheme.textTheme.bodyText1
                  ?.copyWith(color: AppColors.pointTableBodyColor)),
        ],
      ),
    );
  }
}
