import 'dart:async';

import 'package:Varithms/dashboard.dart';
import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/play_button.dart';
import 'package:Varithms/question.dart';
import 'package:Varithms/responsiveui.dart';
import 'package:Varithms/size_config.dart';
import 'package:Varithms/styling.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'size_config.dart';
import 'size_config.dart';
import 'size_config.dart';
import 'size_config.dart';
import 'size_config.dart';
import 'size_config.dart';

class Content extends StatefulWidget {
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final ScrollController _scrollControllerVertical = new ScrollController();
  final ScrollController _scrollControllerHorizontal = new ScrollController();
  final ScrollController _questionScrollController = new ScrollController();
  bool isExpanded = false;
  double playingValue = 0;
  FlutterTtsImproved tts = new FlutterTtsImproved();
  String _wordToDisplay = "Start";
  double speed = 0.9;
  double pitch = 0.95;
  bool isSettings = false;
  List<Question> questions = new List<Question>();
  int currQuestion = 1;
  Question question;
  bool isQuestionCompleted = false;
  String currAnswer;
  bool ansSelected = false;
  var answers = [];
  double progress;
  TextEditingController _answerController = new TextEditingController();

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

  getQuestions() async {
    progress = 0.0;
    questions = await fdb.FirebaseDB.getQuestions(globals.selectedAlgo.name);
    question = questions[0];
    print(question.answer);

    answers = [
      question.option1,
      question.option2,
      question.option3,
      question.option4
    ];
  }

  getNextQuestion() {
    print(question.answer + "   jbk");
    if (_answerController.text == question.answer) {
      progress += 0.1;
    }
    print(progress);
    currQuestion++;
    print(currQuestion);

    if (currQuestion < questions.length) {
      question = questions[currQuestion - 1];
      answers = [
        question.option1,
        question.option2,
        question.option3,
        question.option4
      ];
    } else {
      question = questions[currQuestion - 1];
      answers = [
        question.option1,
        question.option2,
        question.option3,
        question.option4
      ];
      isQuestionCompleted = true;
    }
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
    // _loadingDialog();
    // _addInMyAlgo();
    addListeners();
    initPlatformState();
    initCompletionListener();
    setSpeechPitch(pitch);
    setSpeechSpeed(speed);
  }




  _addInMyAlgo() async {
    await fdb.FirebaseDB.addInMine();
    Navigator.pop(context);
  }

  _popDialog() {
    return Timer(new Duration(milliseconds: 500), () {
      Navigator.pop(context);
      _questionDialog();
    });
  }

  _popQuestionDialog() {
    Navigator.pop(context);
  }

