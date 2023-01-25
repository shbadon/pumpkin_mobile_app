import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class CertificateAndAwardCardWidget extends StatelessWidget {
  CertificateAndAwardCardWidget(
      {super.key, required this.name, required this.year, this.onPressed});
  String name;
  String year;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor, width: 1.0),
          borderRadius: const BorderRadius.all(
              Radius.circular(10) //                 <--- border radius here
              )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: defaultTheme.textTheme.bodyText1,
                ),
                Text(
                  year,
                  style: defaultTheme.textTheme.bodyText1,
                )
              ],
            ),
          ),
          IconButton(
              onPressed: onPressed,
              icon: SvgPicture.asset('assets/icons/delete_icon.svg'))
        ],
      ),
    );
  }
}
