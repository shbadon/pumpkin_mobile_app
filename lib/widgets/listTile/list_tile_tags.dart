import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ListTileTags extends StatelessWidget {
  String text;
  Widget? iconOne;
  Widget? iconTwo;
  ListTileTags({super.key, required this.text, this.iconOne, this.iconTwo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.iconBG.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: defaultTheme.textTheme.bodyText1!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [iconOne ?? Container(), iconTwo ?? Container()],
          )
        ],
      ),
    );
  }
}
