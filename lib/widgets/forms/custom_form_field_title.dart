import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

class FormFieldTitle extends StatelessWidget {
  const FormFieldTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: defaultTheme.textTheme.bodyText1!
          .copyWith(color: AppColors.textFieldTitleColor),
    );
  }
}
