import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;
String your_client_id = "226970795296107";
String your_redirect_url =
    "https://www.facebook.com/connect/login_success.html";

Future<FirebaseUser> signInWithGoogle() async {
  // hold the instance of the authenticated user

  // flag to check whether we're signed in already
  bool isSignedIn = await _googleSignIn.isSignedIn();
  if (isSignedIn) {
    // if so, return the current user
    user = await _auth.currentUser();
  } else {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    // get the credentials to (access / id token)
    // to sign in via Firebase Authentication
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    user = (await _auth.signInWithCredential(credential)).user;
  }

  return user;
}

Future<FirebaseUser> signInWithFacebook(BuildContext context) async {
  print("metod chala");
  String result = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) =>
            CustomWebView(
              selectedUrl:
              'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
            ),
        maintainState: true),);
  if (result != null) {
    try {
      final facebookAuthCred =
      FacebookAuthProvider.getCredential(accessToken: result);
      final user =
      await _auth.signInWithCredential(facebookAuthCred);
    } catch (e) {}
  }
}

Future<FirebaseUser> signOutWithGoogle() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
  return null;
}


class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.selectedUrl,
    );
  }
}
