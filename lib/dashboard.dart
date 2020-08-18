import 'dart:async';

import 'package:Varithms/algorithm_list.dart';
import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/responsiveui.dart';
import 'package:Varithms/settings.dart';
import 'package:Varithms/size_config.dart';
import 'package:Varithms/strings.dart';
import 'package:Varithms/styling.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  bool progressIndicator = true;
  double val = 0.0;

  @override
  void initState() {
    super.initState();
    algoTypeFetch();
    progressInc();
  }

  algoFetch() async {
    fdb.FirebaseDB.getAlgosForDashboard().whenComplete(() {
      setState(() {
        progressIndicator = false;
      });
    });
  }

  algoT() async {
    fdb.FirebaseDB.getAlgotype().whenComplete(() {
      algoFetch();
    });
  }

  algoTypeFetch() async {
    return Timer(new Duration(milliseconds: 1000), algoT);
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

  @override
  Widget build(BuildContext context) {
//    progressInc();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xD02D3E50),
          statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        backgroundColor:
        progressIndicator ? Colors.blueAccent : AppTheme.appBackgroundColor,
        body: SafeArea(
          bottom: false,
          left: true,
          right: true,
          top: true,
          child: progressIndicator
              ? Stack(children: <Widget>[
            Opacity(
              opacity: 0.4,
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/s2.png'),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: LiquidCircularProgressIndicator(
                        value: val,
                        // Defaults to 0.5.
                        valueColor:
                        AlwaysStoppedAnimation(Colors.blueAccent),
                        // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white,
                        // Defaults to the current Theme's backgroundColor.
                        borderColor: Color(0xFF2D3E50),
                        borderWidth: 5.0,
                        direction: Axis.vertical,
                        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: Text("Loading..."),
                      ),
                    )),
              ),
            )
          ])
              : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom:
                        Radius.circular(3.0 * SizeConfig.heightMultiplier),
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
                          heightFactor:
                          SizeConfig.isMobilePortrait ? 0.25 : 0.35,
                          alignment: Alignment.bottomCenter,
                          child: Tabs(),
                        ),
                        ResponsiveWidget(
                          portraitLayout: TopContainerPortrait(),
                          landscapeLayout: TopContainerLandscape(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: 100 * SizeConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      color: AppTheme.appBackgroundColor,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.0 * SizeConfig.widthMultiplier,
                              vertical: 1 * SizeConfig.heightMultiplier,
                            ),
                            child: Text(
                              Strings.popular,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .title,
                            ),
                          ),
                          AlgorithmTypeCards(context),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.0 * SizeConfig.widthMultiplier,
                              vertical: 1 * SizeConfig.heightMultiplier,
                            ),
                            child: Text(
                              Strings.joinAWorkshop,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .title,
                            ),
                          ),
                          AlgorithmCards(context),
                        ]),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget AlgorithmTypeCards(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 295.0,
          viewportFraction: 0.95,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayAnimationDuration: new Duration(milliseconds: 500)),
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
                width: 360,
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
                                      height: 30,
                                      width: 30,
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
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0 * SizeConfig.widthMultiplier),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            i.name,
                            style: Theme
                                .of(context)
                                .textTheme
                                .display1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.0 * SizeConfig.widthMultiplier,
                                bottom: 10),
                            child: Text(
                              i.noOfAlgorithms + " Courses",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle,
                            ),
                          )
                        ],
                      ),
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

  Widget AlgorithmCards(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 295.0,
          viewportFraction: 0.95,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayAnimationDuration: new Duration(milliseconds: 500)),
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
                width: 360,
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
                                      height: 30,
                                      width: 30,
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
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0 * SizeConfig.widthMultiplier),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            i.name,
                            style: Theme
                                .of(context)
                                .textTheme
                                .display1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.0 * SizeConfig.widthMultiplier,
                                bottom: 10),
                            child: Text(
                              " Courses",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle,
                            ),
                          )
                        ],
                      ),
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

class Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: AppTheme.selectedTabBackgroundColor,
                borderRadius: BorderRadius.vertical(
                    bottom:
                    Radius.circular(4.0 * SizeConfig.heightMultiplier))),
            child: Align(
              alignment: Alignment(0, SizeConfig.isMobilePortrait ? 0.3 : 0.35),
              child: Text(
                Strings.lessons,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: AppTheme.unSelectedTabBackgroundColor,
                borderRadius: BorderRadius.vertical(
                    bottom:
                    Radius.circular(3.0 * SizeConfig.heightMultiplier))),
            child: Align(
              alignment: Alignment(0, SizeConfig.isMobilePortrait ? 0.3 : 0.35),
              child: Text(
                Strings.myClasses,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopContainerPortrait extends StatefulWidget {
  @override
  _TopContainerPortraitState createState() => _TopContainerPortraitState();
}

class _TopContainerPortraitState extends State<TopContainerPortrait> {
  darkValueUpdate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool temp = sharedPreferences.getBool("darkMode");
    if (temp == null) {
      temp = false;
    }
    sharedPreferences.setBool("darkMode", !temp);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(top: 2.0 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24.0),
          ),
          color: AppTheme.topBarBackgroundColor,
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
                          ProfileImage(),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1 * SizeConfig.heightMultiplier,
                              ),
                              child: Text(
                                Strings.greetingMessage,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.0 * SizeConfig.textMultiplier,
                                ),
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
                          Strings.whatLearnToday,
                          style: TextStyle(
                            color: Colors.white,
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
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: Strings.searchHere,
                                ),
                                style: TextStyle(color: Colors.grey[500],
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
                          color: Colors.black,
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
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopContainerLandscape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    ProfileImage(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1 * SizeConfig.heightMultiplier,
                        ),
                        child: Text(
                          Strings.greetingMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 2.0 * SizeConfig.textMultiplier,
                          ),
                        ),
                      ),
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
                                    hintText: Strings.searchHere,
                                  ),
                                  style: Theme.of(context).textTheme.display2,
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
                      Strings.whatLearnToday,
                      style: TextStyle(
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
                        color: Colors.black,
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
}

class ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) =>
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: globals.user.dp,
      width: 10 * SizeConfig.imageSizeMultiplier,
      height: 10 * SizeConfig.imageSizeMultiplier,
    );
  }
}
