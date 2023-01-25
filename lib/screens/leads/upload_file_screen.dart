import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/controllers/leads/upload_file_screen_controller.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/date_format.dart';
import 'package:pumpkin/widgets/dialog/popupAlertDialog.dart';
import 'package:pumpkin/widgets/listTile/list_tile_file.dart';

class UploadFileScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  UploadFileScreenController uploadFileScreenController =
      GetControllers.shared.getUploadFileScreenController();

  @override
  void initState() {
    uploadFileScreenController.getFilesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Appbar
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: AppColors.darkIconcolor,
                          )),
                      Text('Upload File',
                          style: defaultTheme.textTheme.headline3),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.file_download_outlined,
                          color: AppColors.primaryColor,
                        ),
                        Text(
                          'Download Sample file',
                          style: defaultTheme.textTheme.headline5!
                              .copyWith(color: AppColors.primaryColor),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    indent: 30,
                    endIndent: 30,
                    color: AppColors.iconBG,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      uploadFileScreenController.getFile();
                    },
                    child: Obx(
                      () => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.iconBG)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            uploadFileScreenController.isUploading.value
                                ? SvgPicture.asset(
                                    'assets/icons/file_icon_primary_colour.svg')
                                : SvgPicture.asset(
                                    'assets/icons/upload_file_primary_color.svg'),
                            uploadFileScreenController.isUploading.value
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      uploadFileScreenController.fileName.value,
                                      style: defaultTheme.textTheme.headline5!
                                          .copyWith(
                                              color: AppColors.primaryColor),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Upload file here',
                                      style: defaultTheme.textTheme.headline5!
                                          .copyWith(
                                              color: AppColors.primaryColor),
                                    ),
                                  ),
                            uploadFileScreenController.isUploading.value
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    child: LinearProgressIndicator(
                                      color: AppColors.primaryColor,
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.5),
                                    ),
                                  )
                                : const Offstage()
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      // TODOD: On tap open a doc
                    },
                    child: Text(
                      'Please refer to upload guidline ',
                      style: defaultTheme.textTheme.headline5!.copyWith(
                          color: AppColors.iconBG,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height * 0.47,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.iconBG.withOpacity(0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 5,
                  spreadRadius: 2),
              BoxShadow(
                  color: AppColors.iconBG.withOpacity(0.3),
                  offset: const Offset(-1, -1),
                  blurRadius: 10,
                  spreadRadius: 5)
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 40, 0, 10),
                child: Text(
                  'File Status',
                  style: defaultTheme.textTheme.headline3,
                ),
              ),
              Obx(
                () => Expanded(
                    flex: 9,
                    child: RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        uploadFileScreenController.getFilesList();
                      },
                      child: ListView.builder(
                          itemCount:
                              uploadFileScreenController.filesList.length,
                          itemBuilder: (context, index) {
                            return ListTileFile(
                                onTap: uploadFileScreenController
                                            .filesList[index].status ==
                                        'processing'
                                    ? () {
                                        showGeneralDialogue(
                                            context: context,
                                            body: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: SvgPicture.asset(
                                                              'assets/icons/file_icon_primary_colour.svg'),
                                                        ),
                                                        const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    'Processing',
                                                    style: defaultTheme
                                                        .textTheme.headline3,
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Text(
                                                    'The file has been successfully uploaded. We are processing the file. You will get a notification upon completion.',
                                                    style: defaultTheme
                                                        .textTheme.bodyText1!
                                                        .copyWith(
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            color: AppColors
                                                                .iconBG),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                ],
                                              ),
                                            ));
                                      }
                                    : null,
                                fileName: uploadFileScreenController
                                        .filesList[index].fileName ??
                                    '-',
                                fileDate: formatDateToDDMMYYYY(
                                    uploadFileScreenController
                                        .filesList[index].createdAt!),
                                fileTime: formatTimeToHHMM(
                                    uploadFileScreenController
                                        .filesList[index].createdAt!),
                                fileStatus: uploadFileScreenController
                                    .filesList[index].status!);
                          }),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
