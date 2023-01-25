import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/manage_tags_screen_controller.dart';
import 'package:pumpkin/controllers/tags_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';
import 'package:pumpkin/widgets/dialog/popupAlertDialog.dart';
import 'package:pumpkin/widgets/listTile/list_tile_tags.dart';

class ManageTagsScreen extends StatefulWidget {
  const ManageTagsScreen({super.key});

  @override
  State<ManageTagsScreen> createState() => _ManageTagsScreenState();
}

class _ManageTagsScreenState extends State<ManageTagsScreen> {
  ManageTagsScreenController manageTagsScreenController =
      GetControllers.shared.getManageTagsScreenController();
  TagsController tagsController = GetControllers.shared.getTagsController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.chevron_left)),
                        Text('Manage Tags',
                            style: defaultTheme.textTheme.headline3),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Obx(
                      () => tagsController.tagsRespnseModel.value.tags == null
                          ? const Offstage()
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                  bottom:
                                      100), //This is show the items which are hidden behind the button
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tagsController
                                  .tagsRespnseModel.value.tags!.length,
                              itemBuilder: (context, index) {
                                return ListTileTags(
                                  text: tagsController.tagsRespnseModel.value
                                      .tags![index].name!,
                                  iconOne: IconButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        manageTagsScreenController
                                                .tagsEditTextEditingController
                                                .text =
                                            tagsController.tagsRespnseModel
                                                .value.tags![index].name!;
                                        showPopupAlertForEditTag(
                                            'Edit Tag',
                                            manageTagsScreenController
                                                .tagsEditTextEditingController,
                                            'Save',
                                            'Cancel', rightButtonTap: () {
                                          Map<String, dynamic> body = {
                                            'name': manageTagsScreenController
                                                .tagsEditTextEditingController
                                                .text
                                          };
                                          tagsController.editTags(
                                              tagsController.tagsRespnseModel
                                                  .value.tags![index].id
                                                  .toString(),
                                              body,
                                              context);
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icons/edit_icon.svg')),
                                  iconTwo: IconButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        showPopupAlertConfirmDialog(
                                            'Delete',
                                            'Are you sure you want to delete this tag?',
                                            'Delete',
                                            'Cancel', rightButtonTap: () {
                                          tagsController.deleteTag(
                                              tagsController.tagsRespnseModel
                                                  .value.tags![index].id
                                                  .toString(),
                                              context);
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icons/delete_icon.svg')),
                                );
                              }),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ButtonTypeOne(
                        onPressed: () {
                          Get.back();
                        },
                        isGeneralButton: true,
                        buttonStatus: ButtonStatus.enabled,
                        buttonText: 'Save',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
