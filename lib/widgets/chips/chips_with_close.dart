import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class MyChipWithClose extends StatelessWidget {
  MyChipWithClose(
      {super.key,
      required this.chipText,
      this.onDelete,
      this.labelStyle,
      this.backgroundColor,
      this.borderColor});
  String chipText;
  Function()? onDelete;
  TextStyle? labelStyle;
  Color? backgroundColor;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
      child: Chip(
        label: Text(chipText),
        deleteIcon: const Icon(Icons.close),
        deleteIconColor: AppColors.primaryColor,
        onDeleted: onDelete,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(color: borderColor ?? Colors.transparent)),
        backgroundColor:
            backgroundColor ?? AppColors.primaryColor.withOpacity(0.15),
        labelStyle: labelStyle ??
            defaultTheme.textTheme.bodyText1!
                .copyWith(color: AppColors.primaryColor),
      ),
    );
  }
}
