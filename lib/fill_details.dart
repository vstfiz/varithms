import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FillDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
              child: Container(
            height: 270,
            width: 340,
            child: Card(
              elevation: 8,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 50,
                        height: 80,
                        child: Text(
                          "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: "Livvic"),
                          softWrap: true,
                        ),
                      )),
                  Positioned(
                    left: 10,
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
                    left: 250,
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
