import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/leads_screen_controller.dart';
import 'package:pumpkin/screens/leads/lead_list_flower_screen.dart';
import 'package:pumpkin/screens/leads/lead_list_pumpkin_screen.dart';
import 'package:pumpkin/screens/leads/lead_list_sapling_screen.dart';
import 'package:pumpkin/screens/leads/lead_list_seed_screen.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/buttons/floatingactionbutton.dart';

class LeadsListScreen extends StatefulWidget {
  const LeadsListScreen({super.key});

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

class _LeadsListScreenState extends State<LeadsListScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late Animation<double> _animation;
  late AnimationController _animationController;
  LeadsScreenController leadsScreenController =
      GetControllers.shared.getLeadListScreenController();

  @override
  void initState() {
    leadsScreenController.getLeads('seed');
    leadsScreenController.getLeadCount();
    tabController = TabController(length: 4, vsync: this)
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
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Leads ', style: defaultTheme.textTheme.headline3),
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(' ${leadsScreenController.allLeadCount!.value}',
                    style: defaultTheme.textTheme.bodyText1!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            icon: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.profileIconBG,
                child: SvgPicture.asset(
                  'assets/icons/filter_icon.svg',
                  color: AppColors.darkIconcolor,
                )),
            onSelected: (value) {
              if (value == 1) {
                leadsScreenController.filterLeadBasedOnStatus(status: null);
              } else if (value == 2) {
                leadsScreenController.filterLeadBasedOnStatus(status: true);
              } else {
                leadsScreenController.filterLeadBasedOnStatus(status: false);
              }
            },
            itemBuilder: (context) => [
              // popupmenu item 1

              PopupMenuItem(
                value: 1,
                height: 35,
                // row has two child icon and text.
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Text("All",
                        style: defaultTheme.textTheme.bodyText1!.copyWith(
                          color: AppColors.black.withOpacity(0.8),
                        ))
                  ],
                ),
              ),
              // popupmenu item 2
              PopupMenuItem(
                value: 2,
                height: 35,
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text("Active",
                        style: defaultTheme.textTheme.headline5!.copyWith(
                          color: AppColors.black.withOpacity(0.8),
                        ))
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                height: 35,
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text("Inactive",
                        style: defaultTheme.textTheme.headline5!.copyWith(
                          color: AppColors.black.withOpacity(0.8),
                        )),
                  ],
                ),
              ),
            ],
            //offset: Offset(0, 100),
            //color: Colors.grey,
            elevation: 5,
          ),
          /*IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/filter_icon.svg',
                color: AppColors.darkIconcolor,
              )),*/
          IconButton(
              onPressed: () {
                Get.toNamed(searchLeadsScreen);
              },
              icon: SvgPicture.asset(
                'assets/icons/search_icon.svg',
                color: AppColors.darkIconcolor,
              ))
        ],
        bottom: TabBar(
            unselectedLabelColor: AppColors.darkIconcolor,
            indicatorColor: AppColors.primaryColor,
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text('Seed'),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      // padding: const EdgeInsets.all(5),
                      decoration: tabController.index == 0
                          ? const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle)
                          : BoxDecoration(
                              color: AppColors.iconBG.withOpacity(0.2),
                              shape: BoxShape.circle),
                      child: Center(
                        child: Obx(
                          () => Text(
                            leadsScreenController.seedLeadCount!.value,
                            style: tabController.index == 0
                                ? defaultTheme.textTheme.caption
                                : defaultTheme.textTheme.caption!
                                    .copyWith(color: AppColors.darkIconcolor),
                          ),
                        ),
                      ),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text('Sapling'),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      // padding: const EdgeInsets.all(5),
                      decoration: tabController.index == 1
                          ? const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle)
                          : BoxDecoration(
                              color: AppColors.iconBG.withOpacity(0.2),
                              shape: BoxShape.circle),
                      child: Center(
                        child: Obx(
                          () => Text(
                              leadsScreenController.saplingLeadCount!.value,
                              style: tabController.index == 1
                                  ? defaultTheme.textTheme.caption
                                  : defaultTheme.textTheme.caption!.copyWith(
                                      color: AppColors.darkIconcolor)),
                        ),
                      ),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text('Flower'),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      // padding: const EdgeInsets.all(5),
                      decoration: tabController.index == 2
                          ? const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle)
                          : BoxDecoration(
                              color: AppColors.iconBG.withOpacity(0.2),
                              shape: BoxShape.circle),
                      child: Center(
                        child: Obx(
                          () => Text(
                              leadsScreenController.flowerLeadCount!.value,
                              style: tabController.index == 2
                                  ? defaultTheme.textTheme.caption
                                  : defaultTheme.textTheme.caption!.copyWith(
                                      color: AppColors.darkIconcolor)),
                        ),
                      ),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text('Pumpkin'),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      // padding: const EdgeInsets.all(5),
                      decoration: tabController.index == 3
                          ? const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle)
                          : BoxDecoration(
                              color: AppColors.iconBG.withOpacity(0.2),
                              shape: BoxShape.circle),
                      child: Center(
                        child: Obx(
                          () => Text(
                              leadsScreenController.pumpkinLeadCount!.value,
                              style: tabController.index == 3
                                  ? defaultTheme.textTheme.caption
                                  : defaultTheme.textTheme.caption!.copyWith(
                                      color: AppColors.darkIconcolor)),
                        ),
                      ),
                    )
                  ]),
            ]),
      ),
      body: Stack(
        children: [
          _body(tabController.index),
          Obx(
            () => leadsScreenController.hideBackground.value
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.3),
                  )
                : const Offstage(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButtonCustom(
        onPress: () {
          leadsScreenController.hideBackground.value =
              !leadsScreenController.hideBackground.value;
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        },
        itemsList: [
          Bubble(
              icon: Icons.person_add_alt,
              iconColor: AppColors.darkIconcolor,
              title: 'Add Lead',
              titleStyle: defaultTheme.textTheme.bodyText1!.copyWith(
                  color: AppColors.darkIconcolor, fontWeight: FontWeight.w600),
              bubbleColor: AppColors.white,
              onPress: () {
                Get.toNamed(addLeadScreen)!.then((value) {
                  _animationController.reverse();
                  leadsScreenController.hideBackground.value = false;
                  leadsScreenController.getLeads(tabController.index == 0
                      ? 'seed'
                      : tabController.index == 1
                          ? 'sapling'
                          : tabController.index == 2
                              ? 'flower'
                              : 'pumpkin');
                  leadsScreenController.getLeadCount();
                });
              }),
          Bubble(
              icon: Icons.file_upload_outlined,
              iconColor: AppColors.darkIconcolor,
              title: 'Upload File',
              titleStyle: defaultTheme.textTheme.bodyText1!.copyWith(
                  color: AppColors.darkIconcolor, fontWeight: FontWeight.w600),
              bubbleColor: AppColors.white,
              onPress: () {
                Get.toNamed(uploadFileScreen)!.then((value) {
                  _animationController.reverse();
                  leadsScreenController.hideBackground.value = false;
                });
              })
        ],
        animation: _animation,
      ),
    );
  }

  _body(int index) {
    switch (index) {
      case 0:
        leadsScreenController.getLeads('seed');
        return LeadListSeedScreen();
      case 1:
        leadsScreenController.getLeads('sapling');
        return LeadListSaplingScreen();
      case 2:
        leadsScreenController.getLeads('flower');
        return LeadListFlowerScreen();
      case 3:
        leadsScreenController.getLeads('pumpkin');
        return LeadListPumpkinScreen();
      default:
        return const Offstage();
    }
  }
}
