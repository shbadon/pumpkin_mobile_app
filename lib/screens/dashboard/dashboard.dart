import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/screens/calendar/calendar_screen.dart';
import 'package:pumpkin/screens/leads/leads%20_list_screen.dart';
import 'package:pumpkin/screens/profile/my_profile_screen.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/strings.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
        .dark); //This makes the status bar text color change
    return Obx(
      () => Scaffold(
        body: _body(
            GetControllers.shared.getDashboardController().pageIndex.value),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) => GetControllers.shared
                .getDashboardController()
                .onItemTapped(index),
            currentIndex:
                GetControllers.shared.getDashboardController().pageIndex.value,
            items: [
              BottomNavigationBarItem(
                  icon: GetControllers.shared
                              .getDashboardController()
                              .pageIndex
                              .value ==
                          0
                      ? SvgPicture.asset(homeIconSelected)
                      : SvgPicture.asset(homeIcon),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: GetControllers.shared
                              .getDashboardController()
                              .pageIndex
                              .value ==
                          1
                      ? SvgPicture.asset(goalIconSelected)
                      : SvgPicture.asset(goalIcon),
                  label: 'Goal'),
              BottomNavigationBarItem(
                  icon: GetControllers.shared
                              .getDashboardController()
                              .pageIndex
                              .value ==
                          2
                      ? SvgPicture.asset(leadIconSelected)
                      : SvgPicture.asset(leadIcon),
                  label: 'Lead'),
              BottomNavigationBarItem(
                  icon: GetControllers.shared
                              .getDashboardController()
                              .pageIndex
                              .value ==
                          3
                      ? SvgPicture.asset(calendarIconSelected)
                      : SvgPicture.asset(calendarIcon),
                  label: 'Calendar'),
              BottomNavigationBarItem(
                  icon: GetControllers.shared
                              .getDashboardController()
                              .pageIndex
                              .value ==
                          4
                      ? SvgPicture.asset(profileIconSelected)
                      : SvgPicture.asset(profileIcon),
                  label: 'Profile')
            ]),
      ),
    );
  }

  _body(int index) {
    switch (index) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Home page under construction...',
                textAlign: TextAlign.center,
                style: defaultTheme.textTheme.headline1!
                    .copyWith(overflow: TextOverflow.visible),
              ),
            ),
          ],
        );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Goal page under construction...',
                textAlign: TextAlign.center,
                style: defaultTheme.textTheme.headline1!
                    .copyWith(overflow: TextOverflow.visible),
              ),
            ),
          ],
        );
      case 2:
        return const LeadsListScreen();
      case 3:
        return CalendarScreen();
      case 4:
        return const MyProfileScreen();
      default:
        return const Offstage();
    }
  }
}
