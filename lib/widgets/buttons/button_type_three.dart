import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ButtonTypeThree extends StatefulWidget {
  void Function() onPressed;
  String? buttonText;
  TextStyle? textStyle;
  bool isDisableButton;

  ButtonTypeThree(
      {Key? key,
      required this.onPressed,
        this.isDisableButton = false,
      this.buttonText //Only to give button text when the button a general button
      })
      : super(key: key);

  @override
  State<ButtonTypeThree> createState() => _ButtonTypeThreeState();
}

class _ButtonTypeThreeState extends State<ButtonTypeThree> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: InkWell(onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderColor,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.buttonText ?? "Button Name",
                textAlign: TextAlign.center,
                style: widget.textStyle ?? defaultTheme.textTheme.bodyText1!.copyWith(
                  color: widget.isDisableButton ? AppColors.otpBG : AppColors.black.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: widget.isDisableButton ? AppColors.borderColor : AppColors.darkIconcolor,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      )
    );
  }
}
