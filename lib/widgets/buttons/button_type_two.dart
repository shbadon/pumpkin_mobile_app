import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ButtonTypeTwo extends StatefulWidget {
  void Function() onPressed;
  String? buttonText;

  ButtonTypeTwo(
      {Key? key,
      required this.onPressed,
      this.buttonText //Only to give button text when the button a general button
      })
      : super(key: key);

  @override
  State<ButtonTypeTwo> createState() => _ButtonTypeTwoState();
}

class _ButtonTypeTwoState extends State<ButtonTypeTwo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.orange,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(widget.buttonText ?? 'Add',
            style: defaultTheme.textTheme.bodyText1!.copyWith(
                color: AppColors.orange, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
