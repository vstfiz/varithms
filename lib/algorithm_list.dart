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

import 'content.dart';

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

  Widget _loadingDialog() {
    return AlertDialog(
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
                  Text("Loading Data...", style: TextStyle(
                      fontFamily: "Livvic", fontSize: 23, letterSpacing: 1),)
                ],
              ),
            )
        )
    );
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
                    backgroundColor: Colors.grey,
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
              Center(child: _loadingDialog())
            ],
          )
        : globals.darkModeOn ? _DarkStack() : _lightStack();
  }

  Widget _lightStack() {
    return WillPopScope(
      onWillPop: () {
        globals.algoList.removeRange(0, globals.algoList.length - 1);
        Navigator.pop(context);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2D3E50),
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              globals.selectedAlgoTypeName,
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 30, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          automaticallyImplyLeading: true,
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
                children: List.generate(globals.algoList.length, (int index) {
                  Algorithms algorithm = globals.algoList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    height: 270,
                    width: 320,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 8,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 20,
                            left: 15,
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 120.0,
                                height: 180.0,
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
                            right: 15,
                            top: 125,
                            child: RatingBar(
                              itemSize: 20,
                              unratedColor: Colors.grey,
                              initialRating: algorithm.difficulty.toDouble(),
                              minRating: algorithm.difficulty.toDouble(),
                              maxRating: algorithm.difficulty.toDouble(),
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
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
                                  onPressed: () async {
                                    globals.selectedAlgo = algorithm;
                                    _loadingDialog();
                                    await fdb.FirebaseDB.addInMine();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Content();
                                    }));
                                  },
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
        ),
      ),
    );
  }

  Widget _DarkStack() {
    return WillPopScope(
      onWillPop: () {
        globals.algoList.removeRange(0, globals.algoList.length - 1);
        Navigator.pop(context);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              globals.selectedAlgoTypeName,
              style: TextStyle(
                  fontFamily: "Livvic", fontSize: 30, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Colors.orange,
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
                  color: Colors.black,
                  height: SizeConfig.heightMultiplier * 52,
                  width: SizeConfig.widthMultiplier * 100,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListView(
                children: List.generate(globals.algoList.length, (int index) {
                  Algorithms algorithm = globals.algoList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    height: 270,
                    width: 320,
                    child: Card(
                      color: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 8,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 20,
                            left: 15,
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 120.0,
                                height: 180.0,
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
                              top: 20,
                              left: 120,
                              child: Container(
                                width: 185,
                                height: 100,
                                child: Text(
                                  algorithm.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontFamily: "Livvic"),
                                  softWrap: true,
                                ),
                              )),
                          Positioned(
                            right: 15,
                            top: 125,
                            child: RatingBar(
                              itemSize: 20,
                              unratedColor: Colors.white12,
                              initialRating: algorithm.difficulty.toDouble(),
                              minRating: algorithm.difficulty.toDouble(),
                              maxRating: algorithm.difficulty.toDouble(),
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.pink,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 170,
                            child: SizedBox(
                              width: 310,
                              child: Divider(
                                color: Colors.white,
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
                                color: Colors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    globals.selectedAlgo = algorithm;
                                    _loadingDialog();
                                    await fdb.FirebaseDB.addInMine();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Content();
                                    }));
                                  },
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
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
        ),
      ),
    );
  }
}
