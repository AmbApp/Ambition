import 'package:flutter/material.dart';

import 'colors.dart';

mixin Styles {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.PRIMARY_500,
    iconTheme: const IconThemeData(color: Colors.black, size: 15),
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: "Roboto",
          fontSize: 19,
          height: 1.0,
          fontWeight: FontWeight.w500,
          color: AppColors.FONT_GRAY,
        ),
        bodyMedium: TextStyle(
          fontFamily: "Roboto",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.FONT_GRAY,
        ),
        bodySmall: TextStyle(
          fontFamily: "Roboto",
          fontSize: 11,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.FONT_GRAY,
        )),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme(
      background: AppColors.LM_BACKGROUND_BASIC,
      brightness: Brightness.light,
      error: AppColors.RED,
      onBackground: AppColors.LM_BACKGROUND_BASIC,
      onError: AppColors.RED,
      onPrimary: AppColors.BLUE,
      onSecondary: AppColors.PRIMARY_700,
      onSurface: AppColors.PRIMARY_500,
      primary: AppColors.BLUE,
      secondary: AppColors.PRIMARY_700,
      surface: AppColors.PRIMARY_500,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.BLUE,
    iconTheme: const IconThemeData(color: Colors.black, size: 15),
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 18,
          height: 1.0,
          fontWeight: FontWeight.w600,
          color: AppColors.BLACK,
        ),
        bodyMedium: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w500,
          color: AppColors.BLACK,
        ),
        bodySmall: TextStyle(
          fontFamily: "NotoArabic",
          fontSize: 11,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: AppColors.FONT_GRAY,
        )),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
