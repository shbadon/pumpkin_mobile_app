import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/widgets/forms/expandable_overlay_widget.dart';

class DropdownFormField extends StatefulWidget {
  final List<String> list;
  final TextEditingController selectedValueController;
  final ExpandableOverlayWidgetController? overlayWidgetController;
  const DropdownFormField(
      {Key? key, required this.list, required this.selectedValueController, required this.overlayWidgetController})
      : super(key: key);

  @override
  State<DropdownFormField> createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  ValueNotifier<String> selectedValueNotifier = ValueNotifier('');
  ValueNotifier<bool> iconAnimationNotifier = ValueNotifier(false);

  @override
  void initState() {
    selectedValueNotifier.value = widget.selectedValueController.text;
    debugPrint("selectedValueController:: "+widget.selectedValueController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.overlayWidgetController!.isVisible) {
          widget.overlayWidgetController!.hide();
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
          controller: widget.overlayWidgetController!,
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
            builder: (BuildContext context, String value, Widget? child) {
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
                      value,
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
        ),
      ),
    );
  }

  Widget item({required String value, required bool isOdd}) {
    return InkWell(
      onTap: () {
        selectedValueNotifier.value = value;
        widget.selectedValueController.text = value;
        widget.overlayWidgetController!.hide();
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
          value,
          style: defaultTheme.textTheme.bodyText1!.copyWith(
              color: selectedValueNotifier.value == value
                  ? AppColors.orange
                  : AppColors.textFieldTitleColor),
        ),
      ),
    );
  }
}
