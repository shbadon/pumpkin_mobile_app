import 'package:flutter/material.dart';
import 'package:pumpkin/screens/calendar/calendar_utils.dart';
import 'package:intl/intl.dart';
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
              const SizedBox(height: 8.0),
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
          SvgPicture.asset(
            calendarIconWithDot,
            height: 24,
            width: 24,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 26, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.white),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 20),
        lastDay: DateTime.utc(2040, 10, 20),
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
        // selectedDayPredicate: (day) {
        //   return day;
        // },
        calendarStyle: CalendarStyle(
          todayTextStyle: defaultTheme.textTheme.bodyText1!
              .copyWith(color: AppColors.black80),
          todayDecoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.19),
            shape: BoxShape.circle,
          ),
          isTodayHighlighted: true,
        ),
        onDaySelected: (selectedDay, focusedDay) {
          print(selectedDay);
          print(focusedDay);
        },
      ),
    );
  }

  Widget eventWidget() {
    return Expanded(
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
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  onTap: () => print('${value[index]}'),
                  title: Text('${value[index]}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
