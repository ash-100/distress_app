import 'package:distress_app/models.dart';
import 'package:distress_app/screens/address.dart';
import 'package:distress_app/screens/contact.dart';
import 'package:distress_app/screens/home.dart';
import 'package:distress_app/screens/homeAdmin.dart';
import 'package:distress_app/screens/register.dart';
import 'package:distress_app/screens/userDetails.dart';
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

  void saveAddress1(String address) {
    setState(() {
      address1 = address;
    });
  }

  void saveAddress2(String address) {
    setState(() {
      address2 = address;
    });
  }

  void saveAddress3(String address) {
    setState(() {
      address3 = address;
    });
  }

  String? getAddress1() {
    return address1;
  }

  String? getAddress2() {
    return address2;
  }

  String? getAddress3() {
    return address3;
  }

  String? address1;
  String? address2;
  String? address3;
  Contact? contact1 = Contact(name: '', phone: '', relation: '');
  Contact? contact2 = Contact(name: '', phone: '', relation: '');
  Contact? contact3 = Contact(name: '', phone: '', relation: '');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return PageView(controller: _controller, children: [
        Register(changePage: changePage),
        Address(
            changePage: changePage,
            setAddress1: saveAddress1,
            setAddress2: saveAddress2,
            setAddress3: saveAddress3),
        EmergencyContact(
          changePage: changePage,
          getAddress1: getAddress1,
          getAddress2: getAddress2,
          getAddress3: getAddress3,
        ),
      ]);
    } else {
      return Home();
    }
  }
}
