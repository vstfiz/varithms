import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class Test extends StatelessWidget {
  var welcomeImages = [1, 5, 14, 1, 2, 66, 2, 1, 2, 1, 2];

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Scaffold(
      body: Stack(
        children: <Widget>[
//          Center(
//            child: new TinderSwapCard(
//              orientation: AmassOrientation.RIGHT,
//              totalNum: welcomeImages.length,
//              stackNum: 3,
//              swipeEdge: 4.0,
//              allowVerticalMovement: false,
//              maxWidth: MediaQuery.of(context).size.width * 0.81,
//              maxHeight: MediaQuery.of(context).size.width * 0.6,
//              minWidth: MediaQuery.of(context).size.width * 0.8,
//              minHeight: MediaQuery.of(context).size.width * 0.599999999999,
//              cardBuilder: (context, index) => Card(
//                elevation: 8,
//
//                child: Text("Algorithm "+(index+1).toString(),style: TextStyle(fontSize: 20),),
//              ),
//              cardController: controller = CardController(),
//              swipeUpdateCallback:
//                  (DragUpdateDetails details, Alignment align) {
//                /// Get swiping card's alignment
//                if (align.x < 0) {
//                  //Card is LEFT swiping
//                } else if (align.x > 0) {
//                  //Card is RIGHT swiping
//                }
//              },
//              swipeCompleteCallback:
//                  (CardSwipeOrientation orientation, int index) {
//                /// Get orientation & index of swiped card!
//              },
//            ),
//          )

          Center()
        ],
      ),
    );
  }
}
