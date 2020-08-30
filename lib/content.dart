import 'dart:async';

import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/play_button.dart';
import 'package:Varithms/responsiveui.dart';
import 'package:Varithms/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Content extends StatefulWidget {
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final ScrollController _scrollControllerVertical = new ScrollController();
  bool isExpanded = false;
  double playingValue = 0;
  FlutterTtsImproved tts = new FlutterTtsImproved();
  String _wordToDisplay = "Start";
  double speed = 0.9;
  double pitch = 0.95;
  bool isSettings = false;

  MaskFilter _blur = MaskFilter.blur(BlurStyle.outer, 10.0);

  addListeners() {}

  Future<void> initPlatformState() async {
    if (!mounted) return;
    tts.setProgressHandler((String words, int start, int end, String word) {
      setState(() {
        _wordToDisplay = word;
      });
    });
  }

  Future<void> initCompletionListener() async {
    if (!mounted) return;
    tts.setCompletionHandler(() {
      _pause();
      setState(() {
        globals.isPlaying = false;
        _wordToDisplay = "Start";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    addListeners();
    initPlatformState();
    initCompletionListener();
    setSpeechPitch(pitch);
    setSpeechSpeed(speed);
  }

  _popDialog() {
    return Timer(new Duration(milliseconds: 500), () {
      Navigator.pop(context);
      _questionDialog();
    });
  }

  Future<void> _questionDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Question No. 5"),
            backgroundColor: Colors.white,
            content: Container(
                height: 400,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Loading Data...",
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 23,
                            letterSpacing: 1),
                      )
                    ],
                  ),
                ))));
  }

  Future<void> _loadingDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            content: Container(
                height: 60,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Loading Data...",
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 23,
                            letterSpacing: 1),
                      )
                    ],
                  ),
                ))));
  }

  Future<void> setSpeechPitch(double pitch) async {
    await tts.setPitch(pitch);
  }

  Future<void> setSpeechSpeed(double speed) async {
    await tts.setSpeechRate(speed);
  }

  Future _speak() async {
    var result = await tts.speak(
        "Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.");
    if (result == 1) setState(() => globals.isPlaying = true);
  }

  Future _pause() async {
    var result = await tts.stop();
    if (result == 1) setState(() => globals.isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      right: true,
      left: true,
      bottom: false,
      child: WillPopScope(
        child: Scaffold(
          backgroundColor: AppTheme.appBackgroundColor,
          body: SingleChildScrollView(
            child: ResponsiveWidget(
              portraitLayout: _portraitStack(),
              landscapeLayout: _landscapeStack(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _portraitStack() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40, left: 30, right: 30),
          height: 80,
          width: MediaQuery.of(context).size.width - 60,
          child: FittedBox(
            child: Text(
              "Quick Sort",
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 70, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            fit: BoxFit.scaleDown,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          height: 200,
          width: MediaQuery.of(context).size.width - 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.grey),
              image: DecorationImage(
                  image: Image.asset('assets/images/randomizedAlgorithm.png')
                      .image,
                  fit: BoxFit.cover)),
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width - 60,
          margin: EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                margin: EdgeInsets.only(left: 15),
                child: PlayButton(
                  initialIsPlaying: globals.isPlaying,
                  onPressed: () {
                    setState(() {
                      globals.isPlaying = !globals.isPlaying;
                    });
                    if (globals.isPlaying) {
                      _speak();
                    } else {
                      _pause();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppTheme.appBackgroundColor),
                  width: MediaQuery.of(context).size.width - 180,
                  height: 100,
                  child: Stack(
                    children: [
                      globals.isPlaying
                          ? WaveWidget(
                              config: CustomConfig(
                                gradients: [
                                  [Colors.blue, Colors.orange],
                                  [Colors.red, Colors.pink[800]],
                                  [Colors.lightBlue, Colors.yellow],
                                  [Colors.redAccent, Colors.green]
                                ],
                                durations: [35000, 19440, 10800, 6000],
                                heightPercentages: [0.20, 0.23, 0.25, 0.30],
                                blur: _blur,
                                gradientBegin: Alignment.bottomLeft,
                                gradientEnd: Alignment.topRight,
                              ),
                              backgroundColor: Colors.blue,
                              size: Size(double.infinity, double.infinity),
                              waveAmplitude: 0,
                            )
                          : Divider(
                              thickness: 1,
                              color: Colors.grey[800],
                            ),
                    ],
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 300),
          height: 65,
          width: 65,
          child: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("Dasdvfbgvgdfsa");
              setState(() {
                isSettings = !isSettings;
              });
              print(isSettings);
            },
          ),
        ),
        isSettings
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey)),
                margin: EdgeInsets.only(top: 10),
                height: 200,
                width: MediaQuery.of(context).size.width - 60,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: Row(
                        children: [
                          Text(
                            "Speed",
                            style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 230,
                            child: Slider(
                              value: speed,
                              onChanged: (value) {
                                setState(() {
                                  speed = value;
                                });

                                print(value);
                                setSpeechSpeed(value);
                                _pause();
                              },
                            ),
                          ),
                          Text(
                            "${(speed * 100).toInt()} %",
                            style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 90,
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: [
                          Text(
                            "Pitch",
                            style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 230,
                            child: Slider(
                              value: pitch,
                              onChanged: (value) {
                                setState(() {
                                  pitch = value;
                                });

                                print(value);
                                setSpeechPitch(value);
                                _pause();
                              },
                            ),
                          ),
                          Text(
                            "${(pitch * 100).toInt()} %",
                            style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(),
        Container(
            margin: EdgeInsets.only(top: 0, left: 30, right: 30),
            width: MediaQuery.of(context).size.width - 60,
            height: 100,
            child: FittedBox(
              child: Text(
                _wordToDisplay,
                style: TextStyle(fontSize: 45, fontFamily: "Livvic"),
                textAlign: TextAlign.center,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 10),
          width: MediaQuery.of(context).size.width - 60,
          child: Text(
            "Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.Hello World My goal with this plugin is to allow everyone in flutter to track where the speech is currently at. This can be used to print words on the screen as they are spoken, highlight words of a paragraph as they are uttered, for timing how long each word takes to say at a given speed, or really any other weird reason you may need it. This API is powerful, and I know people are asking for it, and there is simply not a plugin yet that covers it. Surprise! Now there is. You are welcome.",
            style: TextStyle(fontFamily: "Livvic", fontSize: 24),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 0, left: 30, right: 30),
            width: MediaQuery.of(context).size.width - 60,
            height: 100,
            child: FittedBox(
              child: Text(
                "Implementation",
                style: TextStyle(fontSize: 45, fontFamily: "Livvic"),
                textAlign: TextAlign.center,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
            margin: EdgeInsets.only(right: 250),
            width: MediaQuery.of(context).size.width - 60,
            height: 100,
            child: FittedBox(
              child: Text(
                "** In Java",
                style: TextStyle(
                    fontSize: 20, fontFamily: "Livvic", color: Colors.red),
                textAlign: TextAlign.start,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: EdgeInsets.only(left: 30, right: 30),
            height: 400,
            width: MediaQuery.of(context).size.width - 60,
            child: Scrollbar(
              controller: _scrollControllerVertical,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _scrollControllerVertical,
                    child: Text(
                      "ffgyufthdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygv\nbhhu"
                      "guvbhkhgvhbjhgvbhkdfgyuhgyfghgfhfdxcvu\nyukgfbhhu"
                      "gyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgy\nuhgyfghgf"
                      "hfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhg\nvbhkgv"
                      "hbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhh\nuguvbh"
                      "khgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\nhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkgvhbhkgv bmkhgvbknhgv bkhgvh bmnjuhib",
                      textAlign: TextAlign.justify,
                    ),
                  )),
            )),
        SizedBox(
          height: 20,
        ),
        Container(
            margin: EdgeInsets.only(right: 250),
            width: MediaQuery.of(context).size.width - 60,
            height: 100,
            child: FittedBox(
              child: Text(
                "** In Python",
                style: TextStyle(
                    fontSize: 20, fontFamily: "Livvic", color: Colors.red),
                textAlign: TextAlign.start,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: EdgeInsets.only(left: 30, right: 30),
            height: 400,
            width: MediaQuery
                .of(context)
                .size
                .width - 60,
            child: Scrollbar(
              controller: _scrollControllerVertical,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _scrollControllerVertical,
                    child: Text(
                      "ffgyufthdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygv\nbhhu"
                      "guvbhkhgvhbjhgvbhkdfgyuhgyfghgfhfdxcvu\nyukgfbhhu"
                      "gyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgy\nuhgyfghgf"
                      "hfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhg\nvbhkgv"
                      "hbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhh\nuguvbh"
                      "khgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\ngyuhgyfghgfhfdxcvuyukgfbh\nhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkdfgyuhgyfghgfhfdxcvuyukgfbhhugyvhbygvbhhuguvbhkhgvhbjhgvbhkgvhbhkgvhbhkgv bmkhgvbknhgv bkhgvh bmnjuhib",
                      textAlign: TextAlign.justify,
                    ),
                  )),
            )),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          width: 110,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(left: 240, top: 10),
          child: FlatButton(
            onPressed: () {
              _loadingDialog();
              _popDialog();
            },
            child: Text(
              "Take Quiz",
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _landscapeStack() {}
}
