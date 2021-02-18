import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/size_config.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color(0xFFFFF7EC);
  static const Color topBarBackgroundColor = Color(0xFF2d3e50);
  static Color selectedTabBackgroundColor =
      globals.darkModeOn ? Colors.orange : Color(0xFF1e4a77);
  static Color unSelectedTabBackgroundColor =
      globals.darkModeOn ? Colors.grey[800] : Color(0xFFFFFFFC);
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
    title: titleLight,
    subtitle: subTitleLight,
    button: buttonLight,
    display1: greetingLight,
    display2: searchLight,
    body1: _selectedTabLight,
    body2: _unSelectedTabLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    title: titleDark,
    subtitle: subTitleDark,
    button: buttonDark,
    display1: greetingDark,
    display2: searchDark,
    body1: _selectedTabDark,
    body2: _unSelectedTabDark,
  );

  static final TextStyle titleLight = TextStyle(
      color: Colors.white,
      fontSize: 3.5 * SizeConfig.textMultiplier,
      fontFamily: "Livvic");

  static final TextStyle subTitleLight = TextStyle(
      color: subTitleTextColor,
      fontSize: 2 * SizeConfig.textMultiplier,
      height: 1.5,
      fontFamily: "Livvic");

  static final TextStyle buttonLight = TextStyle(
      color: Colors.white,
      fontSize: 2.5 * SizeConfig.textMultiplier,
      fontFamily: "Livvic");

  static final TextStyle greetingLight = TextStyle(
      color: Colors.white,
      fontSize: 2.0 * SizeConfig.textMultiplier,
      fontFamily: "Livvic");

  static final TextStyle searchLight = TextStyle(
      color: Colors.white,
      fontSize: 2.3 * SizeConfig.textMultiplier,
      fontFamily: "Livvic");

  static final TextStyle _selectedTabLight = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 2 * SizeConfig.textMultiplier,
      fontFamily: "Livvic");

  static final TextStyle _unSelectedTabLight = TextStyle(
      color: Colors.grey,
      fontSize: 2 * SizeConfig.textMultiplier,
      fontFamily: "Livvic");

  static final TextStyle titleDark = titleLight.copyWith(color: Colors.white);

  static final TextStyle subTitleDark =
  subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle buttonDark = buttonLight.copyWith(color: Colors.black);

  static final TextStyle greetingDark =
  greetingLight.copyWith(color: Colors.black);

  static final TextStyle searchDark = searchDark.copyWith(color: Colors.black);

  static final TextStyle _selectedTabDark =
  _selectedTabDark.copyWith(color: Colors.white);

  static final TextStyle _unSelectedTabDark =
  _selectedTabDark.copyWith(color: Colors.white70);
}
