import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class ListTileDependant extends StatefulWidget {
  void Function() onPressedDelete;
  void Function() onPressedEdit;
  String? name;
  String? email;
  String? phone;
  String? relation;
  TextStyle? textStyle;
  String icon;
  bool? isShowEditOption;

  ListTileDependant(
      {Key? key,
      required this.onPressedDelete,
      required this.onPressedEdit,
      required this.icon,
      this.isShowEditOption = true,
      this.name, //Only to give button text when the button a general button
      this.email,
      this.phone,
      this.relation,
      this.textStyle})
      : super(key: key);

  @override
  State<ListTileDependant> createState() => _ListTileDependantState();
}

class _ListTileDependantState extends State<ListTileDependant> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressedDelete,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderColor,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.name ?? "Title",
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
              const Divider(
                height: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name : ",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText2!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarUnselectedLabelColor,
                                ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Email Address : ",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText2!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarUnselectedLabelColor,
                                ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Mobile Number :",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText2!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarUnselectedLabelColor,
                                ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Relation :",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText2!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarUnselectedLabelColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name ?? "",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText1!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarColor,
                                ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            widget.email ?? "",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText1!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarColor,
                                ),
                          ),


                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            widget.phone ?? "",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText1!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarColor,
                                ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            widget.relation ?? "",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.textStyle ??
                                defaultTheme.textTheme.bodyText1!.copyWith(
                                  color: AppColors
                                      .bottomNavigationBarColor,
                                ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),

              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
