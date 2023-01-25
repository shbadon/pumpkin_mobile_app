import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pumpkin/utils/strings.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Lottie.asset(loaderAsset))),
    );
  }
}
