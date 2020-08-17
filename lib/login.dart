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
                    style: TextStyle(color: Colors.white,
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
                          msg: "Error",
                          toastLength: Toast.LENGTH_LONG);
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
                      style: TextStyle(color: Colors.white,
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
                            msg: "Error",
                            toastLength: Toast.LENGTH_LONG);
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
