import 'package:distress_app/screens/address.dart';
import 'package:distress_app/screens/contact.dart';
import 'package:distress_app/screens/home.dart';
import 'package:distress_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final PageController _controller =
      PageController(keepPage: true, initialPage: 0);
  int page = 0;
  void changePage(int page) {
    _controller.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return PageView(controller: _controller, children: [
        Register(changePage: changePage),
        Address(changePage: changePage),
        EmergencyContact(changePage: changePage),
      ]);
    } else {
      return Home();
    }
  }
}
