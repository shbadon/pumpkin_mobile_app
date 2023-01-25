import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class MyChips extends StatelessWidget {
  MyChips({super.key, required this.chipText, this.isSelected = false});
  String chipText;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Chip(
        label: Text(chipText),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: const BorderSide(color: AppColors.primaryColor)),
        backgroundColor: isSelected
            ? AppColors.primaryColor
            : AppColors.primaryColor.withOpacity(0.15),
        labelStyle: defaultTheme.textTheme.bodyText1!.copyWith(
            color: isSelected ? AppColors.white : AppColors.primaryColor),
      ),
    );
  }
}
