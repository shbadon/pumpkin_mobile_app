import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';

class DropdownEnumFieldObx extends StatefulWidget {
  final List<EnumResponseModel> list;
  final Rx<EnumResponseModel> initialEnum;

  const DropdownEnumFieldObx(
      {Key? key, required this.list, required this.initialEnum})
      : super(key: key);

  @override
  State<DropdownEnumFieldObx> createState() => _DropdownEnumFieldObxState();
}

class _DropdownEnumFieldObxState extends State<DropdownEnumFieldObx> {
  final overlayWidgetController = ExpandableOverlayWidgetController();
  ValueNotifier<EnumResponseModel> selectedValueNotifier =
      ValueNotifier(EnumResponseModel());
  ValueNotifier<bool> iconAnimationNotifier = ValueNotifier(false);

  @override
  void initState() {
    selectedValueNotifier.value = widget.initialEnum.value;
    debugPrint("selected enum des:: " +
        widget.initialEnum.value.description.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        if (overlayWidgetController.isVisible) {
          overlayWidgetController.hide();
          return false;
        }

        return true;
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 1.0),
            borderRadius: const BorderRadius.all(
                Radius.circular(10) //                 <--- border radius here
                )),
        child: ExpandableOverlayWidget(
          controller: overlayWidgetController,
          elevation: 4,
          //shadowColor: AppColors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: AppColors.white,
          duration: const Duration(milliseconds: 280),
          gap: 4,
          onStatesChange: (value) {
            iconAnimationNotifier.value = value;
          },
          parentWidget: ValueListenableBuilder(
            valueListenable: selectedValueNotifier,
            builder:
                (BuildContext context, EnumResponseModel value, Widget? child) {
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      value.description.toString(),
                      style: defaultTheme.textTheme.bodyText1!
                          .copyWith(color: AppColors.textFieldTitleColor),
                    )),
                    ValueListenableBuilder(
                      valueListenable: iconAnimationNotifier,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return AnimatedRotation(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.fastOutSlowIn,
                          turns: value ? 0.50 : 0.0,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.pointTableBodyColor,
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
          overlayWidget: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            //padding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(maxHeight: 165),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: true,
                itemCount: widget.list.length,
                itemBuilder: (_, index) {
                  return item(
                      isOdd: index == 0 ? true : false,
                      value: widget.list[index]);
                }),
          ),
        )),
    );
  }

  Widget item({required EnumResponseModel value, required bool isOdd}) {
    return InkWell(
      onTap: () {

        selectedValueNotifier.value = value;
        widget.initialEnum.value.code = value.code;
        widget.initialEnum.value.description = value.description;

        overlayWidgetController.hide();
      },
      //style: AppButtonStyles.flat,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        decoration: BoxDecoration(
          color: selectedValueNotifier.value == value
              ? AppColors.orange.withOpacity(0.3)
              : AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value.description.toString(),
          style: defaultTheme.textTheme.bodyText1!.copyWith(
              color: selectedValueNotifier.value == value
                  ? AppColors.orange
                  : AppColors.textFieldTitleColor),
        ),
      ),
    );
  }
}
