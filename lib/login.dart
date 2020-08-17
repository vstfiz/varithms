import 'package:Varithms/dashboard.dart';
import 'package:Varithms/responsiveui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'fire_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) =>
              ResponsiveWidget(
                portraitLayout: PortraitStack(context),
                landscapeLayout: PortraitStack(context),
              ),
        ),
      ),
    );
  }

  Widget PortraitStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.1,
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back_login.png"),
                    fit: BoxFit.contain)),
          ),
        ),
        Positioned(
          top: 150,
          left: 30,
          right: 30,
          child: Container(
            height: 300,
            width: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 15,
              child: Text("Information Dialog"),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              width: 150,
              margin: EdgeInsets.only(left: 30, top: 500),
              child: Divider(
                thickness: 2,
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 500),
              child: Text(
                "OR",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Container(
              width: 150,
              margin: EdgeInsets.only(left: 15, top: 500),
              child: Divider(
                thickness: 2,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Positioned(
          top: 580,
          left: 50,
          right: 50,
          child: Container(
//            color: Colors.white,
            width: 260,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: FlatButton(
                    onPressed: () {
                      signInWithGoogle().whenComplete(() {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DashBoard();
                        }));
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/google.png'))),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Sign  In  With  Google",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Livvic",
                              fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF3B5998),
                      borderRadius: BorderRadius.circular(10)),
                  child: FlatButton(
                    onPressed: () {
                      signInWithFacebook(context).whenComplete(() {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DashBoard();
                        }));
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/facebook.png'))),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Sign  In  With  Facebook",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Livvic",
                              fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF02BD7E),
                      borderRadius: BorderRadius.circular(10)),
                  child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/phone.png'))),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Sign  In  With  Phone",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Livvic",
                              fontSize: 22),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 30,
            left: 10,
            right: 10,
            child: SizedBox(
              height: 80,
              width: 340,
              child: Column(
                children: <Widget>[
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Livvic",
                        fontSize: 25),
                  ),
                  FlatButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontFamily: "Livvic",
                          fontSize: 25),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }

  Widget LandscapeStack(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Card(
              elevation: 10,
              child: Text("Information Dialog"),
            ),
          ),
          Center(
            child: Text("SCreen Start"),
          ),
//                  _googleSignIn(context),
//                  _facebookSignIn(context),
          Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: SizedBox(
                height: 60,
                width: 340,
                child: FlatButton(
                  textColor: Colors.white,
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Livvic",
                          fontSize: 20),
                    ),
                  ),
                  splashColor: Colors.white,
                  onPressed: () {
                    signInWithGoogle().whenComplete(() {
                      if (user != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DashBoard();
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "Error", toastLength: Toast.LENGTH_LONG);
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color(0xFF2D3E50),
                ),
              )),
        ],
      ),
    );
  }

  Widget _facebookSignIn(BuildContext context) {}

  Widget _googleSignIn(BuildContext context) {
    return null;
  }
}
