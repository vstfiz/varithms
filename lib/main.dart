import 'dart:async';

import 'package:Varithms/size_config.dart';
import 'package:Varithms/welcome.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              home: SplashScreen(),
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
    startTime();
  }

  startTime() async {
    return new Timer(new Duration(milliseconds: 3950), navigator);
  }

  navigator() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return WelcomeScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3E50),
      body: Stack(
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
            left: 85,
            child: SizedBox(
              width: 290.0,
              child: TyperAnimatedTextKit(
                  speed: new Duration(milliseconds: 350),
                  onTap: () {
                    print("Tap Event");
                  },
                  text: [
                    "Varithms",
                  ],
                  textStyle: TextStyle(
                      fontSize: 60.0,
                      fontFamily: "Livvic",
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
      ),
    );
  }
}
