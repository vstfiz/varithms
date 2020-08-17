import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/size_config.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget portraitLayout;
  final Widget landscapeLayout;

  const ResponsiveWidget({
    Key key,
    @required this.portraitLayout,
    this.landscapeLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (SizeConfig.isPortrait && SizeConfig.isMobilePortrait) {
      globals.isPortrait = true;
      return portraitLayout;
    } else {
      globals.isPortrait = false;
      return landscapeLayout ?? portraitLayout;
    }
  }
}
