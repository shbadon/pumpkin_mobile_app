import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pumpkin/utils/colors.dart';

TextTheme defaultTextTheme = TextTheme(
    headline1: myHeadline1,
    headline2: myHeadline2,
    headline3: myHeadline3,
    headline4: myHeadline4,
    headline5: myHeadline5,
    headline6: myHeadline6,
    subtitle1: mySubtitle1,
    subtitle2: mySubtitle2,
    bodyText1: myBodytext1,
    bodyText2: myBodytext2,
    caption: myCaption,
    button: myButton,
    overline: myButton);

TextStyle myHeadline1 = GoogleFonts.urbanist(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: AppColors.textColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle myHeadline2 = GoogleFonts.urbanist(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: AppColors.textColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle myHeadline3 = GoogleFonts.urbanist(
  color: AppColors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
// TODO: Not confirmed by designers
TextStyle myHeadline4 = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle myHeadline5 = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    textStyle: const TextStyle(overflow: TextOverflow.visible));
// TODO: Not confirmed by designers
TextStyle myHeadline6 = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.primaryColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle mySubtitle1 = GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: AppColors.textColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle mySubtitle2 = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.textColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));

TextStyle myBodytext1 = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.textColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle myBodytext2 = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.textColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle myTitle1 = GoogleFonts.urbanist(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.textColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));

// TODO: Not confirmed by designers
TextStyle myCaption = GoogleFonts.urbanist(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: AppColors.white,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
TextStyle myButton = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: AppColors.buttonTextColor,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis));

ThemeData defaultTheme = ThemeData.from(colorScheme: const ColorScheme.light())
    .copyWith(
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primaryColor,
            selectionColor: AppColors.secondaryColor,
            selectionHandleColor: AppColors.primaryColor),
        appBarTheme:
            const AppBarTheme(color: AppColors.scaffoldColor, elevation: 0),
        scaffoldBackgroundColor: AppColors.scaffoldColor,
        textTheme: defaultTextTheme,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.bottomNavigationBarColor,
            selectedItemColor: Colors.white,
            unselectedItemColor:
                AppColors.bottomNavigationBarUnselectedLabelColor,
            selectedLabelStyle:
                myBodytext2.copyWith(fontWeight: FontWeight.w600)),
        tabBarTheme: const TabBarTheme(
            labelColor: AppColors.primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.black,
            labelPadding: EdgeInsets.only(bottom: 10)),
        iconTheme: const IconThemeData(color: AppColors.iconColor));
