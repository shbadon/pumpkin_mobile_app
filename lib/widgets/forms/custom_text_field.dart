import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';
import 'package:pumpkin/utils/custom_date_picker.dart';
import 'package:pumpkin/utils/enums.dart';
import 'package:pumpkin/utils/strings.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController
      controller; //Global controller variable is declared so that any controller can be passed to it.
  final InputFieldTypes
      type; //Form field type. Used to determine what validations should be used by the field.
  final caption;
  var errorFree;
  FocusNode?
      myFocusNode; //Which node is being currently focused. This is used for OTP and other OTP like validations
  final hintText; //Hints within the form field
  final mobileNumber;
  final readWriteStatus;
  final onTap; //What happens when the form field is tapped upon.
  final labelText; //Label Text for the form field
  final autoValidate; //Validates as the user types the email or password or whatever validation is required.
  final autoSubmit; // Submits the form if all fields are filled up correctly. Preferred to be false, so that the user can check if any mistake are made from his/her end.
  final verified; //Checks if fields are verified.
  final isValidationEnabled; //Checks if fields are verified.
  final suggestions; //Auto-complete suggestions.
  final autoKey;
  final isPast;
  final onSubmit; //On submit function is used when the form is submitted.
  final onSubmitSearch; //On submit function is used when the form is submitted.
  final maxLength; //Maximum length on a textField.
  final TextEditingController? countryCodeController;
  final TextEditingController? countryCodeLabelController;
  final onChanged;
  final dateInputFormatter;
  final numberInputFormatter;
  final textInputAction;
  final String dateFormat;
  String dropdownForLeadCountryDefaultValue;
  bool readOnly;
  String? Function(String?)? validator;
  BuildContext? context;
  Widget? prefixIcon;

  CustomTextField(
      {Key? key,
      required this.type,
      required this.controller,
      this.onSubmit,
      this.countryCodeController,
      this.countryCodeLabelController,
      this.caption,
      this.errorFree,
      this.myFocusNode,
      this.hintText,
      this.mobileNumber,
      this.readWriteStatus,
      this.onTap,
      this.labelText,
      this.autoValidate,
      this.autoSubmit,
      this.verified = false,
      this.isValidationEnabled = true,
      this.suggestions,
      this.autoKey,
      this.isPast = false,
      this.maxLength,
      this.onChanged,
      this.dateInputFormatter,
      this.numberInputFormatter,
      this.textInputAction,
      this.dateFormat = "dd-MM-yyyy",
      this.dropdownForLeadCountryDefaultValue = "Singapore Citizens",
      this.readOnly = false,
      this.onSubmitSearch,
      this.validator,
      this.context,
      this.prefixIcon})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var _value;
  bool validate = false;
  bool? readOnlyEmail;

  InputFieldTypes get _type => widget.type;

  TextEditingController get _thisController => widget.controller;
  late GlobalKey<NavigatorState> navigatorKey;
  bool indicator = true; //indicates if the field is selected or not
  FocusNode _focus = FocusNode();

  //initialize everything before the page loads so that it doesn't throw an error later.
  @override
  void initState() {
    super.initState();
    navigatorKey = GlobalKey<
        NavigatorState>(); //navigator key for validations and checking
    //if the controller is null(has no data) do nothing else start validating as the user types.
    if (widget.controller == null) {
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
    if (widget.mobileNumber != null) {
      _thisController.text = widget.mobileNumber;
    }
  }

  //What needs to be done when the controller finds the changing data
  void _handleControllerChanged() {
    if (_thisController.text != _value || _value.trim().isNotEmpty) {
      didChange(_thisController.text);
    }
  }

  //As and when the data changes, the value starts getting updated.
  void didChange(var value) {
    setState(() {
      _value = value;
    });
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);

      if (widget.controller == null) {
        if (widget.controller != null) {
          _thisController.text = widget.controller.text;
          //if (oldWidget.controller == null) _controller = null;
        }
      }
    }
  }

  //Disposing the listener to avoid taking up extra memory.
  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  String dropdownValueCountry = 'Singapore';
  String dropdownForLeadCountryDefaultValue = 'Singapore Citizens';
  String dropdownInitialValue = '+65';

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case InputFieldTypes.money:
        {
          return TextFormField(
            controller: _thisController,
            readOnly: widget.readOnly,
            //Controller for the form field
            //keyboardType: TextInputType.number,
            //Keyboard type for the form field
            //autofocus: false,
            //Autofocus for the form field
            //inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            //Maximum lines for the form field
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // inputFormatters: widget.numberInputFormatter,
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(RegExp("[0-9,\b]")),
            //   // DecimalTextInputFormatter(decimalRange: 2)
            // ],
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(RegExp(
            //       r'[0-9]')), // <-- Use \b in your regex here so backspace works.
            //   // DecimalTextInputFormatter(decimalRange: 2),
            //   // CurrencyInputFormatter(),
            //   // CurrencyPtBrInputFormatter(maxDigits: 8),
            // ],
            inputFormatters: [
              ThousandsFormatter(allowFraction: true),
              DecimalTextInputFormatter(decimalRange: 2),
            ],
            //Autovalidate mode for the form field
            // validator: validatePassword, //Validator for the form field
            obscureText: false,
            //Obscure text for the form field
            style: defaultTheme.textTheme.bodyText1,
            //Style for the form field
            validator: widget.validator,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
                prefix: _thisController.text.isNotEmpty
                    ? const Text('\$')
                    : const SizedBox(),
                suffixIcon:
                (widget.controller.text.isNotEmpty && _focus.hasFocus)
                    ? IconButton(
                  icon: const Icon(Icons.clear,
                      size: 20, color: AppColors.borderColor),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        widget.controller.clear();
                      });
                    }
                  },
                )
                    : null,
                //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                labelStyle: defaultTheme.textTheme.bodyText1,
                // contentPadding: ScreenConstant.spacingAllLarge,
                isDense: true,
                // Less vertical space
                contentPadding: const EdgeInsets.all(14),
                // Added this
                hintText: widget.hintText,
                hintStyle: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.textFieldHintTextColor),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.focusColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                fillColor: AppColors.fillColor,
                errorStyle: TextStyle(
                    fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
          );
        }
      case InputFieldTypes.textView:
        {
          return Container(
            height: 45,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.borderColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: AppColors.borderColor,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _thisController.text,
                style: defaultTheme.textTheme.bodyText1,
              ),
            ),
          );
        }
      case InputFieldTypes.text:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.text,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              validator: widget.isValidationEnabled ? validateTextField : null,
              decoration: InputDecoration(
                  suffixIcon:
                      (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 20, color: AppColors.borderColor),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.clear();
                                  });
                                }
                              },
                            )
                          : null,
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }

      case InputFieldTypes.textWitoutValidation:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              onChanged: widget.onChanged,
              controller: _thisController,
              keyboardType: TextInputType.text,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              decoration: InputDecoration(
                  prefixIcon: widget.prefixIcon,
                  suffixIcon:
                      (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 20, color: AppColors.borderColor),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.clear();
                                  });
                                }
                              },
                            )
                          : null,
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }
      case InputFieldTypes.passWord:
        {
          return TextFormField(
            controller: _thisController,
            keyboardType: TextInputType.text,
            autofocus: false,
            focusNode: _focus,
            maxLines: 1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validatePassword,
            obscureText: indicator,
            style: defaultTheme.textTheme.bodyText1,
            //inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")), ],
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.textFieldHintTextColor),
                //Hint style for the form field
                errorMaxLines: 2,
                //Maximum lines for the error text
                labelStyle: defaultTheme.textTheme.bodyText1,
                //Label style for the form field
                suffixIcon: SizedBox(
                  child: widget.controller.text.isNotEmpty && _focus.hasFocus
                      ? IconButton(
                          //Suffix icon for the form field
                          icon: Icon(
                            indicator
                                ? Icons
                                    .visibility_off_outlined //If the indicator is true, then the icon is the eye closed icon
                                : Icons.visibility_outlined,
                            //If the indicator is false, then the icon is the eye open icon
                            color: AppColors.borderColor,
                          ),
                          onPressed: () {
                            setState(() {
                              indicator = !indicator; //Toggle the indicator
                            });
                          },
                        )
                      : null,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.focusColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                isDense: true,
                fillColor: AppColors.fillColor,
                //Fill color for the form field
                errorStyle: TextStyle(
                    fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
          );
        }

      case InputFieldTypes.confirmPassWord:
        {
          return TextFormField(
            controller: _thisController,
            keyboardType: TextInputType.text,
            autofocus: false,
            focusNode: _focus,
            maxLines: 1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            obscureText: indicator,
            style: defaultTheme.textTheme.bodyText1,
            //inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")), ],
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.textFieldHintTextColor),
                //Hint style for the form field
                errorMaxLines: 2,
                //Maximum lines for the error text
                labelStyle: defaultTheme.textTheme.bodyText1,
                //Label style for the form field
                suffixIcon: SizedBox(
                  child: widget.controller.text.isNotEmpty && _focus.hasFocus
                      ? IconButton(
                          //Suffix icon for the form field
                          icon: Icon(
                            indicator
                                ? Icons
                                    .visibility_off_outlined //If the indicator is true, then the icon is the eye closed icon
                                : Icons.visibility_outlined,
                            //If the indicator is false, then the icon is the eye open icon
                            color: AppColors.borderColor,
                          ),
                          onPressed: () {
                            setState(() {
                              indicator = !indicator; //Toggle the indicator
                            });
                          },
                        )
                      : null,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.focusColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                isDense: true,
                fillColor: AppColors.fillColor,
                //Fill color for the form field
                errorStyle: TextStyle(
                    fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
          );
        }

      case InputFieldTypes.fullnameWithClear:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.text,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              validator: widget.isValidationEnabled ? validateFullName : null,
              decoration: InputDecoration(
                  suffixIcon:
                      (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 20, color: AppColors.borderColor),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.clear();
                                  });
                                }
                              },
                            )
                          : null,
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }
      case InputFieldTypes.firstNameWithClear:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.text,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              validator: validateFirstName,
              decoration: InputDecoration(
                  suffixIcon:
                      (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 20, color: AppColors.borderColor),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.clear();
                                  });
                                }
                              },
                            )
                          : null,
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }
      case InputFieldTypes.lastNameWithClear:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.text,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              validator: validateLastName,
              decoration: InputDecoration(
                  suffixIcon:
                      (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 20, color: AppColors.borderColor),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.clear();
                                  });
                                }
                              },
                            )
                          : null,
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }
      case InputFieldTypes.numberWithClear:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.phone,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              maxLength: 10,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              validator: widget.isValidationEnabled ? validatePhone : null,
              decoration: InputDecoration(
                  suffixIcon: widget.readOnly
                      ? null
                      : (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 20, color: AppColors.borderColor),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.clear();
                                  });
                                }
                              },
                            )
                          : null,
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  counterText: "",
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }
      case InputFieldTypes.emailWithClear:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              validator: validateEmail,
              decoration: InputDecoration(
                  suffixIcon: widget.readOnly
                      ? null
                      : (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 20, color: AppColors.borderColor),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.clear();
                                  });
                                }
                              },
                            )
                          : null,
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }
      case InputFieldTypes.emailWithClearAndChange:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              validator: validateEmail,
              decoration: InputDecoration(
                  suffixIcon:
                      (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? SizedBox(
                              width: 110,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.clear,
                                        size: 20, color: AppColors.borderColor),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          widget.controller.clear();
                                        });
                                      }
                                    },
                                  ),
                                  InkWell(
                                    onTap: widget.onChanged,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          right: 5,
                                          left: 5,
                                          bottom: 5),
                                      child: Text(
                                        "Change",
                                        style: defaultTheme.textTheme.headline5!
                                            .copyWith(
                                                color: AppColors.primaryColor),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: widget.onChanged,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, right: 5, left: 5, bottom: 5),
                                child: Text(
                                  "Change",
                                  style: defaultTheme.textTheme.headline5!
                                      .copyWith(color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }

      case InputFieldTypes.phoneWithClearAndChange:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              controller: _thisController,
              keyboardType: TextInputType.number,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              //validator: validateEmail,
              inputFormatters: <TextInputFormatter>[
                // for below version 2 use this
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                // for version 2 and greater youcan also use this
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: InputDecoration(
                  suffixIcon:
                      (widget.controller.text.isNotEmpty && _focus.hasFocus)
                          ? SizedBox(
                              width: 90,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      icon: const Icon(Icons.clear,
                                          size: 20,
                                          color: AppColors.borderColor),
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            widget.controller.clear();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: widget.onChanged,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          right: 5,
                                          left: 5,
                                          bottom: 5),
                                      child: Text(
                                        "Change",
                                        style: defaultTheme.textTheme.headline5!
                                            .copyWith(
                                                color: AppColors.primaryColor),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: widget.onChanged,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, right: 5, left: 5, bottom: 5),
                                child: Text(
                                  "Change",
                                  style: defaultTheme.textTheme.headline5!
                                      .copyWith(color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                  //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                  labelStyle: defaultTheme.textTheme.bodyText1,
                  // contentPadding: ScreenConstant.spacingAllLarge,
                  isDense: true,
                  // Less vertical space
                  contentPadding: const EdgeInsets.all(14),
                  // Added this
                  hintText: widget.hintText,
                  hintStyle: defaultTheme.textTheme.bodyText1!
                      .copyWith(color: AppColors.textFieldHintTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.focusColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fillColor,
                  errorStyle: TextStyle(
                      fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
            ),
          );
        }

      case InputFieldTypes.otp:
        {
          return SizedBox(
            //height: 45,
            child: TextFormField(
              maxLength: widget.maxLength,
              controller: _thisController,
              keyboardType: TextInputType.number,
              autofocus: false,
              focusNode: _focus,
              maxLines: 1,
              readOnly: widget.readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: defaultTheme.textTheme.bodyText1,
              //validator: validateName,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                counter: Container(),
                labelStyle: defaultTheme.textTheme.bodyText1,
                // contentPadding: ScreenConstant.spacingAllLarge,
                hintText: widget.hintText,
                hintStyle: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.textFieldHintTextColor),
                isDense: true,
                // Added this
                contentPadding: const EdgeInsets.all(17),
                // Added this
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.focusColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                fillColor: AppColors.otpBG.withOpacity(0.3),
              ),
            ),
          );
        }

      case InputFieldTypes.textArea:
        {
          return TextFormField(
            controller: _thisController,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            focusNode: _focus,
            maxLines: 4,
            readOnly: widget.readOnly,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: defaultTheme.textTheme.bodyText1,
            decoration: InputDecoration(
                labelStyle: defaultTheme.textTheme.bodyText1,
                // contentPadding: ScreenConstant.spacingAllLarge,
                isDense: true,
                // Less vertical space
                contentPadding: const EdgeInsets.all(14),
                // Added this
                hintText: widget.hintText,
                hintStyle: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.textFieldHintTextColor),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.focusColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                fillColor: AppColors.fillColor,
                errorStyle: TextStyle(
                    fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
          );
        }
      case InputFieldTypes.dob:
        {
          return TextFormField(
            onTap: () {
              debugPrint("calender");
              showDatePicker(widget.context, InputFieldTypes.dob);
            },
            controller: _thisController,
            keyboardType: TextInputType.none,
            autofocus: false,
            focusNode: _focus,
            maxLines: 1,
            readOnly: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: defaultTheme.textTheme.bodyText1,
            validator: widget.isValidationEnabled ? validateDob : null,
            decoration: InputDecoration(
                suffixIcon: widget.readOnly
                    ? null
                    : const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.focusColor,
                      ),
                //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                labelStyle: defaultTheme.textTheme.bodyText1,
                // contentPadding: ScreenConstant.spacingAllLarge,
                isDense: true,
                // Less vertical space
                contentPadding: const EdgeInsets.all(14),
                // Added this
                hintText: widget.hintText,
                hintStyle: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.textFieldHintTextColor),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.focusColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                fillColor: AppColors.fillColor,
                errorStyle: TextStyle(
                    fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
          );
        }

      case InputFieldTypes.date:
        {
          return GestureDetector(
            onTap: widget.readOnly
                ? null
                : () {
                    debugPrint("calender");
                    showDatePicker(widget.context, InputFieldTypes.date);
                  },
            child: Container(
                height: 45,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.borderColor, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            10) //                 <--- border radius here
                        )),
                child: Row(
                  children: [
                    Text(_thisController.text.isEmpty
                        ? widget.hintText
                        : _thisController.text),
                    const Spacer(),
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.focusColor,
                    ),
                  ],
                )),
          );
        }

      case InputFieldTypes.time:
        {
          return GestureDetector(
            onTap: widget.readOnly
                ? null
                : () {
                    debugPrint("calender");
                    showTimePicker(widget.context);
                  },
            child: Container(
                height: 45,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.borderColor, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            10) //                 <--- border radius here
                        )),
                child: Row(
                  children: [
                    Text(_thisController.text.isEmpty
                        ? widget.hintText
                        : _thisController.text),
                  ],
                )),
          );
        }
      case InputFieldTypes.year:
        {
          return TextFormField(
            onTap: () {
              debugPrint("calender");
              _showYearPicker(widget.context, InputFieldTypes.year);
            },
            controller: _thisController,
            keyboardType: TextInputType.none,
            autofocus: false,
            focusNode: _focus,
            maxLines: 1,
            readOnly: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: defaultTheme.textTheme.bodyText1,
            validator: validateYear,
            decoration: InputDecoration(
                suffixIcon: widget.readOnly
                    ? null
                    : const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.focusColor,
                      ),
                //errorText: _value != null ? validateEmailAndMobile(_value) : null,
                labelStyle: defaultTheme.textTheme.bodyText1,
                // contentPadding: ScreenConstant.spacingAllLarge,
                isDense: true,
                // Less vertical space
                contentPadding: const EdgeInsets.all(14),
                // Added this
                hintText: widget.hintText,
                hintStyle: defaultTheme.textTheme.bodyText1!
                    .copyWith(color: AppColors.textFieldHintTextColor),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.focusColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                fillColor: AppColors.fillColor,
                errorStyle: TextStyle(
                    fontSize: defaultTheme.textTheme.bodyText2!.fontSize)),
          );
        }

      default:
        return const SizedBox();
    }
  }

  // 21 Years of age limitation is there if dob otherwise no limitation
  void showDatePicker(context, type) {
    // showCupertinoModalPopup is a built-in function of the cupertino library

    var initDate = DateTime.now().subtract(const Duration(days: 5113));
    var maxYear = initDate.year;
    var selectedDate = initDate;
    var currentDate = DateTime.now();
    showCupertinoModalPopup(
        //barrierDismissible: false,
        context: context,
        builder: (_) => Container(
              height: 300,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (type == InputFieldTypes.dob) {
                        var dateNow = DateTime.now();
                        var diff = dateNow.difference(selectedDate);
                        var year = ((diff.inDays) / 365).round();

                        //if (year > 20) {
                        _thisController.text =
                            DateFormat(widget.dateFormat).format(selectedDate);
                        setState(() {});
                        /*} else {
                          Get.snackbar("Invalid DOB",
                              "You must be 21 year old and above to access iqrate services. ",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }*/
                      } else {
                        _thisController.text =
                            DateFormat(widget.dateFormat).format(currentDate);
                        setState(() {});
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 15.0),
                      child: Icon(
                        Icons.done,
                        size: 30,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 254,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: type == InputFieldTypes.date
                            ? DateTime.now()
                            : initDate,
                        maximumDate:
                            type == InputFieldTypes.date ? null : initDate,
                        onDateTimeChanged: (date) {
                          selectedDate = date;
                          currentDate = date;
                          if (type == InputFieldTypes.date) {
                            // setState(() {
                            _thisController.text =
                                DateFormat('yyyy-MM-dd').format(date);
                            //  });
                          }

                          setState(() {});
                        }),
                  ),
                ],
              ),
            ));
  }

  void showTimePicker(context) {
    var initDate = DateTime.now();
    var maxYear = initDate.year;
    var selectedDate = initDate;
    showCupertinoModalPopup(
        //barrierDismissible: false,
        context: context,
        builder: (_) => Container(
              height: 300,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                      _thisController.text =
                          DateFormat('hh:mm').format(selectedDate);
                      setState(() {});
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 15.0),
                      child: Icon(
                        Icons.done,
                        size: 30,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 254,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: (date) {
                          selectedDate = date;
                          _thisController.text =
                              DateFormat('hh:mm').format(date);

                          setState(() {});
                        }),
                  ),
                ],
              ),
            ));
  }

  // Shows the current date
  void _showYearPicker(context, type) {
    // showCupertinoModalPopup is a built-in function of the cupertino library

    var initDate = DateTime.now();
    var maxDate = initDate;
    var selectedDate = initDate;
    showCupertinoModalPopup(
        //barrierDismissible: false,
        context: context,
        builder: (_) => Container(
              height: 300,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (type == InputFieldTypes.dob) {
                        var dateNow = DateTime.now();
                        var diff = dateNow.difference(selectedDate);
                        var year = ((diff.inDays) / 365).round();

                        //if (year > 20) {
                        _thisController.text =
                            DateFormat(widget.dateFormat).format(selectedDate);
                        setState(() {});
                        /*} else {
                          Get.snackbar("Invalid DOB",
                              "You must be 21 year old and above to access iqrate services. ",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }*/
                      } else {
                        _thisController.text =
                            DateFormat(widget.dateFormat).format(selectedDate);
                        setState(() {});
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 15.0),
                      child: Icon(
                        Icons.done,
                        size: 30,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 254,
                    child: Center(
                      child: CustomCupertinoDatePicker(
                          mode: CustomCupertinoDatePickerMode.year,
                          initialDateTime: initDate,
                          maximumDate: maxDate,
                          dateOrder: DatePickerDateOrder.values.first,
                          onDateTimeChanged: (date) {
                            selectedDate = date;
                            if (type == InputFieldTypes.date) {
                              // setState(() {
                              _thisController.text =
                                  DateFormat('yyyy-MM-dd').format(date);
                              //  });
                            }

                            setState(() {});
                          }),
                    ),
                  ),
                ],
              ),
            ));
  }

  String? validateTextField(String? value) {
    if (value!.isEmpty) {
      return AppLabels.fieldRequired;
    } else {
      return null;
    }
  }

  String? validateFullName(String? value) {
    if (value!.isEmpty) {
      return AppLabels.nameRequired;
    } else {
      return null;
    }
  }

  String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      return AppLabels.firstNameRequired;
    } else {
      return null;
    }
  }

  String? validateLastName(String? value) {
    if (value!.isEmpty) {
      return AppLabels.lastNameRequired;
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return AppLabels.passwordRequired;
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
        .hasMatch(value)) {
      return AppLabels.passwordFormatError;
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    if (widget.isValidationEnabled && value!.isEmpty) {
      return AppLabels.emailRequired;
    } else if (value!.isNotEmpty &&
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
      return AppLabels.invalidEmail;
    } else {
      return null;
    }
  }

  String? validatePhone(String? value) {
    if (widget.isValidationEnabled && value!.isEmpty) {
      return AppLabels.phoneRequired;
    } else if (widget.isValidationEnabled && value!.length < 8) {
      return AppLabels.invalidPhone;
    } else {
      return null;
    }
  }

  String? validateDob(String? value) {
    if (value!.isEmpty) {
      return AppLabels.dateRequired;
    } else {
      return null;
    }
  }

  String? validateYear(String? value) {
    if (value!.isEmpty) {
      return AppLabels.yearRequired;
    } else {
      return null;
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}