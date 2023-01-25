import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 2,length: 3, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.setupProfileBG,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.arrow_back_ios_sharp,
                    color: AppColors.darkIconcolor,
                    size: 24,
                  ),
                  Text('December 2022',
                      style: defaultTheme.textTheme.subtitle1),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColors.darkIconcolor,
                    size: 24,
                  ),
                ],
              ),
              SizedBox(height:18),
              tabWidget(),
              calenderWidget(),
            ],
          ),
        ));
  }

  Widget tabWidget() {
    return Row(
      children: [
        SvgPicture.asset(
          calendarIconWithDot,
          height: 24,
          width: 24,
        ),
        SizedBox(width:24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.white.withOpacity(0.6),
                border: Border.all(
                  color: AppColors.white,
                )),
            child: TabBar(
                unselectedLabelColor: AppColors.black80,
                indicatorColor: AppColors.white,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,

                indicator: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelPadding: EdgeInsets.zero,


                tabs: [
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    child: Text(
                      'Day',
                      style: defaultTheme.textTheme.bodyText2?.copyWith(
                        color:_getColor(0),
                      ),
                    ),
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    child: Text(
                      'Week',
                      style: defaultTheme.textTheme.bodyText2?.copyWith(
                        color:_getColor(1),
                      ),
                    ),
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    child: Text(
                      'Month',
                      style: defaultTheme.textTheme.bodyText2?.copyWith(
                        color:_getColor(2),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  Color _getColor(int index) {
    if (tabController.index == index) {
      return AppColors.white;
    }
    return AppColors.black80;
  }

    Widget calenderWidget(){
        return    TableCalendar(
          firstDay: DateTime.utc(2010, 10, 20),
          lastDay: DateTime.utc(2040, 10, 20),
          focusedDay: DateTime.now(),
          headerVisible: true,
          daysOfWeekVisible: true,
          sixWeekMonthsEnforced: true,
          shouldFillViewport: false,
          headerStyle: HeaderStyle(titleTextStyle: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.w800)),
          calendarStyle: CalendarStyle(todayTextStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        );
      }

}
