import 'package:Varithms/globals.dart' as globals;
import 'package:flutter/cupertino.dart';

class SizeConfig {
  static double screenWidth;
  static double screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < screenHeight) {
        isMobilePortrait = true;
        globals.isPortrait = true;
      }
    } else {
      screenWidth = 423.5294196844927;
      screenHeight = 917.6470759830676;
      isPortrait = false;
      globals.isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
  }

  static double height(double val) {
    return (val / 917.6470759830676) * screenHeight;
  }

  static double width(double val) {
    return (val / 423.5294196844927) * screenWidth;
  }
}
