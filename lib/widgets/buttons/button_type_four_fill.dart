import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ButtonTypeFourFill extends StatefulWidget {
  void Function() onPressed;
  String? buttonText;

  ButtonTypeFourFill(
      {Key? key,
      required this.onPressed,
      this.buttonText //Only to give button text when the button a general button
      })
      : super(key: key);

  @override
  State<ButtonTypeFourFill> createState() => _ButtonTypeFourFillState();
}

class _ButtonTypeFourFillState extends State<ButtonTypeFourFill> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.white,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Text(widget.buttonText ?? 'Add',
            style: defaultTheme.textTheme.bodyText1!.copyWith(
                color: AppColors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
