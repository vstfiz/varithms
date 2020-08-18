import 'dart:async';

import 'package:Varithms/dashboard.dart';
import 'package:Varithms/responsiveui.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'fire_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSignUp = false;
  bool isPhone = false;
  bool isProgress = false;
  bool otpSent = false;
  bool forgotPassword = false;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _cnfPasswordController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _otpController = new TextEditingController();

  Future<void> wait() async {
    return Timer(new Duration(milliseconds: 1000), () {
      setState(() {
        isProgress = false;
      });
    });
  }

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
              child: isProgress
                  ? _inProgress()
                  : forgotPassword
                  ? _forgotPassword()
                  : isPhone
                  ? _phoneLogin()
                  : isSignUp ? _signUp() : _login(),
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
                    onPressed: () {
                      setState(() {
                        isProgress = true;
                      });
                      wait().whenComplete(() {
                        isPhone = true;
                        isSignUp = false;
                        forgotPassword = false;
                      });
                    },
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
                  isSignUp || forgotPassword
                      ? SizedBox(
                    height: 30,
                  )
                      : Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Livvic",
                        fontSize: 25),
                  ),
                  isSignUp || forgotPassword
                      ? Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF2D3E50),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          isProgress = true;
                        });
                        wait();
                        setState(() {
                          isSignUp = false;
                          isPhone = false;
                          forgotPassword = false;
                        });
                      },
                      child: Text(
                        "Sign In with E-mail",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Livvic",
                            fontSize: 25),
                      ),
                    ),
                  )
                      : FlatButton(
                    onPressed: () {
                      setState(() {
                        isProgress = true;
                      });
                      wait();
                      setState(() {
                        isSignUp = true;
                        isPhone = false;
                        forgotPassword = false;
                      });
                    },
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

  Widget _phoneLogin() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: otpSent ? 20 : 60, horizontal: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
//                width: 25,
                child: CountryCodePicker(
                  initialSelection: 'IN',
                  favorite: ['+91', 'IN'],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 210,
                child: TextField(
                  style: TextStyle(fontFamily: "Livvic", fontSize: 25),
                  controller: _mobileController,
                  decoration: InputDecoration(hintText: "Phone", filled: true),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          otpSent
              ? Container(
            width: 290,
            child: TextField(
              obscureText: true,
              controller: _otpController,
              style: TextStyle(fontFamily: "Livvic", fontSize: 25),
              decoration: InputDecoration(
                  hintText: "4-Digit OTP",
                  prefixIcon: Icon(Icons.vpn_key),
                  filled: true),
            ),
          )
              : SizedBox(),
          otpSent
              ? Container(
            margin: EdgeInsets.only(left: 150),
            child: FlatButton(
              child: Text(
                "Resend OTP",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Livvic",
                    color: Colors.blue),
              ),
            ),
          )
              : SizedBox(),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  otpSent = true;
                });
              },
              child: otpSent
                  ? Text(
                "Login",
                style: TextStyle(
                    fontFamily: "Livvic",
                    fontSize: 22,
                    color: Colors.white),
              )
                  : Text(
                "Send OTP",
                style: TextStyle(
                    fontFamily: "Livvic",
                    fontSize: 22,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _signUp() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
      child: Column(
        children: <Widget>[
          Container(
            width: 290,
            child: TextField(
              style: TextStyle(fontFamily: "Livvic", fontSize: 25),
              controller: _usernameController,
              decoration: InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(Icons.people),
                  filled: true),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 290,
            child: TextField(
              obscureText: true,
              controller: _passwordController,
              style: TextStyle(fontFamily: "Livvic", fontSize: 25),
              decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  filled: true),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 290,
            child: TextField(
              obscureText: true,
              controller: _cnfPasswordController,
              style: TextStyle(fontFamily: "Livvic", fontSize: 25),
              decoration: InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock),
                  filled: true),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.blue),
            child: FlatButton(
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontFamily: "Livvic", fontSize: 22, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _forgotPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
      child: Column(
        children: <Widget>[
          Container(
            width: 290,
            child: TextField(
              style: TextStyle(fontFamily: "Livvic", fontSize: 25),
              controller: _usernameController,
              decoration: InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(Icons.people),
                  filled: true),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.blue),
            child: FlatButton(
              child: Text(
                "Send Recocery\nLink",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Livvic",
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _login() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        children: <Widget>[
          Container(
            width: 290,
            child: TextField(
              style: TextStyle(fontFamily: "Livvic", fontSize: 25),
              controller: _usernameController,
              decoration: InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(Icons.people),
                  filled: true),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 290,
            child: TextField(
              obscureText: true,
              controller: _passwordController,
              style: TextStyle(fontFamily: "Livvic", fontSize: 25),
              decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  filled: true),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 150),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  isProgress = true;
                  print(isProgress);
                });
                wait();
                setState(() {
                  forgotPassword = true;
                });
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    fontSize: 20, fontFamily: "Livvic", color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.blue),
            child: FlatButton(
              child: Text(
                "Login",
                style: TextStyle(
                    fontFamily: "Livvic", fontSize: 22, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _inProgress() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      ),
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
}
