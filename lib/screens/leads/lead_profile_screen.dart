import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/lead_profile_screen_controller.dart';
import 'package:pumpkin/models/response_models/appointments_response_model.dart';
import 'package:pumpkin/models/response_models/notes_response_model.dart';
import 'package:pumpkin/services/repository.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/date_format.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/buttons/button_type_four_with_icon.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/buttons/button_type_three.dart';
import 'package:pumpkin/widgets/buttons/button_type_two.dart';
import 'package:pumpkin/widgets/chips/chips.dart';
import 'package:pumpkin/widgets/dialog/popupAlertDialog.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/forms/dropdown_enum_field.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';
import 'package:pumpkin/widgets/listTile/list_tile_note.dart';
import 'package:pumpkin/widgets/loader.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LeadProfileScreen extends StatefulWidget {
  const LeadProfileScreen({super.key});

  @override
  State<LeadProfileScreen> createState() => _LeadProfileScreenState();
}

class _LeadProfileScreenState extends State<LeadProfileScreen> {
  LeadProfileScreenController leadProfileScreenController =
      GetControllers.shared.getLeadProfileScreenController();

  final addNoteFormKey = GlobalKey<FormState>();
  final addAppointmentFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    init();

    super.initState();
  }

  init() {
    leadProfileScreenController.leadID.value = Get.arguments[0];
    leadProfileScreenController.getLeadDetails();
    leadProfileScreenController.getNotes();
    leadProfileScreenController.getAppointment();
    leadProfileScreenController.getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SafeArea(
          child: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    floating: true,
                    forceElevated: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    elevation: 3,
                    actions: [
                      PopupMenuButton<int>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.bottomNavigationBarColor,
                          size: 20,
                        ),
                        onSelected: (value) {
                          leadProfileScreenController.deleteLead();
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            height: 35,
                            child: Row(
                              children: [
                                Text("Delete Lead",
                                    style: defaultTheme.textTheme.headline5!)
                              ],
                            ),
                          ),
                        ],
                        //offset: Offset(0, 100),
                        //color: Colors.grey,
                        elevation: 5,
                      ),
                    ],
                    leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        color: AppColors.darkIconcolor,
                      ),
                    ),
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.38,
                    flexibleSpace: FlexibleSpaceBar(
                      // TODO: Nedd to check this atribute
                      // title: Text(
                      //   'Nilotpal Ghosh',
                      //   style: TextStyle(color: Colors.black, fontSize: 18),
                      // ),
                      background: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Lead profile image
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.height * 0.09,
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Obx(
                                    () => leadProfileScreenController
                                                .leadModel.value.photo ==
                                            null
                                        ? CircleAvatar(
                                            backgroundColor:
                                                AppColors.fourthColor,
                                            radius: 100,
                                            child: Center(
                                                child: Text(
                                              leadProfileScreenController
                                                          .leadModel
                                                          .value
                                                          .firstName ==
                                                      null
                                                  ? ""
                                                  : leadProfileScreenController
                                                      .leadModel
                                                      .value
                                                      .firstName!
                                                      .split('')
                                                      .first
                                                      .capitalizeFirst
                                                      .toString(),
                                            )))
                                        : CircleAvatar(
                                            radius: 100,
                                            backgroundColor:
                                                AppColors.fourthColor,
                                            backgroundImage:
                                                leadProfileScreenController
                                                            .leadModel
                                                            .value
                                                            .photo !=
                                                        null
                                                    ? NetworkImage(
                                                        leadProfileScreenController
                                                            .leadModel
                                                            .value
                                                            .photo!)
                                                    : null,
                                            child: leadProfileScreenController
                                                        .leadModel
                                                        .value
                                                        .photo ==
                                                    null
                                                ? Center(
                                                    child: Text(
                                                        leadProfileScreenController
                                                            .leadModel
                                                            .value
                                                            .firstName!
                                                            .split('')
                                                            .first),
                                                  )
                                                : null),
                                  ),
                                  Obx(
                                    () => Positioned(
                                      top: MediaQuery.of(context).size.height *
                                          0.065,
                                      left: MediaQuery.of(context).size.height *
                                          0.06,
                                      height: 15,
                                      width: 15,
                                      child: Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                            border: const Border(
                                                top: BorderSide(
                                                    color: AppColors
                                                        .scaffoldColor),
                                                bottom: BorderSide(
                                                    color: AppColors
                                                        .scaffoldColor),
                                                left: BorderSide(
                                                    color: AppColors
                                                        .scaffoldColor),
                                                right: BorderSide(
                                                    color: AppColors
                                                        .scaffoldColor)),
                                            shape: BoxShape.circle,
                                            color: leadProfileScreenController
                                                .leadModel.value.status == null ? AppColors.white : leadProfileScreenController
                                                    .leadModel.value.status!
                                                ? AppColors.validColor
                                                : AppColors.errorColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text for Lead name
                            Obx(() => Text(
                                  '${leadProfileScreenController.leadModel.value.firstName ?? ""} ${leadProfileScreenController.leadModel.value.lastName ?? ""}',
                                  style: defaultTheme.textTheme.headline3,
                                )),
                            // The Lead current status (Eg: Sapling, seed, pumpkin)
                            Container(
                              padding: const EdgeInsets.all(7),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: const Border(
                                      top: BorderSide(
                                          color: AppColors.validColor),
                                      bottom: BorderSide(
                                          color: AppColors.validColor),
                                      left: BorderSide(
                                          color: AppColors.validColor),
                                      right: BorderSide(
                                          color: AppColors.validColor)),
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.lightGreen.withOpacity(0.3)),
                              child: Obx(() => leadProfileScreenController
                                          .leadModel.value.leadStage ==
                                      null
                                  ? const SizedBox()
                                  : Text(
                                      leadProfileScreenController
                                          .leadModel.value.leadStage
                                          .toString(),
                                      style: defaultTheme.textTheme.bodyText1!
                                          .copyWith(
                                              color: AppColors.validColor,
                                              fontWeight: FontWeight.w500),
                                    )),
                            ),
                            // These are the tags
                            Obx(() => Wrap(
                                  children: [
                                    if (leadProfileScreenController
                                            .leadModel.value.tags !=
                                        null) ...[
                                      for (var item
                                          in leadProfileScreenController
                                              .leadModel.value.tags!)
                                        MyChips(
                                          chipText: item,
                                        ),
                                    ]
                                  ],
                                )),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: ButtonTypeOne(
                                      buttonStatus: ButtonStatus.enabled,
                                      buttonText: 'Contact',
                                      onPressed: () {
                                        contactBottomSheet();
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: ButtonTypeOne(
                                      buttonStatus: ButtonStatus.enabled,
                                      buttonText: 'Add Appointment',
                                      onPressed: () {
                                        appointmentAddUpdateBottomSheet(
                                            "Add Appointment",
                                            false,
                                            AppointmentModel());
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  /*SliverPadding(
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    sliver: SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        const TabBar(
                          indicatorColor: AppColors.primaryColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(text: "Activity"),
                            Tab(text: "Details"),
                            Tab(text: "Notes"),
                          ],
                        ),

                      ),
                      pinned: true,
                      floating: false,
                    ),
                  )*/

                  const SliverAppBar(
                    pinned: true,
                    forceElevated: true,
                    primary: false,
                    automaticallyImplyLeading: false,
                    expandedHeight: 30,
                    collapsedHeight: null,
                    toolbarHeight: 70,
                    titleSpacing: 0,
                    title: TabBar(
                      indicatorColor: AppColors.primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      //padding: EdgeInsets.only(top: 10),
                      labelPadding: EdgeInsets.zero,
                      tabs: [
                        Tab(text: "Activity"),
                        Tab(text: "Details"),
                        Tab(text: "Notes"),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(children: [
                activity(),
                details(),
                notes(),
              ]),
            ),
          ),
        ),
        Obx(
          () => leadProfileScreenController.isLoading.value
              ? const Loader()
              : const Offstage(),
        )
      ],
    ));
  }

  //lead profile activity tab widgets
  Widget activity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Obx(() => ListView.builder(
              itemCount: leadProfileScreenController.activitiesList.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // var item =
                //     leadProfileScreenController.activitiesList.elementAt(index);
                return activityItem(
                    activityType: leadProfileScreenController
                        .activitiesList[index].activityType!,
                    title: leadProfileScreenController
                        .activitiesList[index].activityType!
                        .toString()
                        .capitalizeFirst!,
                    subTitle: leadProfileScreenController
                                .activitiesList[index].startDateTime ==
                            null
                        ? ''
                        : showUpdateButtonInActivity(leadProfileScreenController
                                .activitiesList[index].startDateTime
                                .toString())
                            ? "On ${formatDateTimeToDDMMYYYYHHMM(leadProfileScreenController.activitiesList[index].startDateTime.toString())}"
                            : "Attended On ${formatDateTimeToDDMMYYYYHHMM(leadProfileScreenController.activitiesList[index].startDateTime.toString())}",
                    status: leadProfileScreenController
                        .activitiesList[index].appointmentStatus
                        .toString()
                        .capitalizeFirst,
                    points:
                        "+${leadProfileScreenController.activitiesList[index].point ?? 0}",
                    date: formatDateTimeToDDMMYYYYHHMM(leadProfileScreenController
                        .activitiesList[index].createdAt
                        .toString()),
                    appointmentEndTime: leadProfileScreenController
                        .activitiesList[index].endDateTime,
                    appointmentID: leadProfileScreenController.activitiesList[index].appointmentId ?? '');
              })),

          /*reminderItem("assets/icons/calender.svg", "Update Appointment",
              "Attended On Jan 30, 10:00 am", "", "+5", "Jan 01, 10:30 am"),*/

          /* activityItem("assets/icons/phone.svg", "Call", "", "", "+2",
              "Jan 01, 10:30 am"),
          activityItem("assets/icons/calender.svg", "Appointment",
              "James Saris", "Business", "+5", "Jan 01, 10:30 am"),*/
        ],
      ),
    );
  }

  Future appointmentViewBottomSheet(AppointmentModel model) {
    leadProfileScreenController.noteTextEditingController.text =
        model.note.toString();
    leadProfileScreenController.startTimeTextEditingController.text =
        formatTimeToHHMM(model.startDatetime.toString());
    leadProfileScreenController.endTimeTextEditingController.text =
        formatTimeToHHMM(model.endDatetime.toString());
    leadProfileScreenController.dateTextEditingController.text =
        formatDate(model.startDatetime.toString(), dateFormat2);
    leadProfileScreenController.selectedAlert.description =
        model.alertId.toString().capitalizeFirst;

    return Get.bottomSheet(
      isScrollControlled: true,
      //elevation: 5,
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
      SafeArea(
        child: Container(
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Wrap(
                    //height: Get.height * 0.7,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: addAppointmentFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 5),
                                  Text("Appointment Details",
                                      style: defaultTheme.textTheme.headline4),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      appointmentAddUpdateBottomSheet(
                                          "Reschedule Appointment",
                                          true,
                                          model);
                                    },
                                    child: const Icon(Icons.edit_note),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      leadProfileScreenController
                                          .deleteAppointment(
                                              model.id.toString());
                                    },
                                    child: const Icon(Icons.delete_outline),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Lead Name"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                type: InputFieldTypes.textView,
                                controller: TextEditingController(
                                    text: leadProfileScreenController
                                            .leadModel.value.firstName
                                            .toString() +
                                        " " +
                                        leadProfileScreenController
                                            .leadModel.value.lastName
                                            .toString()),
                              ),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Date"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                type: InputFieldTypes.textView,
                                context: context,
                                controller: leadProfileScreenController
                                    .dateTextEditingController,
                                hintText: "",
                                dateFormat: "yyyy-MM-dd",
                                //dd-mm-yyyy
                                key: const Key("date"),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const FormFieldTitle(
                                            title: "Start Time"),
                                        const SizedBox(height: 9),
                                        CustomTextField(
                                          type: InputFieldTypes.textView,
                                          context: context,
                                          controller: leadProfileScreenController
                                              .startTimeTextEditingController,
                                          hintText: "",
                                          //dd-mm-yyyy
                                          key: const Key("Start Time"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const FormFieldTitle(title: "End Time"),
                                        const SizedBox(height: 9),
                                        CustomTextField(
                                          type: InputFieldTypes.textView,
                                          context: context,
                                          controller:
                                              leadProfileScreenController
                                                  .endTimeTextEditingController,
                                          hintText: "",
                                          //dd-mm-yyyy
                                          key: const Key("End Time"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Notes"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                  type: InputFieldTypes.textView,
                                  controller: leadProfileScreenController
                                      .noteTextEditingController,
                                  hintText: "Add Notes",
                                  key: const Key('Description')),
                              const SizedBox(height: 24),
                              const FormFieldTitle(title: "Alert"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                  type: InputFieldTypes.textView,
                                  controller: TextEditingController(
                                      text: leadProfileScreenController
                                          .selectedAlert.description),
                                  hintText: "Add Notes",
                                  key: const Key('alert')),
                              const SizedBox(height: 40),
                              /*Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Get.back();
                                      leadProfileScreenController
                                          .deleteAppointment(
                                              model.id.toString());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 30),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.orange,
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text("Delete",
                                          style: defaultTheme
                                              .textTheme.headline5!
                                              .copyWith(
                                                  color: AppColors.orange)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Get.back();
                                      appointmentAddUpdateBottomSheet(
                                          "Reschedule Appointment",
                                          true,
                                          model);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 30),
                                      decoration: BoxDecoration(
                                        color: AppColors.orange,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Text("Reschedule",
                                              style: defaultTheme
                                                  .textTheme.headline5!
                                                  .copyWith(
                                                      color: AppColors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),*/
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future appointmentAddUpdateBottomSheet(
      String title, bool isUpdate, AppointmentModel model) {
    if (isUpdate) {
      leadProfileScreenController.noteTextEditingController.text =
          model.note.toString();
      leadProfileScreenController.startTimeTextEditingController.text =
          formatTimeToHHMM(model.startDatetime.toString());
      leadProfileScreenController.endTimeTextEditingController.text =
          formatTimeToHHMM(model.endDatetime.toString());
      leadProfileScreenController.dateTextEditingController.text =
          formatDate(model.startDatetime.toString(), dateFormat2);
      leadProfileScreenController.selectedAlert = EnumRepository.findEnum(
          GetControllers.shared.getEnumController().alertList,
          model.alertId.toString(),
          false,
          leadProfileScreenController.selectedAlert);
    }

    final overlayWidgetController = ExpandableOverlayWidgetController();

    return Get.bottomSheet(
      isScrollControlled: true,
      //elevation: 5,
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
      GestureDetector(
        onTap: () {
          debugPrint("ontap:: outside");
          FocusScope.of(context).unfocus();
          overlayWidgetController.hide();
        },
        child: SizedBox(
          height: Get.height * 0.8,
          child: Container(
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Wrap(
                      //height: Get.height * 0.7,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: addAppointmentFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 17,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(title,
                                        style:
                                            defaultTheme.textTheme.headline4),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const FormFieldTitle(title: "Lead Name"),
                                const SizedBox(height: 9),
                                CustomTextField(
                                    type: InputFieldTypes.fullnameWithClear,
                                    controller: TextEditingController(
                                        text: leadProfileScreenController
                                                .leadModel.value.firstName
                                                .toString() +
                                            " " +
                                            leadProfileScreenController
                                                .leadModel.value.lastName
                                                .toString()),
                                    readOnly: true,
                                    hintText: "James Saris",
                                    key: const Key('name')),
                                const SizedBox(height: 24),
                                const FormFieldTitle(title: "Date"),
                                const SizedBox(height: 9),
                                CustomTextField(
                                  type: InputFieldTypes.date,
                                  context: context,
                                  controller: leadProfileScreenController
                                      .dateTextEditingController,
                                  hintText: "",
                                  dateFormat: "yyyy-MM-dd",
                                  //dd-mm-yyyy
                                  key: const Key("date"),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const FormFieldTitle(
                                              title: "Start Time"),
                                          const SizedBox(height: 9),
                                          CustomTextField(
                                            type: InputFieldTypes.time,
                                            context: context,
                                            controller: leadProfileScreenController
                                                .startTimeTextEditingController,
                                            hintText: "",
                                            //dd-mm-yyyy
                                            key: const Key("Start Time"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const FormFieldTitle(
                                              title: "End Time"),
                                          const SizedBox(height: 9),
                                          CustomTextField(
                                            type: InputFieldTypes.time,
                                            context: context,
                                            controller:
                                                leadProfileScreenController
                                                    .endTimeTextEditingController,
                                            hintText: "",
                                            //dd-mm-yyyy
                                            key: const Key("End Time"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const FormFieldTitle(title: "Notes"),
                                const SizedBox(height: 9),
                                CustomTextField(
                                    type: InputFieldTypes.textArea,
                                    controller: leadProfileScreenController
                                        .noteTextEditingController,
                                    hintText: "Add Notes",
                                    key: const Key('Description')),
                                const SizedBox(height: 24),
                                const FormFieldTitle(title: "Alert"),
                                const SizedBox(height: 9),
                                DropdownEnumField(
                                    overlayWidgetController:
                                        overlayWidgetController,
                                    list: GetControllers.shared
                                        .getEnumController()
                                        .alertList,
                                    initialEnum: leadProfileScreenController
                                        .selectedAlert),
                                const SizedBox(height: 18),
                                ButtonTypeOne(
                                  key: const Key("Save"),
                                  buttonStatus: ButtonStatus.enabled,
                                  buttonText: "Save",
                                  isGeneralButton: true,
                                  onPressed: () {
                                    if (addAppointmentFormKey.currentState!
                                        .validate()) {
                                      Get.back();
                                      if (isUpdate) {
                                        leadProfileScreenController
                                            .updateAppointment(
                                                model.id.toString());
                                      } else {
                                        leadProfileScreenController
                                            .addAppointment();
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    /*return Get.bottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: AppColors.white,
      //elevates modal bottom screen
      elevation: 10,
      constraints: BoxConstraints(minHeight: Get.height * 0.8, maxHeight: Get.height * 0.9),
      // gives rounded corner to modal bottom screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      widget: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return SingleChildScrollView(
          child: Wrap(
            //height: Get.height * 0.7,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 17,),
                        const SizedBox(width: 5),
                        Text(title, style: defaultTheme.textTheme.headline4),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Lead Name"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.fullnameWithClear,
                        controller: TextEditingController(),
                        hintText: "James Saris",
                        key: const Key('name')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Date"),
                    const SizedBox(height: 9),
                    CustomTextField(
                      type: InputFieldTypes.date,
                      context: context,
                      controller: TextEditingController(),
                      hintText: "",
                      //dd-mm-yyyy
                      key: const Key("date"),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormFieldTitle(title: "Start Time"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                type: InputFieldTypes.time,
                                context: context,
                                controller: TextEditingController(),
                                hintText: "",
                                //dd-mm-yyyy
                                key: const Key("Start Time"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormFieldTitle(title: "End Time"),
                              const SizedBox(height: 9),
                              CustomTextField(
                                type: InputFieldTypes.time,
                                context: context,
                                controller: TextEditingController(),
                                hintText: "",
                                //dd-mm-yyyy
                                key: const Key("End Time"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Notes"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.textArea,
                        controller: TextEditingController(),
                        hintText: "Add Notes",
                        key: const Key('Description')),

                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Alert"),
                    const SizedBox(height: 9),
                    Container(height: 45,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: AppColors.borderColor, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(
                                10) //                 <--- border radius here
                            )), child: const AlertDropdownFormField()),

                    const SizedBox(height: 18),
                    ButtonTypeOne(
                      key: const Key("Save"),
                      buttonStatus: ButtonStatus.disabled,
                      buttonText: "Save",
                      isGeneralButton: true,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );*/
  }

  Future editSeedSaplingBottomSheet(String title) {
    return showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: AppColors.white,
      //elevates modal bottom screen
      elevation: 10,
      // gives rounded corner to modal bottom screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return SingleChildScrollView(
          child: SizedBox(
            height: 290,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: defaultTheme.textTheme.headline4),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',
                            style: defaultTheme.textTheme.bodyText1!
                                .copyWith(color: AppColors.orange)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const FormFieldTitle(title: "Remarks"),
                  const SizedBox(height: 9),
                  CustomTextField(
                      type: InputFieldTypes.textArea,
                      controller: TextEditingController(),
                      hintText: "Add Remarks",
                      key: const Key('Description')),
                  const SizedBox(height: 18),
                  ButtonTypeOne(
                    key: const Key("Save"),
                    buttonStatus: ButtonStatus.disabled,
                    buttonText: "Save",
                    isGeneralButton: true,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget reminderItem(
      icon, title, subTitle, status, points, date, AppointmentModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              ButtonTypeTwo(
                  buttonText: "Update",
                  onPressed: () {
                    showPopupAlertConfirmDialogForAppointment(
                        "Did the client attend the appointment ?", "Yes", "No",
                        leftButtonTap: () {
                      Get.back();
                      showPopupAlertConfirmDialogForReschedule(
                          "Let’s Reschedule the Appointment",
                          "Reschedule Appointment",
                          "Cancel Appointment", leftButtonTap: () async {
                        Get.back();
                        await leadProfileScreenController
                            .deleteAppointment(model.id.toString());
                        showPopupAlertConfirmDialogForAppointment(
                            "Appointment Cancelled", "Done", "",
                            height: 90,
                            isHideLeftButton: true, leftButtonTap: () {
                          Get.back();
                        }, rightButtonTap: () {
                          Get.back();
                        });
                      }, rightButtonTap: () {
                        Get.back();
                        appointmentAddUpdateBottomSheet(
                            "Reschedule  Appointment", true, model);
                      });
                    }, rightButtonTap: () {
                      Get.back();
                    });
                  }),
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

  Widget activityItem(
      {required String activityType,
      required String title,
      subTitle,
      status,
      points,
      date,
      String? appointmentEndTime,
      required String appointmentID}) {
    debugPrint(appointmentEndTime);
    return InkWell(
      onTap: () {
        /*showPopupAlertDialogForSeedSapling(buttonTap: () {
          Get.back();
          editSeedSaplingBottomSheet("Seed - Sapling");
        });*/
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.profileIconBG,
                    child: SvgPicture.asset(
                      getIconBasedOnActivityType(activityType),
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
                        activityType != 'Appointment'
                            ? const Offstage()
                            : Text(status,
                                style: defaultTheme.textTheme.headline5
                                    ?.copyWith(color: AppColors.orange)),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    activityType != 'Appointment'
                        ? const Offstage()
                        : Text(subTitle,
                            style: defaultTheme.textTheme.bodyText2),
                  ],
                ),
                const Spacer(),
                appointmentEndTime == null
                    ? Column(
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
                      )
                    : (!showUpdateButtonInActivity(appointmentEndTime) &&
                            status != 'Cancelled')
                        ? ButtonTypeTwo(
                            buttonText: "Update",
                            onPressed: () {
                              showPopupAlertConfirmDialogForAppointment(
                                  "Did the client attend the appointment ?",
                                  "Yes",
                                  "No", leftButtonTap: () {
                                // When Tapped on NO
                                Get.back();
                                showPopupAlertConfirmDialogForReschedule(
                                    "Let’s Reschedule the Appointment",
                                    "Reschedule Appointment",
                                    "Cancel Appointment",
                                    leftButtonTap: () async {
                                  // Cancelling the appointment
                                  Get.back();
                                  await leadProfileScreenController
                                      .deleteAppointment(appointmentID);
                                  showPopupAlertConfirmDialogForAppointment(
                                      "Appointment Cancelled", "Done", "",
                                      height: 90, isHideLeftButton: true,
                                      leftButtonTap: () {
                                    Get.back();
                                  }, rightButtonTap: () {
                                    Get.back();
                                  });
                                }, rightButtonTap: () {
                                  // Reschedule the appointment
                                  //TODO:  Get Appointment details with the appointment ID
                                  Get.back();
                                  appointmentAddUpdateBottomSheet(
                                      "Reschedule  Appointment",
                                      true,
                                      AppointmentModel(
                                        id: appointmentID,
                                      )); //TODO: Need to pass model
                                });
                              }, rightButtonTap: () {
                                // TODO: Need to write logic when appointment is attended
                                Get.back();
                              });
                            })
                        : Column(
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
      ),
    );
  }

  //end lead profile activity tab widgets

  //lead profile details tab widgets
  Widget details() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          ButtonTypeThree(
              buttonText: "Basic Details",
              onPressed: () {
                GetControllers.shared
                    .getLeadBasicDetailsScreenController()
                    .settDetailsFromLeadProfileScreen(
                        leadProfileScreenController.leadModel.value);
                Get.toNamed(leadBasicDetailsScreen, arguments: [true]);
              }),
          const SizedBox(
            height: 10,
          ),
          ButtonTypeThree(
              buttonText: "Contacts",
              onPressed: () {
                GetControllers.shared
                    .getLeadContactsScreenController()
                    .setContactUpdateData(
                        leadProfileScreenController.leadModel.value);
                Get.toNamed(leadContactsScreen, arguments: [
                  '',
                  '',
                  leadProfileScreenController.leadModel.value
                ]);
              }),
          const SizedBox(
            height: 10,
          ),
          ButtonTypeThree(
              buttonText: "Personal Details",
              onPressed: () {
                GetControllers.shared
                    .getLeadPersonalDetailsScreenController()
                    .setDetailsFromLeadProfileScreen(
                        leadProfileScreenController.leadModel.value);
                Get.toNamed(leadPersonalDetailsScreen, arguments: [true]);
              }),
          const SizedBox(
            height: 10,
          ),
          ButtonTypeThree(
              buttonText: "Dependants",
              onPressed: () {
                Get.toNamed(leadDependantsScreen, arguments: [
                  '',
                  '',
                  leadProfileScreenController.leadModel.value
                ]);
              }),
          const SizedBox(
            height: 10,
          ),
          ButtonTypeThree(
              buttonText: "Policy Details",
              onPressed: () {
                GetControllers.shared
                    .getPolicyDetailsController()
                    .setPolicyData(leadProfileScreenController.leadModel.value);
                Get.toNamed(policyDetailsScreen);
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //end lead profile activity tab widgets

  //lead profile notes tab widgets
  Widget notes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            //crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonTypeFourWithIcon(
                  icon: "assets/icons/create_note.svg",
                  buttonText: "Create Note",
                  onPressed: () {
                    createNoteBottomSheet("Create Note", false, null);
                  }),
              const SizedBox(
                width: 25,
              ),
              ButtonTypeFourWithIcon(
                  icon: "assets/icons/attachment.svg",
                  buttonText: "Add File",
                  iconHeight: 15,
                  onPressed: () {
                    leadProfileScreenController.getFile();
                  }),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(() => ListView.builder(
              itemCount: leadProfileScreenController.notes.value.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item =
                    leadProfileScreenController.notes.value.elementAt(index);
                return ListTileNote(
                  icon: "assets/icons/filter.svg",
                  title: item.heading.toString(),
                  subTitle: item.note.toString(),
                  onPressedDelete: () {
                    debugPrint("onPressedDelete:: ");
                    leadProfileScreenController.deleteNote(item.id.toString());
                  },
                  onPressedEdit: () {
                    debugPrint("onPressedEdit:: ");
                    createNoteBottomSheet("Edit Note", true, item);
                  },
                );
              })),

          /*const SizedBox(
            height: 10,
          ),
          ListTileNote(
            icon: "assets/icons/attachment.svg",
            title: "Brochure",
            subTitle: "PDF.  2MB",
            isShowEditOption: false,
            onPressedDelete: () {
              debugPrint("onPressedDelete:: ");
            },
            onPressedEdit: () {
              debugPrint("onPressedEdit:: ");
            },
          ),*/
        ],
      ),
    );
  }

  Future createNoteBottomSheet(String title, bool isUpdate, NoteModel? item) {
    if (isUpdate) {
      leadProfileScreenController.headlineTextEditingController.text =
          item!.heading.toString();
      leadProfileScreenController.noteTextEditingController.text =
          item.note.toString();
    }

    return showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: AppColors.white,
      //elevates modal bottom screen
      elevation: 10,
      // gives rounded corner to modal bottom screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return SingleChildScrollView(
          child: SizedBox(
            //height: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: addNoteFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: defaultTheme.textTheme.headline4),
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            leadProfileScreenController.clearFields();
                          },
                          child: Text('Cancel',
                              style: defaultTheme.textTheme.bodyText1!
                                  .copyWith(color: AppColors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Headings"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.fullnameWithClear,
                        controller: leadProfileScreenController
                            .headlineTextEditingController,
                        hintText: "",
                        key: const Key('name')),
                    const SizedBox(height: 24),
                    const FormFieldTitle(title: "Notes"),
                    const SizedBox(height: 9),
                    CustomTextField(
                        type: InputFieldTypes.textArea,
                        controller: leadProfileScreenController
                            .noteTextEditingController,
                        hintText: "Add Notes",
                        key: const Key('Description')),
                    const SizedBox(height: 18),
                    ButtonTypeOne(
                      key: const Key("Save"),
                      buttonStatus: ButtonStatus.enabled,
                      buttonText: isUpdate ? "Update" : "Save",
                      isGeneralButton: true,
                      onPressed: () {
                        debugPrint("create note:: ");
                        if (addNoteFormKey.currentState!.validate()) {
                          Get.back();
                          if (isUpdate) {
                            leadProfileScreenController
                                .updateNote(item!.id.toString());
                          } else {
                            leadProfileScreenController.createNote();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future contactBottomSheet() {
    return showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: AppColors.white,
      //elevates modal bottom screen
      elevation: 10,
      // gives rounded corner to modal bottom screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return SingleChildScrollView(
          child: SizedBox(
            //height: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: addNoteFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contacts",
                            style: defaultTheme.textTheme.headline4),
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            leadProfileScreenController.clearFields();
                          },
                          child: Text('Cancel',
                              style: defaultTheme.textTheme.bodyText1!
                                  .copyWith(color: AppColors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                        //alignment: WrapAlignment.center,
                        children: [
                          if (leadProfileScreenController
                                  .leadModel.value.wholeNumber !=
                              null) ...[
                            contactItem("call", "Phone", () {
                              leadProfileScreenController.addContactActivities(
                                  {'contact_type': 'phone'});
                              launchUrlString("tel:" +
                                  leadProfileScreenController
                                      .leadModel.value.wholeNumber
                                      .toString());
                            }),
                            contactItem("message", "Message", () {
                              leadProfileScreenController.addContactActivities(
                                  {'contact_type': 'message'});
                              launchUrlString("sms:" +
                                  leadProfileScreenController
                                      .leadModel.value.wholeNumber
                                      .toString());
                            }),
                          ],
                          if (leadProfileScreenController
                                  .leadModel.value.email !=
                              null) ...[
                            contactItem("email", "Email", () {
                              leadProfileScreenController.addContactActivities(
                                  {'contact_type': 'email'});
                              launchUrlString("mailto:" +
                                  leadProfileScreenController
                                      .leadModel.value.email
                                      .toString());
                            }),
                            if (leadProfileScreenController
                                    .leadModel.value.socialIds !=
                                null) ...[
                              for (var item in leadProfileScreenController
                                  .leadModel.value.socialIds!)
                                contactItem(item.name.toString(),
                                    item.name.toString().capitalizeFirst!, () {
                                  leadProfileScreenController
                                      .addContactActivities(
                                          {'contact_type': item.name});
                                  String url = "";
                                  switch (item.name.toString()) {
                                    case "facebook":
                                      url =
                                          "https://www.facebook.com/${item.id.toString()}";
                                      break;
                                    case "instagram":
                                      url =
                                          "https://www.instagram.com/${item.id.toString()}";
                                      break;

                                    case "twitter":
                                      url =
                                          "https://twitter.com/${item.id.toString()}";
                                      break;

                                    case "linkedin":
                                      url =
                                          "https://www.linkedin.com/${item.id.toString()}";
                                      break;

                                    case "telegram":
                                      url =
                                          "https://www.telegram.com/${item.id.toString()}";
                                      break;

                                    case "whatsapp":
                                      url =
                                          "https://www.whatsapp.com/${item.id.toString()}";
                                      break;
                                  }
                                  launchUrlString(url);
                                }),
                            ]
                          ],
                          if (leadProfileScreenController
                                      .leadModel.value.socialIds ==
                                  null ||
                              leadProfileScreenController
                                      .leadModel.value.socialIds!.length !=
                                  6) ...[
                            InkWell(
                              onTap: () {
                                Get.back();
                                Get.toNamed(leadContactsScreen, arguments: [
                                  '',
                                  '',
                                  leadProfileScreenController.leadModel.value
                                ]);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(Get.width * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        radius: 22,
                                        backgroundColor:
                                            AppColors.profileIconBG,
                                        child: SvgPicture.asset(
                                          "assets/icons/contact_add.svg",
                                        )),
                                    const SizedBox(height: 5),
                                    Text("Add",
                                        style:
                                            defaultTheme.textTheme.bodyText2),
                                  ],
                                ),
                              ),
                            ),
                          ]
                        ]),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget contactItem(String icon, String title, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.all(Get.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.profileIconBG,
                child: SvgPicture.asset(
                  "assets/icons/$icon.svg",
                )),
            const SizedBox(height: 5),
            Text(title, style: defaultTheme.textTheme.bodyText2),
          ],
        ),
      ),
    );
  }

//end lead profile notes tab widgets

  //This is a functio which is used to get the icon of the activityLisrtile based on the activityType
  String getIconBasedOnActivityType(String activityType) {
    if (activityType == 'Appointment') {
      return 'assets/icons/calender.svg';
    } else if (activityType == 'phone') {
      return 'assets/icons/call.svg';
    } else if (activityType == 'email') {
      return 'assets/icons/email.svg';
    } else if (activityType == 'message') {
      return 'assets/icons/message.svg';
    } else if (activityType == 'facebook') {
      return 'assets/icons/facebook.svg';
    } else if (activityType == 'instagram') {
      return 'assets/icons/instagram.svg';
    } else if (activityType == 'twitter') {
      return 'assets/icons/twitter.svg';
    } else if (activityType == 'linkedin') {
      return 'assets/icons/linkedin.svg';
    } else if (activityType == 'telegram') {
      return 'assets/icons/telegram.svg';
    } else {
      //whatsapp
      return 'assets/icons/whatsapp.svg';
    }
  }

  bool showUpdateButtonInActivity(String dateToCompareWithNow) {
    DateTime date = DateTime.parse(dateToCompareWithNow);
    return date.isAfter(DateTime.now());
  }
}
