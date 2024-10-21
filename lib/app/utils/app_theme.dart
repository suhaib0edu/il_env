import 'package:flutter/material.dart';
import 'package:il_env/app/utils/colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    indicatorColor: AppColors.primaryColor,
    canvasColor: AppColors.quaternaryColor,
    shadowColor: AppColors.primaryColor,
    cardColor: AppColors.tertiaryColor,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
    ),
    iconTheme: IconThemeData(color: AppColors.primaryColor), 
    primaryColorLight: AppColors.primaryColor,
    focusColor: AppColors.primaryColor,
    splashColor: AppColors.primaryColor.withOpacity(0.2),
    scaffoldBackgroundColor: AppColors.quaternaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryColor,
        shape: StadiumBorder(
          side: BorderSide(
            color: AppColors.primaryColor,
            width: 1,
          ),
        ),
        overlayColor: AppColors.primaryColor.withOpacity(0.2),
      ),
    ),
  );
}
