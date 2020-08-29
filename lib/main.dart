import 'dart:async';

import 'package:Varithms/fill_details.dart';
import 'package:Varithms/fire_auth.dart';
import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/responsiveui.dart';
import 'package:Varithms/size_config.dart';
import 'package:Varithms/welcome.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() => runApp(Phoenix(child: MyApp()));

bool firstRun = true;
bool userValue;
FirebaseUser user;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globals.cont = context;
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              title: 'Varithms',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: StreamBuilder(
                stream: auth.onAuthStateChanged,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    user = snapshot.data;
                    globals.user.email = user.email;
                    globals.user.dp = user.photoUrl;
                    globals.user.uid = user.uid;
                    globals.user.name = user.displayName;
                  }
                  return FillDetails();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print(auth.currentUser().toString());
    getDarkMode();
    getFirstRun();
    startTime();
  }

  getDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    globals.darkModeOn = sharedPreferences.getBool("darkMode");
    if (globals.darkModeOn == null) {
      globals.darkModeOn = false;
    }
  }

  getFirstRun() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    firstRun = sharedPreferences.getBool("firstRun");
    if (firstRun == null) {
      firstRun = true;
    }
  }

  startTime() async {
    return new Timer(new Duration(milliseconds: 3950), navigator);
  }

  navigator() {
    if (firstRun) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return WelcomeScreen();
      }));
    }
    else {
      if (globals.user.email != null && globals.user.email != "") {
        fdb.FirebaseDB.getUserDetails(globals.user.uid, context);
        print(globals.user.email);
      }
      else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Login();
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.darkModeOn ? Colors.black : Color(0xFF2D3E50),
      body: ResponsiveWidget(
        portraitLayout: globals.darkModeOn
            ? portraitStackDark(context)
            : portraitStackLight(context),
        landscapeLayout: globals.darkModeOn
            ? LandscapeStackDark(context)
            : LandscapeStackLight(context),
      ),
    );
  }

  Widget portraitStackLight(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 250,
            width: 180,
            child: Image.asset('assets/v2.png'),
          ),
        ),
        Positioned(
          top: 630,
          left: 45,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Varithms",
                ],
                textStyle: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }

  Widget portraitStackDark(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 250,
            width: 180,
            child: Image.asset('assets/v1.png'),
          ),
        ),
        Positioned(
          top: 630,
          left: 45,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Varithms",
                ],
                textStyle: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }

  Widget LandscapeStackLight(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          left: 330,
          child: SizedBox(
            height: 180,
            width: 250,
            child: Image.asset('assets/v2.png'),
          ),
        ),
        Positioned(
          top: 300,
          left: 300,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Varithms",
                ],
                textStyle: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }

  Widget LandscapeStackDark(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          left: 330,
          child: SizedBox(
            height: 180,
            width: 250,
            child: Image.asset('assets/v2.png'),
          ),
        ),
        Positioned(
          top: 300,
          left: 300,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Varithms",
                ],
                textStyle: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }
}
