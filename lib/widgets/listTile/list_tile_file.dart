import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ListTileFile extends StatelessWidget {
  ListTileFile(
      {super.key,
      required this.fileName,
      required this.fileDate,
      required this.fileTime,
      required this.fileStatus,
      this.onTap});
  String fileName;
  String fileDate;
  String fileTime;
  String fileStatus;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.iconBG.withOpacity(0.2)),
                top: BorderSide(color: AppColors.iconBG.withOpacity(0.2)),
                left: BorderSide(color: AppColors.iconBG.withOpacity(0.2)),
                right: BorderSide(color: AppColors.iconBG.withOpacity(0.2))),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.iconBG.withOpacity(0.2),
                    child: SvgPicture.asset('assets/icons/file_icon.svg')),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(fileName,
                        overflow: TextOverflow.ellipsis,
                        style: defaultTheme.textTheme.bodyText2),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fileStatus.toUpperCase(),
                  style: defaultTheme.textTheme.bodyText2!.copyWith(
                      color: fileStatus == 'processing'
                          ? AppColors.primaryColor
                          : fileStatus == 'completed'
                              ? AppColors.validColor
                              : AppColors.errorColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      fileDate,
                      style: defaultTheme.textTheme.bodyText2,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      fileTime,
                      style: defaultTheme.textTheme.bodyText2,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
