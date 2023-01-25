import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ListTileOne extends StatelessWidget {
  String leadName;
  String createdDate;
  bool isActive;
  String? leadImageUrl;
  Function()? onTap;

  ListTileOne(
      {super.key,
      required this.leadName,
      required this.createdDate,
      this.isActive = false,
      this.leadImageUrl,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        height: 50,
        width: 45,
        child: Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: AppColors.fourthColor,
                backgroundImage:
                    leadImageUrl != null ? NetworkImage(leadImageUrl!) : null,
                child: leadImageUrl == null
                    ? Center(
                        child: Text(leadName.toUpperCase().split('').first),
                      )
                    : null,
              ),
            ),
            Positioned(
              top: 35,
              left: 31,
              height: 15,
              width: 15,
              child: Container(
                height: 15,
                decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(color: AppColors.scaffoldColor),
                        bottom: BorderSide(color: AppColors.scaffoldColor),
                        left: BorderSide(color: AppColors.scaffoldColor),
                        right: BorderSide(color: AppColors.scaffoldColor)),
                    shape: BoxShape.circle,
                    color:
                        isActive ? AppColors.validColor : AppColors.errorColor),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        leadName,
        style: defaultTheme.textTheme.bodyText1!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Created date: $createdDate',
        style:
            defaultTheme.textTheme.bodyText1!.copyWith(color: AppColors.iconBG),
      ),
      trailing: const Icon(
        Icons.chevron_right_outlined,
        color: AppColors.iconBG,
      ),
    );
  }
}
