import 'dart:ui';

import 'package:Varithms/size_config.dart';
import 'package:Varithms/styling.dart' as style;
import 'package:flutter/material.dart';

import 'size_config.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color(0xFFFFF7EC);
  static const Color subTitleTextColor = Color(0xFF9F988F);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
  );

  static final TextTheme lightTextTheme = TextTheme(
    title: style.AppTheme.titleLight,
    subtitle: _subTitleLight,
    button: style.AppTheme.buttonLight,
    display1: style.AppTheme.greetingLight,
    display2: style.AppTheme.searchLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    title: style.AppTheme.titleDark,
    subtitle: _subTitleDark,
    button: style.AppTheme.buttonDark,
    display1: style.AppTheme.greetingDark,
    display2: style.AppTheme.searchDark,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 2 * SizeConfig.textMultiplier,
    height: SizeConfig.height(1.5),
  );

  static final TextStyle _subTitleDark =
      _subTitleLight.copyWith(color: Colors.white70);
}
