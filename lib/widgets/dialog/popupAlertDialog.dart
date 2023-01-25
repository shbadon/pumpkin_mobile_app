import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'package:pumpkin/widgets/buttons/button_type_four_fill.dart';
import 'package:pumpkin/widgets/forms/custom_form_field_title.dart';
import 'package:pumpkin/widgets/forms/custom_text_field.dart';

void showPopupAlertConfirmDialog(title, body, rightButtonText, leftButtonTex,
    {required Function rightButtonTap, double height = 120}) {
  Get.defaultDialog(
      contentPadding: EdgeInsets.zero,
      title: "",
      content: Material(
          child: SizedBox(
        width: Get.width * 0.9,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: defaultTheme.textTheme.headline3,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                body,
                maxLines: 2,
                style: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.pointTableBodyColor),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(leftButtonTex,
                          style: defaultTheme.textTheme.headline5!
                              .copyWith(color: AppColors.orange)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      rightButtonTap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Text(rightButtonText,
                              style: defaultTheme.textTheme.headline5!
                                  .copyWith(color: AppColors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )));
}

void showPopupAlertConfirmDialogForAppointment(
    title, rightButtonText, leftButtonTex,
    {required Function rightButtonTap,
    required Function leftButtonTap,
    bool isHideLeftButton = false,
    double height = 110}) {
  Get.defaultDialog(
      contentPadding: EdgeInsets.zero,
      title: "",
      content: Material(
          child: SizedBox(
        width: Get.width * 0.9,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: defaultTheme.textTheme.headline4,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isHideLeftButton) ...[
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        leftButtonTap();
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
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(leftButtonTex,
                            style: defaultTheme.textTheme.headline5!
                                .copyWith(color: AppColors.orange)),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    )
                  ],
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      rightButtonTap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 30),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Text(rightButtonText,
                              style: defaultTheme.textTheme.headline5!
                                  .copyWith(color: AppColors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )));
}

void showPopupAlertConfirmDialogForReschedule(
    title, rightButtonText, leftButtonTex,
    {required Function rightButtonTap,
    required Function leftButtonTap,
    bool isHideLeftButton = false,
    double height = 140}) {
  Get.defaultDialog(
      contentPadding: EdgeInsets.zero,
      title: "",
      content: Material(
          child: SizedBox(
        width: Get.width * 0.9,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: defaultTheme.textTheme.headline4,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      rightButtonTap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(rightButtonText,
                          style: defaultTheme.textTheme.headline5!
                              .copyWith(color: AppColors.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  !isHideLeftButton
                      ? InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            leftButtonTap();
                          },
                          child: Text(leftButtonTex,
                              style: defaultTheme.textTheme.headline5!
                                  .copyWith(color: AppColors.orange)),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      )));
}

void showPopupAlertDialogForSeedDone(TextEditingController remarks,
    {required Function buttonTap, required BuildContext context}) {
  showDialog(
    context: context,
    useSafeArea: false,
    builder: (_) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
            width: Get.width * 0.9,
            height: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(seedStatus),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const FormFieldTitle(title: "Status changed to"),
                      const SizedBox(height: 9),
                      Text(
                        "Seed",
                        style: defaultTheme.textTheme.headline1,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: CustomTextField(
                            type: InputFieldTypes.textArea,
                            controller: remarks,
                            hintText: "Remarks",
                            key: const Key('Remarks')),
                      ),
                      const SizedBox(height: 24),
                      ButtonTypeFourFill(
                        key: const Key("Save"),
                        buttonText: "Done",
                        onPressed: () {
                          buttonTap();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

void showPopupAlertDialogForSeedSapling({required Function buttonTap}) {
  Get.defaultDialog(
      contentPadding: EdgeInsets.zero,
      title: "",
      content: Material(
          child: SizedBox(
        width: Get.width * 0.9,
        height: 290,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: AppColors.pointTableBodyColor,
                    ),
                  )),
              Text(
                "Seed to Sapling",
                style: defaultTheme.textTheme.headline3,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Jan 20, 10:30 am",
                style: defaultTheme.textTheme.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Get.width * 0.7,
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetuerLorem ipsum dolor sit amet, consectetuer adipiscing elit. commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis. penatibus et magnis dis.",
                  maxLines: 10,
                  style: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.pointTableBodyColor),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  buttonTap();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Edit Remarks",
                      style: defaultTheme.textTheme.headline5!
                          .copyWith(color: AppColors.orange)),
                ),
              ),
            ],
          ),
        ),
      )));
}

void showPopupAlertForEditTag(title,
    TextEditingController textEditingController, rightButtonText, leftButtonTex,
    {required Function rightButtonTap, double height = 120}) {
  Get.defaultDialog(
      contentPadding: EdgeInsets.zero,
      title: "",
      content: Material(
          child: SizedBox(
        width: Get.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: defaultTheme.textTheme.headline3,
              ),
              const SizedBox(
                height: 15,
              ),
              const FormFieldTitle(title: "Tag"),
              const SizedBox(height: 9),
              CustomTextField(
                  type: InputFieldTypes.textWitoutValidation,
                  hintText: "Enter new tag",
                  controller: textEditingController,
                  key: const Key('tag')),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Get.back();
                      textEditingController.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(leftButtonTex,
                          style: defaultTheme.textTheme.headline5!
                              .copyWith(color: AppColors.orange)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      rightButtonTap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Text(rightButtonText,
                              style: defaultTheme.textTheme.headline5!
                                  .copyWith(color: AppColors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )));
}

showGeneralDialogue({required BuildContext context, required Widget body}) {
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (_) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return body;
        },
      ),
    ),
  );
}
