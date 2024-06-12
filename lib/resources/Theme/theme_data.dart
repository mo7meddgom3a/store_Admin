
import 'package:anwer_shop_admin/resources/Managers/colors_manager.dart';
import 'package:anwer_shop_admin/resources/Managers/fonts_manager.dart';
import 'package:anwer_shop_admin/resources/Managers/styles_manager.dart';
import 'package:anwer_shop_admin/resources/Managers/values_manager.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationtheme(bool dark) {
/********************* DARK THEME ************************************** */
  if (dark) {
    return ThemeData(
      scaffoldBackgroundColor: ColorManager.Black,
      primaryColor: ColorManager.DarkGrey,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ColorManager.DarkGrey,
      ),
      appBarTheme: AppBarTheme(
        color: ColorManager.DarkGrey,
        shadowColor: ColorManager.LightGrey,
        centerTitle: true,
        elevation: AppSize.s8,
        titleTextStyle: getBoldStyle(
          color: ColorManager.DarkGrey,
        ),
      ),
      textTheme: TextTheme(
        titleMedium: getMediumStyle(
          color: ColorManager.White,
        ),
        displayLarge: getSemiBoldStyle(
          color: ColorManager.White,
          fontsize: FontSize.s26,
        ),
        bodyLarge: getRegularStyle(
          color: ColorManager.White,
          fontsize: FontSize.s14,
        ),
        displaySmall: getLightStyle(
          color: ColorManager.DarkGrey,
          fontsize: FontSize.s14,
        ),
        bodyMedium: getRegularStyle(
          color: ColorManager.White,
          fontsize: FontSize.s14,
        ),
        displayMedium: getRegularStyle(
          color: ColorManager.White,
          fontsize: FontSize.s16,
        ),
      ).apply(),
    );
  }
/**************************** BRIGHT THEME ****************************** */
  return ThemeData(
    // ******************* Main Colors **********************
    primaryColor: ColorManager.Black,
    primaryColorLight: ColorManager.LightGrey,
    primaryColorDark: ColorManager.Black,
    splashColor: ColorManager.LightGrey,
    scaffoldBackgroundColor: ColorManager.Black,
    // disabled color

    // ******************** CardView theme ********************
    cardTheme: CardTheme(
      color: ColorManager.White,
      shadowColor: ColorManager.LightGrey,
      elevation: AppSize.s8,
    ),

    // ******************** Appbar theme ********************

    appBarTheme: AppBarTheme(
      color: ColorManager.Black,
      shadowColor: ColorManager.LightGrey,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: getBoldStyle(
        fontsize: FontSize.s26,
        color: ColorManager.Pink,
      ),
    ),

    // ******************** button theme ********************
//cant use this
    // buttonTheme: ButtonThemeData(
    //   minWidth: 500,
    //   height: 100.0,
    //   shape: const StadiumBorder(),
    //   disabledColor: ColorManager.DarkGrey,
    //   buttonColor: ColorManager.PrimaryColor,
    //   focusColor: ColorManager.DarkGrey,
    //   splashColor: ColorManager.PrimaryColor,
    // ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
          color: ColorManager.White,
          fontsize: FontSize.s18,
        ),
        backgroundColor: ColorManager.Black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    // ******************** Text theme ********************

    textTheme: TextTheme(
      displayLarge: getSemiBoldStyle(
        color: ColorManager.White,
        fontsize: FontSize.s20,
      ),
      bodyLarge: getSemiBoldStyle(
        color: ColorManager.White,
        fontsize: FontSize.s16,
      ),
      displaySmall: getRegularStyle(
        color: ColorManager.White,
        fontsize: FontSize.s14,
      ),
      bodyMedium: getRegularStyle(
        color: ColorManager.Black,
        fontsize: FontSize.s14,
      ),
      bodySmall: getMediumStyle(
        color: ColorManager.White,
        fontsize: FontSize.s12,
      ),
      displayMedium: getRegularStyle(
        color: ColorManager.LightGrey,
        fontsize: FontSize.s18,
      ),
    ),
    // ******************** Input theme ********************

    inputDecorationTheme: InputDecorationTheme(
      suffixIconColor: ColorManager.Black,
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      hintStyle: getRegularStyle(
        color: ColorManager.Black,
        fontsize: FontSize.s14,
      ),
      errorStyle: getRegularStyle(
        color: ColorManager.error,
        fontsize: FontSize.s14,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.LightGrey,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s14),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.LightGrey,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s14),
        ),
      ),
      // ******************* ERROR border color ********************
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.error,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.error,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      /************************************************************ */
    ),
  );
}
