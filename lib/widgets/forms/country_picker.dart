import 'dart:developer';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:pumpkin/controllers/auntentication/enter_mobile_screen_controller.dart';
import 'package:pumpkin/controllers/auntentication/login_screen_controller.dart';
import 'package:pumpkin/controllers/get_controllers.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/colors.dart';

// ignore: must_be_immutable
class CountryPicker extends StatelessWidget {
  final String? initCountryLabel;
  final Function(String value)? onCountryCodeSelected;
  final Function(String value)? onCountryLabelSelected;

  CountryPicker(
      {super.key,
      this.initCountryLabel,
      this.onCountryCodeSelected,
      this.onCountryLabelSelected});

  EnterMobileScreenController enterMobileScreenController =
      GetControllers.shared.getEmterMobileScreenController();

  @override
  Widget build(BuildContext context) {
    // // Default values
    // enterMobileScreenController.countryCode = '65'; //Country code
    // enterMobileScreenController.countryCodeLabel = 'SG'; //Country label
    // loginScreenController.countryCode = '65'; //Country code

    /*myAccountScreenController.changeCountryCode = '65'; //Country code
    myAccountScreenController.countryCodeLabel = 'SG'; //Country label*/

    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: AppColors.black.withOpacity(0.08), width: 1)),
      child: CountryPickerDropdown(
        initialValue: initCountryLabel ?? "SG",
        onValuePicked: (Country value) {
          log("countryCode:: " + value.phoneCode.toString());
          log("countryCodeLabel:: " + value.isoCode.toString());
          /*enterMobileScreenController.countryCode =
              value.phoneCode.toString(); //Country code
          enterMobileScreenController.countryCodeLabel =
              value.isoCode.toString(); //Country label
          loginScreenController.countryCode =
              value.phoneCode.toString(); //Country code*/

          if (onCountryCodeSelected != null) {
            onCountryCodeSelected!(value.phoneCode.toString());
          }

          if (onCountryLabelSelected != null) {
            onCountryLabelSelected!(value.isoCode.toString());
          }

          /* myAccountScreenController.changeCountryCode = value.phoneCode.toString(); //Country code
          myAccountScreenController.countryCodeLabel = value.isoCode.toString(); //Country label*/
        },
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 24),
        ),
        selectedItemBuilder: (country) {
          /* log("countryCode:: "+country.phoneCode.toString());
          log("countryCodeLabel:: "+country.isoCode.toString());

          myAccountScreenController.changeCountryCode = country.phoneCode.toString(); //Country code
          myAccountScreenController.countryCodeLabel = country.isoCode.toString(); //Country label*/

          return Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 60),
                alignment: Alignment.center,
                child: Text(
                  '+${country.phoneCode}',
                  textAlign: TextAlign.center,
                  style: defaultTheme.textTheme.bodyText2!.copyWith(
                    color: AppColors.black.withOpacity(0.8),
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 1,
                color: AppColors.black.withOpacity(0.08),
              )
            ],
          );
        },
        sortComparator: (Country a, Country b) =>
            a.isoCode.compareTo(b.isoCode),
        itemBuilder: (country) {
          return Align(
            alignment: Alignment.center,
            child: Text(
              '+${country.phoneCode} (${country.isoCode})',
              textAlign: TextAlign.center,
              style: defaultTheme.textTheme.bodyText2!.copyWith(
                color: AppColors.black.withOpacity(0.6),
              ),
            ),
          );
        },
      ),
    );
  }
}
