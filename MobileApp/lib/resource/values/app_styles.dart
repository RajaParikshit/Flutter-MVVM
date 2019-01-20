import 'package:flutter/material.dart';
import 'package:flutter_mvvm_login_example/resource/values/app_colors.dart';

/// App Styles Class -> Resource class for storing app level styles constants
class AppStyles {

  // Light Theme
  static ThemeData lightTheme(){
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: AppColors.PRIMARY_COLOR,
      primaryColorLight: AppColors.PRIMARY_COLOR_LIGHT,
      primaryColorDark: AppColors.PRIMARY_COLOR_DARK,
      accentColor: AppColors.ACCENT_COLOR,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(16),
        hintStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.normal,
        ),
        labelStyle: TextStyle(
          color: AppColors.PRIMARY_COLOR,
          fontWeight: FontWeight.bold,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.PRIMARY_COLOR_DARK,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.PRIMARY_COLOR,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          )
        ),
        textTheme:ButtonTextTheme.normal,
        buttonColor: AppColors.ACCENT_COLOR,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(){
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      primaryColor: AppColors.PRIMARY_COLOR,
      primaryColorLight: AppColors.PRIMARY_COLOR_LIGHT,
      primaryColorDark: AppColors.PRIMARY_COLOR_DARK,
      accentColor: AppColors.ACCENT_COLOR,
    );
  }

}