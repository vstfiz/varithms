import 'dart:async';

import 'package:Varithms/algorithm.dart';
import 'package:Varithms/firebase_database.dart' as fdb;
import 'package:Varithms/globals.dart' as globals;
import 'package:Varithms/size_config.dart';
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
//        appBar: AppBar(
//          backgroundColor: Color(0xFF2D3E50),
//          automaticallyImplyLeading: false,
//        ),
              backgroundColor: Color(0xFF2D3E50),
              body: Stack(
                children: <Widget>[
                  Positioned(
                      left: 10,
                      top: 60,
                      right: 10,
                      child: SizedBox(
                        height: 30,
                        width: 340,
                        child: Center(
                          child: Text(
                            globals.selectedAlgoTypeName,
                            style: TextStyle(fontSize: 35, color: Colors.white),
                          ),
                        ),
                      )),
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
                    margin: EdgeInsets.only(top: 130, left: 10, right: 10),
                    child: ListView(
                      children:
                          List.generate(globals.algoList.length, (int index) {
                        Algorithms algorithm = globals.algoList[index];
                        return Stack(
                          children: <Widget>[
                            Container(
                              height: 270,
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 80),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 20,
                                color: Colors.white,
                                child: Center(
                                  child: Text(
                                    "Algorithm Details",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                            )
                          ],
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
