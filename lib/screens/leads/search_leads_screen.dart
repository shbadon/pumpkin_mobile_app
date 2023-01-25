import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/search_leads_screen_controller.dart';
import 'package:pumpkin/utils/date_format.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';
import 'package:pumpkin/widgets/listTile/list_tile_one.dart';
import 'package:pumpkin/widgets/loader.dart';

// ignore: must_be_immutable
class SearchLeadScreen extends StatelessWidget {
  SearchLeadScreen({super.key});
  SearchLeadsScreenController searchLeadsScreenController =
      GetControllers.shared.getLeadsScreenController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    searchField(),
                    searchLeadsScreenController.leadList.length.isEqual(0)
                        ? const Offstage()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            shrinkWrap: true,
                            itemCount:
                                searchLeadsScreenController.leadList.length,
                            itemBuilder: (context, index) {
                              return ListTileOne(
                                isActive: searchLeadsScreenController
                                    .leadList[index].status,
                                leadImageUrl: searchLeadsScreenController
                                    .leadList[index].photo,
                                leadName:
                                    "${searchLeadsScreenController.leadList[index].firstName}"
                                    " ${searchLeadsScreenController.leadList[index].lastName}",
                                createdDate: formatDateToDDMMYYYY(
                                    searchLeadsScreenController
                                        .leadList[index].createdDate!),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Get.toNamed(leadProfileScreen, arguments: [
                                    searchLeadsScreenController
                                        .leadList[index].id
                                        .toString()
                                  ]);
                                },
                              );
                            })
                  ],
                ),
              ),
            ),
            searchLeadsScreenController.isLoading.value
                ? const Loader()
                : const Offstage()
          ],
        ),
      ),
    );
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: CustomTextField(
                type: InputFieldTypes.textWitoutValidation,
                hintText: 'Search Lead',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    'assets/icons/search_icon.svg',
                  ),
                ),
                onChanged: (value) {
                  searchLeadsScreenController.searchLeads(value);
                },
                controller:
                    searchLeadsScreenController.searchTextEditingController),
          ),
          Expanded(
              child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ))
        ],
      ),
    );
  }
}
