import 'dart:async';

import 'package:Varithms/algorithm_list.dart';
import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/rating_bar.dart';
import 'package:Varithms/responsiveui.dart';
import 'package:Varithms/searching.dart';
import 'package:Varithms/settings.dart';
import 'package:Varithms/size_config.dart';
import 'package:Varithms/strings.dart';
import 'package:Varithms/styling.dart';
import 'package:Varithms/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'algorithm.dart';

bool isMyAlgorithms = false;

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  bool progressIndicator = true;
  bool myAlgoProgress = false;
  bool isSearching = false;
  double val = 0.0;

  @override
  void initState() {
    super.initState();
    algoTypeFetch();
    progressInc();
  }

  myAlgoT() async {
    if (globals.myAlgoList.length != 0) {
      globals.myAlgoList.removeRange(0, globals.myAlgoList.length - 1);
    }
    fdb.FirebaseDB.getMyAlgos().whenComplete(() {
      print("Length :" + globals.myAlgoList.length.toString());
      setState(() {
        isMyAlgorithms = true;
        myAlgoProgress = true;
      });
      myAlgoUpdate();
    });
  }

  myAlgoFetch() async {
    return Timer(new Duration(milliseconds: 1000), myAlgoT);
  }

  algoFetch() async {
    fdb.FirebaseDB.getAlgosForDashboard().whenComplete(() {
      setState(() {
        progressIndicator = false;
      });
    });
    print("vdsfdbdfb");
    for (var i in globals.algoList) {
      print(i.category);
    }
  }

  algoT() async {
    fdb.FirebaseDB.getAlgotype().whenComplete(() {
      algoFetch();
    });
  }

  algoTypeFetch() async {
    return Timer(new Duration(milliseconds: 1500), algoT);
  }

  void progressInc() async {
    if (val < 1.0) {
      setState(() {
        val += 0.01;
      });
    }
    wait();
  }

  wait() async {
    return Timer(new Duration(milliseconds: 10), progressInc);
  }

  darkValueUpdate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool temp = sharedPreferences.getBool("darkMode");
    if (temp == null) {
      temp = false;
    }
    sharedPreferences.setBool("darkMode", !temp);
  }

  myAlgoUpdate() async {
    return Timer(new Duration(milliseconds: 1000), hideDialog);
  }

  hideDialog() {
    Navigator.pop(context);
  }

  Future<void> exitDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: globals.darkModeOn ? Colors.grey[800] : Colors
                  .white,
              title: Text(
                "Exit",
                style: TextStyle(fontSize: 30,
                    fontFamily: "Livvic",
                    color: globals.darkModeOn ? Colors.white : Colors.black),
              ),
              content: Text(
                "Do you want to exit ?",
                style: TextStyle(fontSize: 20,
                    fontFamily: "Livvic",
                    color: globals.darkModeOn ? Colors.white : Colors.black),
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
                        color: globals.darkModeOn ? Colors.orange : Colors
                            .grey[800]),
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
                        color: globals.darkModeOn ? Colors.orange : Colors
                            .grey[800]),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xD02D3E50),
          statusBarBrightness: Brightness.light),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
              exitDialog();
              return Future<bool>.value(false);
          },
          child: Scaffold(
            backgroundColor: progressIndicator
                ? Colors.blueAccent
                : globals.darkModeOn ? Colors.grey[800] : AppTheme
                .appBackgroundColor,
            body: SafeArea(
              bottom: false,
              left: true,
              right: true,
              top: true,
              child: progressIndicator
                  ? Stack(children: <Widget>[
                Opacity(
                    opacity: 0.5,
                    child: SingleChildScrollView(
                      child: ResponsiveWidget(
                        portraitLayout: _portraitStack(),
                        landscapeLayout: _landscapeStack(),
                      ),
                    )
//                SizedBox(
//                  height: MediaQuery
//                      .of(context)
//                      .size
//                      .height,
//                  width: MediaQuery
//                      .of(context)
//                      .size
//                      .width,
//                  child: Container(
//                    decoration: BoxDecoration(
//                        image: DecorationImage(
//                            image: AssetImage('assets/s2.png'),
//                            fit: BoxFit.cover)),
//                  ),
//                ),
                ),
                Center(
                  child: _loadingDialog(),
                )

//              Center(
//                child: Container(
//                  height: 300,
//                  width: 300,
//                  child: AlertDialog(
//                      elevation: 8,
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(15)),
//                      content: Container(
//                        height: 150,
//                        width: 150,
//                        child: LiquidCircularProgressIndicator(
//                          value: val,
//                          // Defaults to 0.5.
//                          valueColor:
//                          AlwaysStoppedAnimation(Colors.blueAccent),
//                          // Defaults to the current Theme's accentColor.
//                          backgroundColor: Colors.white,
//                          // Defaults to the current Theme's backgroundColor.
//                          borderColor: Color(0xFF2D3E50),
//                          borderWidth: 5.0,
//                          direction: Axis.vertical,
//                          // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
//                          center: Text("Loading..."),
//                        ),
//                      )),
//                ),
//              )
              ])
                  : SingleChildScrollView(
                  child: ResponsiveWidget(
                    portraitLayout: isMyAlgorithms
                        ? globals.darkModeOn
                        ? _portraitMyAlgoStackDark()
                        : _portraitMyAlgoStack()
                        : globals.darkModeOn
                        ? _portraitStackDark()
                        : _portraitStack(),
                    landscapeLayout: isMyAlgorithms
                        ? _landscapeMyAlgoStack()
                        : _landscapeStack(),
                  )),
            ),
          ),
        ),
      ),
    );
  }



  Widget _portraitMyAlgoStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(3.0 * SizeConfig.heightMultiplier),
            ),
          ),
          constraints: BoxConstraints(
              maxHeight: 40 *
                  (SizeConfig.isMobilePortrait
                      ? SizeConfig.heightMultiplier
                      : SizeConfig.widthMultiplier)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FractionallySizedBox(
                heightFactor: SizeConfig.isMobilePortrait ? 0.25 : 0.35,
                alignment: Alignment.bottomCenter,
                child: _tabs(context),
              ),
              ResponsiveWidget(
                portraitLayout: _topContainerPortrait(context),
                landscapeLayout: _topContainerLandscape(context),
              ),
            ],
          ),
        ),
        Container(
          constraints:
          BoxConstraints(maxHeight: 100 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            color: Color(0xFFFFF7BC),
          ),
          child: ListView(
            children: List.generate(globals.myAlgoList.length, (int index) {
              Algorithms algorithm = globals.myAlgoList[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                height: SizeConfig.height(270),
                width: SizeConfig.width(320),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 8,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top:SizeConfig.height(20) ,
                        left: SizeConfig.width(15),
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                width: SizeConfig.width(90.0),
                                height: SizeConfig.height(90),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl: algorithm.imageUrl,
                          width: 10 * SizeConfig.imageSizeMultiplier,
                          height: 10 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                      Positioned(
                          top: SizeConfig.height(20),
                          left: SizeConfig.width(120),
                          child: Container(
                            width: SizeConfig.width(185),
                            height: SizeConfig.height(100),
                            child: Text(
                              algorithm.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontFamily: "Livvic"),
                              softWrap: true,
                            ),
                          )),
                      Positioned(
                        left: SizeConfig.width(20),
                        top: SizeConfig.height(120),
                        child: Text(
                          "Progress : " + algorithm.progress.toString() + "%",
                          style: TextStyle(
                              fontFamily: "Livvic",
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Positioned(
                        right: SizeConfig.width(15),
                        top: SizeConfig.height(125),
                        child: RatingBar(
                          itemSize: 20,
                          unratedColor: Colors.grey,
                          initialRating: algorithm.difficulty.toDouble(),
                          minRating: algorithm.difficulty.toDouble(),
                          maxRating: algorithm.difficulty.toDouble(),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) =>
                              Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      Positioned(
                        top: SizeConfig.height(150),
                        left: SizeConfig.width(20),
                        child: SizedBox(
                          width: SizeConfig.width(310),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue),
                            value: algorithm.progress.toDouble() / 100.0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: SizeConfig.width(20),
                        top: SizeConfig.height(170),
                        child: SizedBox(
                          width: SizeConfig.width(310),
                          child: Divider(
                            color: Colors.grey[650],
                            thickness: 2.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: SizeConfig.height(190),
                        right: SizeConfig.width(40),
                        child: Container(
                          width: SizeConfig.width(55),
                          height: SizeConfig.height(55),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _portraitMyAlgoStackDark() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: globals.darkModeOn ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(3.0 * SizeConfig.heightMultiplier),
            ),
          ),
          constraints: BoxConstraints(
              maxHeight: 40 *
                  (SizeConfig.isMobilePortrait
                      ? SizeConfig.heightMultiplier
                      : SizeConfig.widthMultiplier)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FractionallySizedBox(
                heightFactor: SizeConfig.isMobilePortrait ? 0.25 : 0.35,
                alignment: Alignment.bottomCenter,
                child: _tabs(context),
              ),
              ResponsiveWidget(
                portraitLayout: _topContainerPortrait(context),
                landscapeLayout: _topContainerLandscape(context),
              ),
            ],
          ),
        ),
        Container(
          constraints:
          BoxConstraints(maxHeight: 100 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            color: globals.darkModeOn ? Colors.grey[800] : Color(0xFFFFF7BC),
          ),
          child: ListView(
            children: List.generate(globals.myAlgoList.length, (int index) {
              Algorithms algorithm = globals.myAlgoList[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                height: SizeConfig.height(270),
                width: SizeConfig.width(320),
                child: Card(
                  color: globals.darkModeOn ? Colors.grey : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 8,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: SizeConfig.height(20),
                        left: SizeConfig.width(15),
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                width: SizeConfig.width(90.0),
                                height: SizeConfig.height(90.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl: algorithm.imageUrl,
                          width: SizeConfig.width(10) * SizeConfig.imageSizeMultiplier,
                          height: SizeConfig.height(10) * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                      Positioned(
                          top: SizeConfig.height(20),
                          left: SizeConfig.width(120),
                          child: Container(
                            width: SizeConfig.width(185),
                            height: SizeConfig.height(100),
                            child: Text(
                              algorithm.name,
                              style: TextStyle(
                                  color: globals.darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 35,
                                  fontFamily: "Livvic"),
                              softWrap: true,
                            ),
                          )),
                      Positioned(
                        left: SizeConfig.width(20),
                        top: SizeConfig.height(120),
                        child: Text(
                          "Progress : " + algorithm.progress.toString() + "%",
                          style: TextStyle(
                              fontFamily: "Livvic",
                              color: globals.darkModeOn ? Colors.white : Colors
                                  .black,
                              fontSize: 20),
                        ),
                      ),
                      Positioned(
                        right: SizeConfig.width(15),
                        top: SizeConfig.height(125),
                        child: RatingBar(
                          itemSize: 20,
                          unratedColor: Colors.white12,
                          initialRating: algorithm.difficulty.toDouble(),
                          minRating: algorithm.difficulty.toDouble(),
                          maxRating: algorithm.difficulty.toDouble(),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) =>
                              Icon(
                                Icons.star,
                                color: Colors.pink,
                              ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      Positioned(
                        top: SizeConfig.height(150),
                        left:SizeConfig.width(20),
                        child: SizedBox(
                          width: SizeConfig.width(310),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                                globals.darkModeOn ? Colors.orange : Colors
                                    .blue),
                            value: algorithm.progress.toDouble() / 100.0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: SizeConfig.width(20),
                        top: SizeConfig.height(170),
                        child: SizedBox(
                          width: SizeConfig.width(310),
                          child: Divider(
                            color: Colors.black,
                            thickness: 2.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: SizeConfig.height(190),
                        right: SizeConfig.width(40),
                        child: Container(
                          width: SizeConfig.width(55),
                          height: SizeConfig.height(55),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: globals.darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _landscapeMyAlgoStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(3.0 * SizeConfig.heightMultiplier),
            ),
          ),
          constraints: BoxConstraints(
              maxHeight: 40 *
                  (SizeConfig.isMobilePortrait
                      ? SizeConfig.heightMultiplier
                      : SizeConfig.widthMultiplier)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FractionallySizedBox(
                heightFactor: SizeConfig.isMobilePortrait ? 0.25 : 0.35,
                alignment: Alignment.bottomCenter,
                child: _tabs(context),
              ),
              ResponsiveWidget(
                portraitLayout: _topContainerPortrait(context),
                landscapeLayout: _topContainerLandscape(context),
              ),
            ],
          ),
        ),
        Container(
          constraints:
          BoxConstraints(maxHeight: 100 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            color: AppTheme.appBackgroundColor,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.0 * SizeConfig.widthMultiplier,
                    vertical: 3 * SizeConfig.heightMultiplier,
                  ),
                  child: Text(
                    "Algorithm Types",
                    style: TextStyle(
                      fontFamily: "Livvic",
                      fontSize: 30,
                    ),
                  ),
                ),
                _algorithmTypeCards(context),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0 * SizeConfig.widthMultiplier,
                    vertical: 3 * SizeConfig.heightMultiplier,
                  ),
                  child: Text(
                    "Learn an Algorithm",
                    style: TextStyle(
                      fontFamily: "Livvic",
                      fontSize: 30,
                    ),
                  ),
                ),
                _algorithmCards(context),
              ]),
        ),
      ],
    );
  }

  Widget _topContainerLandscape(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24.0),
          ),
          color: AppTheme.topBarBackgroundColor,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 2.0 * SizeConfig.heightMultiplier,
                  right: 2.0 * SizeConfig.heightMultiplier,
                  top: 1.0 * SizeConfig.heightMultiplier,
                ),
                child: Row(
                  children: <Widget>[
                    _profileImage(context),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1 * SizeConfig.heightMultiplier,
                          ),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => UserProfile()));
                            },
                            child: Text(
                              Strings.greetingMessage,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontFamily: "Livvic"),
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              size: 3 * SizeConfig.heightMultiplier,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1 * SizeConfig.heightMultiplier,
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search here",
                                  ),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .display2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.blur_on,
                      color: Colors.white,
                      size: 8 * SizeConfig.imageSizeMultiplier,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 2.0 * SizeConfig.heightMultiplier,
                    bottom: 1.5 * SizeConfig.heightMultiplier),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Curious about an algorithm ?",
                      style: TextStyle(
                        fontFamily: "Livvic",
                        color: Colors.white,
                        fontSize: 3.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 10 * SizeConfig.heightMultiplier,
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * SizeConfig.heightMultiplier),
                      decoration: BoxDecoration(
                        color: globals.darkModeOn ? Colors.pink : Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              3.0 * SizeConfig.heightMultiplier),
                          bottomLeft: Radius.circular(
                              3.0 * SizeConfig.heightMultiplier),
                        ),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 6 * SizeConfig.imageSizeMultiplier,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topContainerPortrait(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(top: 2.0 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24.0),
          ),
          color: globals.darkModeOn ? Colors.black : AppTheme
              .topBarBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
                width: double.maxFinite,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _profileImage(context),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1 * SizeConfig.heightMultiplier,
                              ),
                              child: Text(
                                Strings.greetingMessage,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    fontFamily: "Livvic"),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.blur_on,
                              color: Colors.white,
                            ),
                            iconSize: 8 * SizeConfig.imageSizeMultiplier,
                            onPressed: () {
                              darkValueUpdate();
                              Phoenix.rebirth(globals.cont);
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Curious about an algorithm ?",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Livvic",
                            fontSize: 3.5 * SizeConfig.textMultiplier,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.heightMultiplier,
                bottom: 2.5 * SizeConfig.heightMultiplier,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.heightMultiplier),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(45),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            size: 3 * SizeConfig.heightMultiplier,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1 * SizeConfig.heightMultiplier,
                              ),
                              child: TextField(
                                onChanged: (searchValue) {
                                  print(searchValue);
                                },
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Searching();
                                      }));
                                  print("value of isSearching : " +
                                      isSearching.toString());
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search here",
                                ),
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 20,
                                    fontFamily: "Livvic"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 2,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          color: globals.darkModeOn ? Colors.pink : Colors
                              .black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                4.0 * SizeConfig.heightMultiplier),
                            bottomLeft: Radius.circular(
                                4.0 * SizeConfig.heightMultiplier),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return Settings();
                                },
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 6 * SizeConfig.imageSizeMultiplier,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _loadingDialog() {
    return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: globals.darkModeOn ? Colors.grey[800] : Colors.white,
        content: Container(
            height: SizeConfig.height(60),
            child: Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        globals.darkModeOn ? Colors.orange : Colors.blue),
                  ),
                  SizedBox(
                    width: SizeConfig.width(20),
                  ),
                  Text(
                    "Loading Data...",
                    style: TextStyle(
                        fontFamily: "Livvic",
                        fontSize: 23,
                        letterSpacing: 1,
                        color: globals.darkModeOn ? Colors.white : Colors
                            .black),
                  )
                ],
              ),
            )));
  }

  Widget _tabs(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                isMyAlgorithms = false;
              });
              print(isMyAlgorithms);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isMyAlgorithms
                      ? AppTheme.unSelectedTabBackgroundColor
                      : AppTheme.selectedTabBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                      bottom:
                      Radius.circular(4.0 * SizeConfig.heightMultiplier))),
              child: Align(
                alignment:
                Alignment(0, SizeConfig.isMobilePortrait ? 0.3 : 0.35),
                child: Text(
                  "Algorithms",
                  style: TextStyle(
                    color: isMyAlgorithms ? globals.darkModeOn
                        ? Colors.white
                        : Colors.black : Colors.white,
                    fontFamily: "Livvic",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => _loadingDialog());
              myAlgoT();

//              myAlgoUpdate();
              print(isMyAlgorithms);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isMyAlgorithms
                      ? AppTheme.selectedTabBackgroundColor
                      : AppTheme.unSelectedTabBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                      bottom:
                      Radius.circular(3.0 * SizeConfig.heightMultiplier))),
              child: Align(
                alignment:
                Alignment(0, SizeConfig.isMobilePortrait ? 0.3 : 0.35),
                child: Text(
                  "My Algortihms",
                  style: TextStyle(
                      fontSize: isMyAlgorithms ? 25 : 20,
                      fontFamily: "Livvic",
                      color: isMyAlgorithms ? Colors.white : globals.darkModeOn
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _portraitStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(3.0 * SizeConfig.heightMultiplier),
            ),
          ),
          constraints: BoxConstraints(
              maxHeight: 40 *
                  (SizeConfig.isMobilePortrait
                      ? SizeConfig.heightMultiplier
                      : SizeConfig.widthMultiplier)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FractionallySizedBox(
                heightFactor: SizeConfig.isMobilePortrait ? 0.25 : 0.35,
                alignment: Alignment.bottomCenter,
                child: _tabs(context),
              ),
              ResponsiveWidget(
                portraitLayout: _topContainerPortrait(context),
                landscapeLayout: _topContainerLandscape(context),
              ),
            ],
          ),
        ),
        Container(
          constraints:
          BoxConstraints(maxHeight: 100 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            color: AppTheme.appBackgroundColor,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.0 * SizeConfig.widthMultiplier,
                    vertical: 3 * SizeConfig.heightMultiplier,
                  ),
                  child: Text(
                    "Algorithm Types",
                    style: TextStyle(
                      fontFamily: "Livvic",
                      fontSize: 30,
                    ),
                  ),
                ),
                _algorithmTypeCards(context),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0 * SizeConfig.widthMultiplier,
                    vertical: 3 * SizeConfig.heightMultiplier,
                  ),
                  child: Text(
                    "Learn an Algorithm",
                    style: TextStyle(
                      fontFamily: "Livvic",
                      fontSize: 30,
                    ),
                  ),
                ),
                _algorithmCards(context),
              ]),
        ),
      ],
    );
  }

  Widget _portraitStackDark() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(3.0 * SizeConfig.heightMultiplier),
            ),
          ),
          constraints: BoxConstraints(
              maxHeight: 40 *
                  (SizeConfig.isMobilePortrait
                      ? SizeConfig.heightMultiplier
                      : SizeConfig.widthMultiplier)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FractionallySizedBox(
                heightFactor: SizeConfig.isMobilePortrait ? 0.25 : 0.35,
                alignment: Alignment.bottomCenter,
                child: _tabs(context),
              ),
              ResponsiveWidget(
                portraitLayout: _topContainerPortrait(context),
                landscapeLayout: _topContainerLandscape(context),
              ),
            ],
          ),
        ),
        Container(
          constraints:
          BoxConstraints(maxHeight: 100 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            color: globals.darkModeOn ? Colors.grey[800] : AppTheme
                .appBackgroundColor,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.0 * SizeConfig.widthMultiplier,
                    vertical: 3 * SizeConfig.heightMultiplier,
                  ),
                  child: Text(
                    "Algorithm Types",
                    style: TextStyle(
                      fontFamily: "Livvic",
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                _algorithmTypeCards(context),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0 * SizeConfig.widthMultiplier,
                    vertical: 3 * SizeConfig.heightMultiplier,
                  ),
                  child: Text(
                    "Learn an Algorithm",
                    style: TextStyle(
                        fontFamily: "Livvic",
                        fontSize: 30,
                        color: Colors.white
                    ),
                  ),
                ),
                _algorithmCards(context),
              ]),
        ),
      ],
    );
  }

  Widget _profileImage(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) =>
          Container(
            width: 50.0,
            height: 50.0,
            child: FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfile()));
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: globals.mainUser.dp,
      width: 10 * SizeConfig.imageSizeMultiplier,
      height: 10 * SizeConfig.imageSizeMultiplier,
    );
  }

  Widget _landscapeStack() {
    Container(
      height: 917.6470759830676,
      width: 423.5294196844927,
      child: _portraitStack(),
      margin: EdgeInsets.symmetric(
          horizontal:
              (MediaQuery.of(context).size.width - 423.5294196844927) / 2,
          vertical:
              (MediaQuery.of(context).size.width - 917.6470759830676) / 2),
    );
  }

  Widget _algorithmTypeCards(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: SizeConfig.height(295),
          viewportFraction: 0.95,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayAnimationDuration: new Duration(milliseconds: 1000)),
      items: globals.algoTypeList.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return FlatButton(
              onPressed: () {
                globals.selectedAlgoTypeName = i.name;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AlgorithmsList();
                    },
                  ),
                );
              },
              child: Container(
                width: SizeConfig.width(360),
                margin: EdgeInsets.symmetric(
                    horizontal: 1 * SizeConfig.widthMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(3 * SizeConfig.heightMultiplier),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3 * SizeConfig.heightMultiplier),
                        ),
                        child: AspectRatio(
                            aspectRatio: 3,
                            child: CachedNetworkImage(
                              imageUrl: i.imageUrl,
                              placeholder: (context, url) =>
                                  Center(
                                    child: SizedBox(
                                      height: SizeConfig.height(30),
                                      width: SizeConfig.width(30),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5)),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(30),
                    ),
                    Container(
                      width: SizeConfig.width(360),
                      child: Text(
                        i.name,
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(10),
                    ),
                    Container(
                      width: SizeConfig.width(360),
                      child: Text(
                        i.noOfAlgorithms + " Courses",
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(5),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _algorithmCards(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: SizeConfig.height(295),
          viewportFraction: 0.95,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayAnimationDuration: new Duration(milliseconds: 300)),
      items: globals.algoListForDashboard.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return FlatButton(
              onPressed: () {
                globals.selectedAlgoTypeName = i.name;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AlgorithmsList();
                    },
                  ),
                );
              },
              child: Container(
//                width: 360,
                margin: EdgeInsets.symmetric(
                    horizontal: 1 * SizeConfig.widthMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(3 * SizeConfig.heightMultiplier),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3 * SizeConfig.heightMultiplier),
                        ),
                        child: AspectRatio(
                            aspectRatio: 3,
                            child: CachedNetworkImage(
                              imageUrl: i.imageUrl,
                              placeholder: (context, url) =>
                                  Center(
                                    child: SizedBox(
                                      height: SizeConfig.height(30),
                                      width: SizeConfig.width(30),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5)),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(30),
                    ),
                    Container(
                      width: SizeConfig.width(360),
                      child: Text(
                        i.name,
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(10),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}


// def knapSack(W, wt, val, n):
// # Base Case  \n\t    if n == 0 or W == 0 :
// return 0
// # If weight of the nth item is more than Knapsack of capacity
// # W, then this item cannot be included in the optimal solution
// if (wt[n-1] > W):\n\t
//   return knapSack(W, wt, val, n-1)
// # return the maximum of two cases:
// # (1) nth item included
// # (2) not included
// else:
//   return max(val[n-1] + knapSack(W-wt[n-1], wt, val, n-1), knapSack(W, wt, val, n-1))
// # end of function knapSack
// # To test above function  val = [60, 100, 120]  wt = [10, 20, 30]  W = 50 n = len(val)
// print knapSack(W, wt, val, n)