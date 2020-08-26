import 'dart:async';

import 'package:Varithms/algorithm.dart';
import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/rating_bar.dart';
import 'package:Varithms/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AlgorithmsList extends StatefulWidget {
  @override
  _AlgorithmsListState createState() => _AlgorithmsListState();
}

class _AlgorithmsListState extends State<AlgorithmsList> {
  bool progressIndicator = true;
  double val = 0.0;

  @override
  void initState() {
    super.initState();
    algoFetch();
    progressInc();
  }

  algoT() async {
    fdb.FirebaseDB.getAlgos(globals.selectedAlgoTypeName).whenComplete(() {
      setState(() {
        progressIndicator = false;
      });
    });
  }

  algoFetch() async {
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
    return progressIndicator
        ? Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.4,
                child: WillPopScope(
                  onWillPop: () {},
                  child: Scaffold(
//              appBar: AppBar(
//                backgroundColor: Color(0xFF2D3E50),
//                automaticallyImplyLeading: false,
//              ),
                    backgroundColor: Colors.white,
                    body: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 100,
                          top: 20,
                          child: Text(globals.selectedAlgoTypeName),
                        ),
                        Positioned(
                          child: SizedBox(
                            height: SizeConfig.heightMultiplier * 48,
                            width: SizeConfig.widthMultiplier * 100,
                            child: Container(
                              color: Color(0xFF2D3E50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: LiquidCircularProgressIndicator(
                          value: val,
                          // Defaults to 0.5.
                          valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
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
            ],
          )
        : WillPopScope(
            onWillPop: () {},
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF2D3E50),
                title: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text(globals.selectedAlgoTypeName, style: TextStyle(
                      fontFamily: "Livvic", fontSize: 30, color: Colors.white),
                    textAlign: TextAlign.center,),
                ),
                automaticallyImplyLeading: false,
              ),
              backgroundColor: Color(0xFF2D3E50),
              body: Stack(
                children: <Widget>[
//                  Positioned(
//                      left: 10,
//                      top: 60,
//                      right: 10,
//                      child: SizedBox(
//                        height: 30,
//                        width: 340,
//                        child: Center(
//                          child: Text(
//                            globals.selectedAlgoTypeName,
//                            style: TextStyle(fontSize: 35, color: Colors.white),
//                          ),
//                        ),
//                      )),
                  Positioned(
                    top: SizeConfig.heightMultiplier * 44,
                    height: SizeConfig.heightMultiplier * 56,
                    width: SizeConfig.widthMultiplier * 100,
                    child: ClipPath(
                      clipper: WaveClipperOne(
                        reverse: true,
                      ),
                      child: Container(
                        color: Color(0xFFF3EFF3),
                        height: SizeConfig.heightMultiplier * 52,
                        width: SizeConfig.widthMultiplier * 100,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ListView(
                      children:
                          List.generate(globals.algoList.length, (int index) {
                        Algorithms algorithm = globals.algoList[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                              height: 270,
                          width: 320,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)
                                ),
                                elevation: 8,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      top: 20,
                                      left: 15,
                                      child: CachedNetworkImage(
                                        imageBuilder: (context,
                                            imageProvider) =>
                                            Container(
                                              width: 90.0,
                                              height: 90.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        imageUrl: algorithm.imageUrl,
                                        width: 10 *
                                            SizeConfig.imageSizeMultiplier,
                                        height: 10 *
                                            SizeConfig.imageSizeMultiplier,
                                      ),
                                    ),
                                    Positioned(
                                        top: 20,
                                        left: 120,
                                        child: Container(
                                          width: 185,
                                          height: 100,
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
                                      left: 20,
                                      top: 120,
                                      child: Text("Progress : " +
                                          algorithm.progress.toString() + "%",
                                        style: TextStyle(fontFamily: "Livvic",
                                            color: Colors.black,
                                            fontSize: 20),),
                                    ),
                                    Positioned(
                                      right: 15,
                                      top: 125,
                                      child: RatingBar(
                                        itemSize: 20,
                                        unratedColor: Colors.grey,
                                        initialRating: algorithm.difficulty
                                            .toDouble(),
                                        minRating: algorithm.difficulty
                                            .toDouble(),
                                        maxRating: algorithm.difficulty
                                            .toDouble(),
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
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
                                      top: 150,
                                      left: 20,
                                      child: SizedBox(
                                        width: 310,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey,
                                          valueColor: AlwaysStoppedAnimation<
                                              Color>(Colors.blue),
                                          value: algorithm.progress.toDouble() /
                                              100.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 170,
                                      child: SizedBox(
                                        width: 310,
                                        child: Divider(
                                          color: Colors.grey[650],
                                          thickness: 2.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 190,
                                      right: 40,
                                      child: Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            icon: Icon(Icons.chevron_right,
                                              color: Colors.black,),
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
              ),
            ),
          );
  }
}
