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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:distress_app/globals.dart' as globals;
import 'help.dart';
import 'dart:io';

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

  String? getAddress2() {
    return address2;
  }

  String? getAddress3() {
    return address3;
  }

  String? address2;
  String? address3;
  Contact? contact1 = Contact(name: '', phone: '', relation: '');
  Contact? contact2 = Contact(name: '', phone: '', relation: '');
  String? bloodGroup;
  String? phone;
  String? name;
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

  void saveName(String name) {
    setState(() {
      this.name = name;
    });
  }

  String? getName() {
    return name;
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future is_admin() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    //globals.getIdToken();
    String? url = "${globals.domain}/api/verify";
    try {
      dynamic response = await http
          .post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $idToken"
              },
              body: jsonEncode({"email": email}))
          .catchError((e) {
        throw Exception();
      });
      response = jsonDecode(response.body);
      return response;
    } catch (e) {
      return null;
    }
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
                setAddress2: saveAddress2,
                setAddress3: saveAddress3,
                setBloodGroup: saveBloodGroup,
                setPhone: savePhone,
                setName: saveName),
            EmergencyContact(
                changePage: changePage,
                getAddress2: getAddress2,
                getAddress3: getAddress3,
                getBloodGroup: getBloodGroup,
                getPhone: getPhone,
                getName: getName),
          ]);
    } else {
      return //Consumer<RequiredHelp>(
          //builder: (context, RequiredHelp notifier, _) {
          // return
          FutureBuilder<bool>(
              future: hasNetwork(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool? data = snapshot.data;
                  print(data);
                  if (data != null && data) {
                    return FutureBuilder(
                        future: is_admin(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            dynamic data = snapshot.data;
                            if (data['help_required']) {
                              RequiredHelp().init(jsonEncode(data), -1);
                            } else {
                              RequiredHelp().init(jsonEncode(data), 0);
                            }
                            //saveHelpstatus();
                            if (data['role'] == 'admin') {
                              return homeAdmin();
                            } else {
                              return Home();
                            }
                          } else {
                            return globals.Loading();
                          }
                        });
                  } else {
                    if (jsonDecode(RequiredHelp().userInfo)['role'] ==
                        'admin') {
                      return homeAdmin();
                    } else {
                      return Home();
                    }
                  }
                } else {
                  return globals.Loading();
                }
              });
      //});
    }
  }
}
