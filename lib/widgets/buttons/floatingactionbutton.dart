import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class FloatingActionButtonCustom extends StatefulWidget {
  FloatingActionButtonCustom({
    super.key,
    required this.itemsList,
    required this.onPress,
    required this.animation,
  });
  List<Bubble> itemsList;
  void Function() onPress;
  Animation<dynamic> animation;

  @override
  State<FloatingActionButtonCustom> createState() =>
      _FloatingActionButtonCustomState();
}

class _FloatingActionButtonCustomState
    extends State<FloatingActionButtonCustom> {
  @override
  Widget build(BuildContext context) {
    widget.animation.addListener(() {
      setState(() {});
    });
    return FloatingActionBubble(
        iconData: (widget.animation.status == AnimationStatus.forward) ||
                (widget.animation.status == AnimationStatus.completed)
            ? Icons.close
            : Icons.add,
        items: widget.itemsList,
        onPress: widget.onPress,
        iconColor: AppColors.white,
        backGroundColor: (widget.animation.status == AnimationStatus.forward) ||
                (widget.animation.status == AnimationStatus.completed)
            ? AppColors.fourthColor
            : AppColors.primaryColor,
        animation: widget.animation);
  }
}
