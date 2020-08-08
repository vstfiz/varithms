import 'package:Varithms/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Widget _googleSignIn(BuildContext context1) {
    return OutlineButton(
        splashColor: Colors.grey,
        onPressed: ()
    {
      signInWithGoogle().whenComplete(() {
        if (checkLogIn() == true) {
          ifUserExists().whenComplete(() {
            if (userExists) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DashBoard();
                  },
                ),
              );
            }
            else {
              nameController.text = name;
              emailController.text = email;
              userdp = imageUrl;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FillDetails();
                  },
                ),
              );
            }
          });
}
