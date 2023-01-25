import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircleImageButton extends StatelessWidget {
  Function()? onTap;
  String image;
  CircleImageButton({Key? key, this.onTap, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Image.asset(
          image,
          width: 62,
          height: 62,
        ));
  }
}
