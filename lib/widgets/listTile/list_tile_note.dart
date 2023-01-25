import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ListTileNote extends StatefulWidget {
  void Function() onPressedDelete;
  void Function() onPressedEdit;
  String? title;
  String? subTitle;
  TextStyle? textStyle;
  String icon;
  bool? isShowEditOption;

  ListTileNote(
      {Key? key,
      required this.onPressedDelete,
      required this.onPressedEdit,
      required this.icon,
      this.isShowEditOption = true,
      this.title, //Only to give button text when the button a general button
      this.subTitle,
      this.textStyle})
      : super(key: key);

  @override
  State<ListTileNote> createState() => _ListTileNoteState();
}

class _ListTileNoteState extends State<ListTileNote> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    widget.icon,
                    height: 12,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.title ?? "Title",
                    textAlign: TextAlign.center,
                    style: widget.textStyle ??
                        defaultTheme.textTheme.headline5!.copyWith(
                          color: AppColors.black.withOpacity(0.8),
                        ),
                  ),
                  const Spacer(),
                  PopupMenuButton<int>(
                    icon: const CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.profileIconBG,
                        child: Icon(
                          Icons.more_vert,
                          color: AppColors.bottomNavigationBarColor,
                          size: 20,
                        )),
                    onSelected: (value) {
                      if (value == 1) {
                        widget.onPressedEdit();
                      }

                      if (value == 2) {
                        widget.onPressedDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      // popupmenu item 1
                      if (widget.isShowEditOption!) ...[
                        PopupMenuItem(
                          enabled: widget.isShowEditOption!,
                          value: 1,
                          height: 35,
                          // row has two child icon and text.
                          child: Row(
                            children: [
                              Text("Edit",
                                  style: widget.textStyle ??
                                      defaultTheme.textTheme.bodyText1!
                                          .copyWith(
                                        color: AppColors.black.withOpacity(0.8),
                                      ))
                            ],
                          ),
                        ),
                      ],
                      // popupmenu item 2
                      PopupMenuItem(
                        value: 2,
                        height: 35,
                        child: Row(
                          children: [
                            Text("Delete",
                                style: widget.textStyle ??
                                    defaultTheme.textTheme.headline5!.copyWith(
                                      color: AppColors.black.withOpacity(0.8),
                                    ))
                          ],
                        ),
                      ),
                    ],
                    //offset: Offset(0, 100),
                    //color: Colors.grey,
                    elevation: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width * 0.64,
                child: Text(
                  widget.subTitle ?? "",
                  textAlign: TextAlign.start,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: widget.textStyle ??
                      defaultTheme.textTheme.bodyText1!.copyWith(
                        color:
                            AppColors.bottomNavigationBarUnselectedLabelColor,
                      ),
                ),
              ),
            ],
          ),
        ));
  }
}
