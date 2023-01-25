// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/leads_screen_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/date_format.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/listTile/list_tile_one.dart';

class LeadListSeedScreen extends StatelessWidget {
  LeadListSeedScreen({super.key});
  LeadsScreenController leadsScreenController =
      GetControllers.shared.getLeadListScreenController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => leadsScreenController.leadList.isNotEmpty
          ? RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                leadsScreenController.getLeads('seed');
              },
              child: ListView.builder(
                  controller: leadsScreenController.scrollController,
                  itemCount: leadsScreenController.leadList.length,
                  itemBuilder: (context, index) {
                    return ListTileOne(
                      isActive: leadsScreenController.leadList[index].status,
                      leadImageUrl: leadsScreenController.leadList[index].photo,
                      leadName:
                          "${leadsScreenController.leadList[index].firstName}"
                          " ${leadsScreenController.leadList[index].lastName}",
                      createdDate: formatDateToDDMMYYYY(
                          leadsScreenController.leadList[index].createdDate!),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Get.toNamed(leadProfileScreen, arguments: [
                          leadsScreenController.leadList[index].id.toString()
                        ])!
                            .then((value) {
                          leadsScreenController.getLeads('seed');
                        });
                      },
                    );
                  }),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/no_lead_image.svg'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // TODO: Need to add function
                        },
                        child: Text(
                          'Add Leads',
                          style: defaultTheme.textTheme.bodyText1!
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      Text(' or ', style: defaultTheme.textTheme.bodyText1),
                      InkWell(
                        onTap: () {
                          // TODO: Need to add function
                        },
                        child: Text(
                          'Upload a File',
                          style: defaultTheme.textTheme.bodyText1!
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
