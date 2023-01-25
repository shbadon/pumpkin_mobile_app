import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ButtonTypeFourWithIcon extends StatefulWidget {
  void Function() onPressed;
  String? buttonText;
  String icon;
  double? iconHeight;

  ButtonTypeFourWithIcon(
      {Key? key,
      required this.onPressed,
      required this.icon,
        this.iconHeight = 24,
      this.buttonText //Only to give button text when the button a general button
      })
      : super(key: key);

  @override
  State<ButtonTypeFourWithIcon> createState() => _ButtonTypeFourWithIconState();
}

class _ButtonTypeFourWithIconState extends State<ButtonTypeFourWithIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Row(
        children: [
          SvgPicture.asset(
            widget.icon,
            height: widget.iconHeight,
            color: AppColors.orange,
          ),
          const SizedBox(
            width: 7,
          ),
          Text(widget.buttonText ?? 'Add',
              style: defaultTheme.textTheme.bodyText1!.copyWith(
                  color: AppColors.orange, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
