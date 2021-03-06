import 'package:distress_app/models.dart';
import 'package:distress_app/screens/address.dart';
import 'package:distress_app/screens/contact.dart';
import 'package:distress_app/screens/home.dart';
import 'package:distress_app/screens/homeAdmin.dart';
import 'package:distress_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:distress_app/services/database.dart';

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
  String? bloodGroup;
  String? phone;
  void saveBloodGroup(String bloodGroup) {
    setState(() {
      this.bloodGroup = bloodGroup;
    });
  }

  String? getBloodGroup() {
    return bloodGroup;
  }

  void savePhone(String phone) {
    setState(() {
      this.phone = phone;
    });
  }

  String? getPhone() {
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            // userdetails(changePage: changePage),
            Register(changePage: changePage),
            Address(
                changePage: changePage,
                setAddress1: saveAddress1,
                setAddress2: saveAddress2,
                setAddress3: saveAddress3,
                setBloodGroup: saveBloodGroup,
                setPhone: savePhone),
            EmergencyContact(
              changePage: changePage,
              getAddress1: getAddress1,
              getAddress2: getAddress2,
              getAddress3: getAddress3,
              getBloodGroup: getBloodGroup,
              getPhone: getPhone,
            ),
          ]);
    } else {
      return StreamProvider<Request?>.value(
        initialData: null,
        value: DatabaseService(email: user.email).requestStream,
        child: FutureBuilder(
            future: DatabaseService().getUserInfo(user.email),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                dynamic data = snapshot.data;

                if (data.data()['role'] == 'admin') {
                  return homeAdmin();
                } else {
                  return Home();
                }
              } else {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: SpinKitChasingDots(
                      color: Color.fromRGBO(49, 39, 79, 1),
                      size: 50,
                    ),
                  ),
                );
              }
            }),
      );
    }
  }
}
