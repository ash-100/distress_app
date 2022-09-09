// ignore_for_file: prefer_const_constructors
import 'package:provider/provider.dart';
import 'package:distress_app/help.dart';
import 'package:distress_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:distress_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  Register({this.changePage});

  final Function? changePage;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  bool loading = false;
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return loading
        ? globals.Loading()
        : Consumer<RequiredHelp>(builder: (context, RequiredHelp notifier, _) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 400,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 40,
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: width,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/sosimage.jpg'),
                                        fit: BoxFit.fill)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.44,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Raksha IITI",
                                style: TextStyle(
                                    color: Color.fromRGBO(188, 51, 51, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    final GoogleSignInAccount? googleUser =
                                        await AuthService().signIn();
                                    if (googleUser != null) {
                                      dynamic result = await DatabaseService(
                                              email: googleUser.email)
                                          .getUserInfo();
                                      if (result == null) {
                                        AuthService().logOut();
                                        setState(() {
                                          loading = false;
                                        });
                                        globals.erroralertbox(
                                            'Register First!!', context);
                                      }
                                      final GoogleSignInAuthentication
                                          googleAuth =
                                          await googleUser.authentication;

                                      final AuthCredential credential =
                                          GoogleAuthProvider.credential(
                                        accessToken: googleAuth.accessToken,
                                        idToken: googleAuth.idToken,
                                      );
                                      //print(result);
                                      //await Provider.of<RequiredHelp>
                                      notifier.setHelpstate(
                                          jsonEncode(result['userInfo']), 0);
                                      final UserCredential? authResult =
                                          await AuthService()
                                              .signInWithCreds(credential);
                                      final User? user = authResult?.user;
                                      //print(_auth.currentUser!.getIdToken());
                                      return result['userInfo'];
                                    } else {
                                      AuthService().signOut();
                                    }
                                  } catch (e) {
                                    // print(e.toString());
                                    setState(() {
                                      loading = false;
                                    });
                                    globals.erroralertbox(
                                        'Unknown Error', context);
                                    return null;
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 60),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color.fromRGBO(188, 51, 51, 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.changePage!(1);
                                },
                                child: Center(
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                        color: Color.fromRGBO(188, 51, 51, .6)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
  }
}
