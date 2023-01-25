import 'package:flutter/material.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/enums.dart';

// ignore: must_be_immutable
class ButtonTypeOne extends StatefulWidget {
  void Function()? onPressed;
  MaterialStatesController? materialStatesController;
  ButtonStatus? buttonStatus;
  bool isGeneralButton;
  String? buttonText;
  String? disabledButtonText;
  String? enabledButtonText;
  String? verifyingButtonText;
  String? verifiedButtonText;
  String? errorButtonText;

  ButtonTypeOne(
      {Key? key,
      this.onPressed,
      this.materialStatesController,
      this.buttonStatus = ButtonStatus.enabled,
      this.isGeneralButton =
          true, //This boolean check is to check that if this button is used for general use or the it is being used in the OTP verification screen
      this.buttonText, //Only to give button text when the button a general button
      this.disabledButtonText,
      this.enabledButtonText,
      this.verifiedButtonText,
      this.verifyingButtonText,
      this.errorButtonText})
      : super(key: key);

  @override
  State<ButtonTypeOne> createState() => _ButtonTypeOneState();
}

class _ButtonTypeOneState extends State<ButtonTypeOne> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
              statesController: widget.materialStatesController,
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonBorderRadius)),
                  backgroundColor: widget.isGeneralButton
                      ? AppColors.primaryColor
                      : _getButtonColor(widget.buttonStatus!),
                  textStyle: defaultTheme.textTheme.button),
              onPressed: widget.buttonStatus == ButtonStatus.enabled
                  ? widget.onPressed
                  : null,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: widget.isGeneralButton
                      ? Text(
                          widget.buttonText ?? '',
                          style: defaultTheme.textTheme.button,
                        )
                      : _getText(widget.buttonStatus!))),
        ),
      ),
    );
  }

  // A function that is used for displaying the button color based on the logic of the type of the button
  Color _getButtonColor(ButtonStatus status) {
    if (status == ButtonStatus.disabled) {
      return AppColors.disabledColor;
    } else if (status == ButtonStatus.enabled) {
      return AppColors.primaryColor;
    } else if (status == ButtonStatus.verifying) {
      return AppColors.primaryColor;
    } else if (status == ButtonStatus.error) {
      return AppColors.errorColor;
    } else {
      return AppColors.validColor;
    }
  }

  // A function that is used for displaying the text based on the logic of the type of the button
  Widget _getText(ButtonStatus status) {
    if (status == ButtonStatus.disabled) {
      return Text(
        widget.disabledButtonText ?? '',
        style: defaultTheme.textTheme.button,
      );
    } else if (status == ButtonStatus.enabled) {
      return Text(
        widget.enabledButtonText ?? '',
        style: defaultTheme.textTheme.button,
      );
    } else if (status == ButtonStatus.verifying) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.verifyingButtonText ?? '',
            style: defaultTheme.textTheme.button,
          ),
        ],
      );
    } else if (status == ButtonStatus.error) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.close,
            color: AppColors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.errorButtonText ?? '',
            style: defaultTheme.textTheme.button,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_sharp,
            color: AppColors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.verifiedButtonText ?? '',
            style: defaultTheme.textTheme.button,
          ),
        ],
      );
    }
  }
}
