import 'package:flutter/material.dart';
import 'package:pumpkin/screens/calendar/calendar_utils.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pumpkin/utils/date_format.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  late final ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late TabController tabController;
  late Animation<double> _animation;
  late AnimationController _animationController;
  PageController pageController = PageController();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  ValueNotifier<String> headerText =
      ValueNotifier(formatDateToMMMMYYYY(DateTime.now().toString()));

  @override
  void initState() {
    tabController = TabController(initialIndex: 2, length: 3, vsync: this)
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

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  _pickDate() async {
    final pickDate = await showDatePicker(
      context: context,
      initialDate: focusedDay,
      firstDate: DateTime.utc(2010, 10, 20),
      lastDate: DateTime.utc(2040, 10, 20),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: AppColors.white,
              onSurface: AppColors.black80,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickDate != null) {
      selectedDay = pickDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.setupProfileBG,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                        focusedDay =
                            focusedDay.subtract(const Duration(days: 30));
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: AppColors.darkIconcolor,
                        size: 24,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: headerText,
                      builder: (context, String value, child) {
                        return Text(value,
                            style: defaultTheme.textTheme.subtitle1);
                      },
                    ),
                    InkWell(
                      onTap: () {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                        focusedDay = focusedDay.add(const Duration(days: 30));
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: AppColors.darkIconcolor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              tabWidget(),
              const SizedBox(height: 16),
              calenderWidget(),
              const SizedBox(height: 16.0),
              eventWidget(),
              const SizedBox(height: 8.0),
            ],
          ),
        ));
  }

  Widget tabWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          InkWell(
            onTap: _pickDate,
            child: SvgPicture.asset(
              calendarIconWithDot,
              height: 24,
              width: 24,
            ),
          ),
          const SizedBox(width: 24),
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
                          color: _getColor(0),
                        ),
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      child: Text(
                        'Week',
                        style: defaultTheme.textTheme.bodyText2?.copyWith(
                          color: _getColor(1),
                        ),
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      child: Text(
                        'Month',
                        style: defaultTheme.textTheme.bodyText2?.copyWith(
                          color: _getColor(2),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    if (tabController.index == index) {
      return AppColors.white;
    }
    return AppColors.black80;
  }

  Widget calenderWidget() {
    switch (tabController.index) {
      case 0:
        return dayCalenderWidget();
      case 1:
        return weekCalenderWidget();
      case 2:
        return monthCalenderWidget();

      default:
        return const Offstage();
    }
  }

  Widget monthCalenderWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 26, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.white),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 20),
        lastDay: DateTime.utc(2040, 10, 20),
        eventLoader: (day) {
          final dates = [1, 2, 8, 7, 3, 6, 8, 21, 30];
          if (dates.contains(day.day)) {
            return [day];
          }

          return [];
        },
        focusedDay: focusedDay,
        daysOfWeekVisible: true,
        sixWeekMonthsEnforced: false,
        shouldFillViewport: false,
        onCalendarCreated: (controller) => pageController = controller,
        headerVisible: false,
        availableGestures: AvailableGestures.all,
        onPageChanged: (focusedDay) {
          headerText.value = formatDateToMMMMYYYY(focusedDay.toString());
        },
        calendarStyle: CalendarStyle(
          markerDecoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
          todayTextStyle: defaultTheme.textTheme.bodyText1!
              .copyWith(color: AppColors.black80),
          todayDecoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.19),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: defaultTheme.textTheme.bodyText2!
              .copyWith(color: AppColors.textFieldTitleColor),
          isTodayHighlighted: true,
        ),
        selectedDayPredicate: (day) {
          return isSameDay(
            day,
            selectedDay,
          );
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
            this.focusedDay = selectedDay;
          });
        },
      ),
    );
  }

  Widget weekCalenderWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 26, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.white),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 20),
        lastDay: DateTime.utc(2040, 10, 20),
        calendarFormat: CalendarFormat.week,
        focusedDay: focusedDay,
        daysOfWeekVisible: true,
        sixWeekMonthsEnforced: false,
        shouldFillViewport: false,
        onCalendarCreated: (controller) => pageController = controller,
        headerVisible: false,
        availableGestures: AvailableGestures.all,
        onPageChanged: (focusedDay) {
          headerText.value = formatDateToMMMMYYYY(focusedDay.toString());
        },
        calendarStyle: CalendarStyle(
          todayTextStyle: defaultTheme.textTheme.bodyText1!
              .copyWith(color: AppColors.black80),
          todayDecoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.19),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: defaultTheme.textTheme.bodyText2!
              .copyWith(color: AppColors.textFieldTitleColor),
          isTodayHighlighted: true,
          markerDecoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(
            day,
            selectedDay,
          );
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
            this.focusedDay = selectedDay;
          });
        },
        eventLoader: (day) {
          final dates = [1, 2, 8, 7, 3, 6, 8, 21, 30, 28];
          if (dates.contains(day.day)) {
            return [day];
          }

          return [];
        },
      ),
    );
  }

  Widget dayCalenderWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.white),
      alignment: Alignment.center,
      child: Text(
        formatDateToEEEEdd(focusedDay.toString()),
        style: defaultTheme.textTheme.headline2!
            .copyWith(color: AppColors.bottomNavigationBarUnselectedLabelColor),
      ),
    );
  }

  Widget eventWidget() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDateToDDEEEE(focusedDay.toString()),
              style: defaultTheme.textTheme.titleMedium,
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 4.0,
                        ),
                        // child: ListTile(
                        //   onTap: () => print('${value[index]}'),
                        //   title: Text('${value[index]}'),
                        // ),
                        child: Column(
                          children: [
                            ExpansionTile(
                              leading: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: AppColors.profileIconBG,
                                  //backgroundImage: const AssetImage("assets/images/avater.jpeg"),
                                  child: SvgPicture.asset(
                                    'assets/icons/accounts.svg',
                                  )),
                              trailing: Text('All-Day',
                                  style: defaultTheme.textTheme.titleSmall),
                              title: Text(
                                'Wish them a Happy Birthday!',
                                style: defaultTheme.textTheme.titleMedium,
                                maxLines: 3,
                              ),
                              backgroundColor: Colors.transparent,
                              collapsedIconColor: Colors.transparent,
                              collapsedBackgroundColor: Colors.transparent,
                              iconColor: Colors.transparent,
                              tilePadding: const EdgeInsets.all(0),
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Column(
                                    children: [
                                      const Text('Hello'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