  Widget _answerTile(String value) {
    return Stack(
      children: [
        Container(
          child: CircleAvatar(
            radius: 5,
            backgroundColor: globals.darkModeOn ? Colors.white : Colors.black,
            foregroundColor: globals.darkModeOn ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(
          height: SizeConfig.height(25),
        ),
        Container(
            margin: EdgeInsets.only(left: SizeConfig.width(15)),
            width: MediaQuery.of(context).size.width - SizeConfig.width(90),
            padding: EdgeInsets.only(left: SizeConfig.width(5), right: SizeConfig.width(5)),
            child: Text(
              value,
              style: TextStyle(
                  fontFamily: 'Livvic',
                  color: globals.darkModeOn ? Colors.white : Colors.black),
            ))
      ],
    );
  }

  Future<void> _questionDialog() {
    int _groupvalue = -1;
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text("Question No. ${question.questionNumber}", style: TextStyle(
            color: globals.darkModeOn ? Colors.white : Colors.black),),
        backgroundColor: globals.darkModeOn ? Colors.grey[800] : Colors.white,
        content: Container(
            height: SizeConfig.height(350),
            child: Scrollbar(
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: _questionScrollController,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - SizeConfig.width(80),
                      margin: EdgeInsets.only(right: SizeConfig.width(20)),
                      // height: 150,
                      child: Text(
                        "${question.questionNumber}. ${question.question}",
                        style: TextStyle(fontSize: 25,
                            color: globals.darkModeOn ? Colors.white : Colors
                                .black),
                        softWrap: true,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.height(20)),
                      child: Column(
                        children: List.generate(answers.length, (index) {
                          return _answerTile(answers[index]);
                        }),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - SizeConfig.width(90),
                      height: SizeConfig.height(40),
                      margin: EdgeInsets.only(left: SizeConfig.width(15), top: SizeConfig.height(150)),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: TextField(
                          style: TextStyle(fontFamily: "Livvic", fontSize: 25),
                          controller: _answerController,
                          decoration: InputDecoration(
                              hintText: "Answer",
                              contentPadding: EdgeInsets.only(
                                  left: SizeConfig.width(8.0), bottom: SizeConfig.height(8.0), right: SizeConfig.width(8.0)),
                              border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              controller: _questionScrollController,
            )),
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
                  color: globals.darkModeOn ? Colors.white : Colors.grey[800]),
            ),
          ),
          isQuestionCompleted
              ? FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (_answerController.text == question.answer) {
                      progress += 0.1;
                    }
                    _uploadingDialog();
                    await fdb.FirebaseDB.uploadProgress(
                        globals.selectedAlgo.name, progress);
                    _popQuestionDialog();
                  },
                  child: Text(
                    "Finish",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: Colors.grey[800]),
                  ),
                )
              : FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _answerController.text = "";
                    _loadingDialog();
                    getNextQuestion();
                    _popDialog();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: globals.darkModeOn ? Colors.white : Colors
                            .grey[800]),
                  ),
                )
        ],
      ),
    );
  }

  Future<void> _loadingDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            content: Container(
                height: SizeConfig.height(60),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(
                        width: SizeConfig.width(20),
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

  Future<void> _uploadingDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) =>
            AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.white,
                content: Container(
                    height: SizeConfig.height(60),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                          ),
                          SizedBox(
                            width: SizeConfig.width(20),
                          ),
                          Text(
                            "Uploading Data...",
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
    var result = await tts.speak(globals.selectedAlgo.content);
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
        onWillPop: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DashBoard();
          }));
        },
        child: Scaffold(
          backgroundColor: globals.darkModeOn ? Colors.grey[800] : AppTheme
              .appBackgroundColor,
          body: SingleChildScrollView(
            child: ResponsiveWidget(
              portraitLayout: globals.darkModeOn ? _darkStack() : _lightStack(),
              landscapeLayout: _landscapeStack(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lightStack() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: SizeConfig.height(40), left: SizeConfig.width(30), right: SizeConfig.width(30)),
          height: SizeConfig.height(80),
          width: MediaQuery
              .of(context)
              .size
              .width - SizeConfig.width(60),
          child: FittedBox(
            child: Text(
              globals.selectedAlgo.name,
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 70, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            fit: BoxFit.scaleDown,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: SizeConfig.width(30), right: SizeConfig.width(30), top: SizeConfig.height(20)),
          height: SizeConfig.width(200),
          width: MediaQuery
              .of(context)
              .size
              .width - SizeConfig.width(60),
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) =>
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - SizeConfig.width(60.0),
                  height: SizeConfig.width(200.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageUrl: globals.selectedAlgo.imageUrl,
            width: 10 * SizeConfig.imageSizeMultiplier,
            height: 10 * SizeConfig.imageSizeMultiplier,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.grey),
          ),
        ),
        Container(
          height: SizeConfig.height(100),
          width: MediaQuery.of(context).size.width - 60,
          margin: EdgeInsets.only(top: SizeConfig.height(20), left: SizeConfig.width(30), right: SizeConfig.width(30)),
          child: Row(
            children: [
              Container(
                height: SizeConfig.height(80),
                width: SizeConfig.width(80),
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
                width: SizeConfig.width(20),
              ),
              Container(
                  padding: EdgeInsets.only(top: SizeConfig.height(50), bottom: SizeConfig.height(50)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppTheme.appBackgroundColor),
                  width: MediaQuery.of(context).size.width - SizeConfig.width(180),
                  height: SizeConfig.height(100),
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
          margin: EdgeInsets.only(left: SizeConfig.width(300)),
          height: SizeConfig.height(65),
          width: SizeConfig.width(65),
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
                margin: EdgeInsets.only(top: SizeConfig.height(10)),
                height: SizeConfig.height(200),
                width: MediaQuery.of(context).size.width - SizeConfig.width(60),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: SizeConfig.width(20), top: SizeConfig.height(20)),
                      height: SizeConfig.height(100),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: SizeConfig.width(1), color: Colors.grey))),
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
                            width: SizeConfig.width(10),
                          ),
                          SizedBox(
                            width: SizeConfig.width(230),
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
                      height: SizeConfig.height(90),
                      padding: EdgeInsets.only(left:SizeConfig.width(20) , top: SizeConfig.height(20)),
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
                            width: SizeConfig.width(10),
                          ),
                          SizedBox(
                            width:SizeConfig.width(230),
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
            margin: EdgeInsets.only(top: SizeConfig.height(0), left: SizeConfig.width(30), right: SizeConfig.width(30)),
            width: MediaQuery.of(context).size.width - SizeConfig.width(60),
            height: SizeConfig.height(100),
            child: FittedBox(
              child: Text(
                _wordToDisplay,
                style: TextStyle(fontSize: 45, fontFamily: "Livvic"),
                textAlign: TextAlign.center,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
          margin: EdgeInsets.only(left: SizeConfig.width(30), right: SizeConfig.width(30), top: SizeConfig.height(10)),
          width: MediaQuery
              .of(context)
              .size
              .width -SizeConfig.width(60) ,
          child: Text(
            globals.selectedAlgo.content,
            style: TextStyle(fontFamily: "Livvic", fontSize: 24),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: SizeConfig.height(0), left: SizeConfig.width(30), right: SizeConfig.width(30)),
            width: MediaQuery.of(context).size.width - SizeConfig.width(60),
            height: SizeConfig.height(100),
            child: FittedBox(
              child: Text(
                "Implementation",
                style: TextStyle(fontSize: 45, fontFamily: "Livvic"),
                textAlign: TextAlign.center,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
            margin: EdgeInsets.only(right: SizeConfig.width(250)),
            width: MediaQuery.of(context).size.width - SizeConfig.width(60),
            height: SizeConfig.height(100),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 5)]),
            padding: EdgeInsets.only(left: SizeConfig.width(10), right: SizeConfig.width(10), top: SizeConfig.height(10), bottom: SizeConfig.height(10)),
            margin: EdgeInsets.only(left: SizeConfig.width(30), right: SizeConfig.width(30)),
            height: SizeConfig.height(400),
            width: MediaQuery
                .of(context)
                .size
                .width - SizeConfig.width(60),
            child: Scrollbar(
              controller: _scrollControllerVertical,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                  controller: _scrollControllerVertical,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      itemCount: globals.i1.length,
                      itemBuilder: (context, index) {
                        return Text(globals.i1[index]);
                      },
                    ),
                  )),
            )),
        SizedBox(
          height: SizeConfig.height(20),
        ),
        Container(
            margin: EdgeInsets.only(right: SizeConfig.width(250)),
            width: MediaQuery.of(context).size.width - SizeConfig.width(60),
            height: SizeConfig.height(100),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 5)]),
            padding: EdgeInsets.only(left: SizeConfig.width(10), right: SizeConfig.width(10), top: SizeConfig.height(10), bottom: SizeConfig.height(10)),
            margin: EdgeInsets.only(left: SizeConfig.width(30), right: SizeConfig.width(30)),
            height: SizeConfig.height(400),
            width: MediaQuery
                .of(context)
                .size
                .width - SizeConfig.width(60),
            child: Scrollbar(
              controller: _scrollControllerHorizontal,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                  controller: _scrollControllerHorizontal,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      itemCount: globals.i2.length,
                      itemBuilder: (context, index) {
                        return Text(globals.i2[index]);
                      },
                    ),
                  )),
            )),
        SizedBox(
          height: SizeConfig.height(20),
        ),
        Container(
          height: SizeConfig.height(50),
          width: SizeConfig.width(100),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(left: SizeConfig.width(240), top:SizeConfig.height(10) ),
          child: FlatButton(
            onPressed: () async {
              _loadingDialog();
              await _pause();
              await getQuestions();
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
          height: SizeConfig.height(20),
        )
      ],
    );
  }

  Widget _darkStack() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: SizeConfig.height(40), left: SizeConfig.width(30), right: SizeConfig.width(30)),
          height: SizeConfig.height(80),
          width: MediaQuery
              .of(context)
              .size
              .width - SizeConfig.width(60),
          child: FittedBox(
            child: Text(
              globals.selectedAlgo.name,
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 70, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            fit: BoxFit.scaleDown,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: SizeConfig.width(30), right: SizeConfig.width(30), top: SizeConfig.height(20)),
          height: SizeConfig.height(200),
          width: MediaQuery
              .of(context)
              .size
              .width - SizeConfig.width(60),
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) =>
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - SizeConfig.width(60),
                  height: SizeConfig.height(200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageUrl: globals.selectedAlgo.imageUrl,
            width: SizeConfig.width(10) * SizeConfig.imageSizeMultiplier,
            height: SizeConfig.height(10) * SizeConfig.imageSizeMultiplier,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.grey),
          ),
        ),
        Container(
          height: SizeConfig.height(100),
          width: MediaQuery
              .of(context)
              .size
              .width - SizeConfig.width(60),
          margin: EdgeInsets.only(top: SizeConfig.height(20), left: SizeConfig.width(30), right: SizeConfig.width(30)),
          child: Row(
            children: [
              Container(
                height:SizeConfig.height(80) ,
                width: SizeConfig.width(80),
                margin: EdgeInsets.only(left: SizeConfig.width(15)),
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
                width: SizeConfig.width(20),
              ),
              Container(
                  padding: EdgeInsets.only(top: SizeConfig.height(50), bottom: SizeConfig.height(50)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: globals.darkModeOn ? Colors.grey[800] : AppTheme
                          .appBackgroundColor),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - SizeConfig.width(180),
                  height: SizeConfig.height(100),
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
                        color: globals.darkModeOn ? Colors.white : Colors
                            .grey[800],
                      ),
                    ],
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: SizeConfig.width(300)),
          height: SizeConfig.height(65),
          width: SizeConfig.width(65),
          child: IconButton(
            icon: Icon(Icons.settings,
                color: globals.darkModeOn ? Colors.white : Colors.black),
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
              color: globals.darkModeOn ? Colors.grey : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: globals.darkModeOn ? Colors.black : Colors.grey)),
          margin: EdgeInsets.only(top: SizeConfig.height(10)),
          height: SizeConfig.height(200),
          width: MediaQuery
              .of(context)
              .size
              .width - SizeConfig.width(60),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: SizeConfig.width(20), top: SizeConfig.height(20)),
                height: SizeConfig.height(100),
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
                      width: SizeConfig.width(10),
                    ),
                    SizedBox(
                      width: SizeConfig.width(230),
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
                height: SizeConfig.height(90),
                padding: EdgeInsets.only(left: SizeConfig.width(20), top: SizeConfig.height(20)),
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
                      width: SizeConfig.width(10),
                    ),
                    SizedBox(
                      width: SizeConfig.width(230),
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
            margin: EdgeInsets.only(top: SizeConfig.height(0), left: SizeConfig.width(30), right:SizeConfig.width(30)),
            width: MediaQuery
                .of(context)
                .size
                .width -SizeConfig.width(60) ,
            height:SizeConfig.height(100) ,
            child: FittedBox(
              child: Text(
                _wordToDisplay,
                style: TextStyle(
                    fontSize: 45, fontFamily: "Livvic", color: globals
                    .darkModeOn ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
          margin: EdgeInsets.only(left: SizeConfig.width(30), right: SizeConfig.width(30), top: SizeConfig.height(10)),
          width: MediaQuery
              .of(context)
              .size
              .width - SizeConfig.width(60),
          child: Text(
            globals.selectedAlgo.content,
            style: TextStyle(fontFamily: "Livvic",
                fontSize: 24,
                color: globals.darkModeOn ? Colors.white : Colors.black),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: SizeConfig.height(0), left: SizeConfig.width(30), right: SizeConfig.width(30)),
            width: MediaQuery
                .of(context)
                .size
                .width - SizeConfig.width(60),
            height:SizeConfig.height(100) ,
            child: FittedBox(
              child: Text(
                "Implementation",
                style: TextStyle(
                    fontSize: 45, fontFamily: "Livvic", color: globals
                    .darkModeOn ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
              ),
              fit: BoxFit.scaleDown,
            )),
        Container(
            margin: EdgeInsets.only(right: SizeConfig.width(250)),
            width: MediaQuery
                .of(context)
                .size
                .width - SizeConfig.width(60),
            height: SizeConfig.height(100),
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
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 5)]),
            padding: EdgeInsets.only(left: SizeConfig.width(10), right: SizeConfig.width(10), top: SizeConfig.height(10), bottom: SizeConfig.height(10)),
            margin: EdgeInsets.only(left: SizeConfig.width(30), right: SizeConfig.width(30)),
            height: SizeConfig.height(400),
            width: MediaQuery
                .of(context)
                .size
                .width - SizeConfig.width(60),
            child: Scrollbar(
              controller: _scrollControllerVertical,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                  controller: _scrollControllerVertical,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      itemCount: globals.i1.length,
                      itemBuilder: (context, index) {
                        return Text(globals.i1[index]);
                      },
                    ),
                  )),
            )),
        SizedBox(
          height: SizeConfig.height(20),
        ),
        Container(
            margin: EdgeInsets.only(right: SizeConfig.width(250)),
            width: MediaQuery
                .of(context)
                .size
                .width -SizeConfig.width(60),
            height: SizeConfig.height(100),
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
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 5)]),
            padding: EdgeInsets.only(left: SizeConfig.width(10), right: SizeConfig.width(10), top: SizeConfig.height(10), bottom: SizeConfig.height(10)),
            margin: EdgeInsets.only(left: SizeConfig.width((30)), right: SizeConfig.width(30)),
            height: SizeConfig.height(400),
            width: MediaQuery
                .of(context)
                .size
                .width - SizeConfig.width(60),
            child: Scrollbar(
              controller: _scrollControllerHorizontal,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                  controller: _scrollControllerHorizontal,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      itemCount: globals.i2.length,
                      itemBuilder: (context, index) {
                        return Text(globals.i2[index]);
                      },
                    ),
                  )),
            )),
        SizedBox(
          height: SizeConfig.height(20),
        ),
        Container(
          height: SizeConfig.height(50),
          width: SizeConfig.width(110),
          decoration: BoxDecoration(
              color: Colors.pink, borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(left: SizeConfig.width(240), top: SizeConfig.height(10)),
          child: FlatButton(
            onPressed: () async {
              _loadingDialog();
              await _pause();
              await getQuestions();
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
          height:SizeConfig.height(20) ,
        )
      ],
    );
  }

  Widget _landscapeStack() {}
}
