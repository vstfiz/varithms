import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          builder: (context) => Stack(
            children: <Widget>[
              Center(
                child: Text("SCreen Start"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
