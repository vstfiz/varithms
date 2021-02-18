import 'package:Varithms/responsiveui.dart';
import 'package:Varithms/size_config.dart';
import 'package:Varithms/strings.dart';
import 'package:Varithms/styling.dart' as style;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    setFirstRun();
  }

  setFirstRun() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("firstRun", false);
  }

  Future<void> exitDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                "Exit",
                style: TextStyle(fontSize: 30, fontFamily: "Livvic"),
              ),
              content: Text(
                "Do you want to exit ?",
                style: TextStyle(fontSize: 20, fontFamily: "Livvic"),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: Colors.grey[800]),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: Colors.grey[800]),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exitDialog();
        return Future<bool>.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Align(
                    alignment: Alignment.center,
                    child: ResponsiveWidget(
                      portraitLayout: WelcomeContentWidget(),
                      landscapeLayout: WelcomeContentWidgetLand(),
                    )),
              ),
              ButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeContentWidgetLand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 917.6470759830676,
      width: 423.5294196844927,
      child: WelcomeContentWidget(),
      // margin: EdgeInsets.symmetric(horizontal:(MediaQuery.of(context).size.width-423.5294196844927)/2,vertical:(MediaQuery.of(context).size.width-917.6470759830676)/2),
    );
  }
}

class WelcomeContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FittedBox(
                    child: Text(
                      Strings.welcomeScreenTitle,
                      style: TextStyle(
                        fontFamily: "Livvic",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: SizeConfig.height(50),
          ),
          Container(
            height: SizeConfig.height(400),
            width: MediaQuery
                .of(context)
                .size
                .width - SizeConfig.width(150),
            margin: EdgeInsets.symmetric(
                vertical: 1 * SizeConfig.heightMultiplier),
            child: Image.asset(
              'assets/back_login.png',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: SizeConfig.height(50),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: FittedBox(
                child: Padding(
                  padding:
                  EdgeInsets.only(bottom: 2 * SizeConfig.heightMultiplier),
                  child: Text(
                    Strings.welcomeScreenSubTitle,
                    style: TextStyle(
                      fontFamily: "Livvic",
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
              minHeight: 6.5 * SizeConfig.heightMultiplier,
              maxHeight: 7.9 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(4 * SizeConfig.heightMultiplier),
            ),
            color: style.AppTheme.topBarBackgroundColor,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 6 * SizeConfig.imageSizeMultiplier,
                ),
              ),
              Text(
                Strings.getStartedButton,
                style: TextStyle(
                    color: Colors.white, fontFamily: "Livvic", fontSize: 25),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 6 * SizeConfig.imageSizeMultiplier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
