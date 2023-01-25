import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pumpkin/utils/colors.dart';

showErrorToast(String message) {
  return Future.delayed(const Duration(milliseconds: 500), () {
    FocusManager.instance.primaryFocus!.unfocus();
    Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      msg: message,
      backgroundColor: AppColors.errorColor,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  });
}

showInfoToast(String message) {
  return Future.delayed(const Duration(milliseconds: 500), () {
    FocusManager.instance.primaryFocus!.unfocus();
    Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      msg: message,
      backgroundColor: AppColors.iconBG,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  });
}


showSuccessToast(String message) {
  return Future.delayed(const Duration(milliseconds: 500), () {
    FocusManager.instance.primaryFocus!.unfocus();
    Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      msg: message,
      backgroundColor:Colors.green,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  });
}