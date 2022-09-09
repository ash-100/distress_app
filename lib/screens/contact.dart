import 'package:distress_app/models.dart';
import 'package:distress_app/services/auth.dart';
import 'package:distress_app/help.dart';
import 'package:flutter/material.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:distress_app/services/database.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class EmergencyContact extends StatefulWidget {
  final Function? changePage;
  final Function? getAddress2;
  final Function? getAddress3;
  final Function? getBloodGroup;
  final Function? getPhone;
  final Function? getName;

  EmergencyContact(
      {this.changePage,
      this.getAddress2,
      this.getAddress3,
      this.getBloodGroup,
      this.getPhone,
      this.getName});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Contact? contact1 = Contact();
  Contact? contact2 = Contact();
  String? address2;
  String? address3;
  String? phone;
  String? name;
  String? bloodGroup;
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? globals.Loading()
          : Consumer<RequiredHelp>(
              builder: (context, RequiredHelp notifier, _) {
              return Scaffold(
                  key: _scaffoldKey,
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        widget.changePage!(1);
                      },
                    ),
                    elevation: 0,
                  ),
                  body: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView(children: [
                            Card(
                              shadowColor: Colors.white,
                              elevation: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Emergency Contact - ' + 1.toString(),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(188, 51, 51, 1)),
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Name',
                                          hintText: 'Enter name',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.person,
                                              color: Colors.blue)),
                                      onChanged: (value) {
                                        contact1!.name = value;
                                      },
                                      validator: (value) =>
                                          value!.isEmpty ? 'Enter name' : null,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          isDense: true,
                                          labelText: 'Mobile Number',
                                          hintText: 'Enter mobile number',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.phone,
                                              color: Colors.green)),
                                      onChanged: (value) {
                                        contact1!.phone = value;
                                      },
                                      validator: (value) => value!.isEmpty
                                          ? 'Enter mobile number'
                                          : null,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        isDense: true,
                                        prefixIcon: Icon(Icons.person_add),
                                        labelText: 'Relationship',
                                        hintText: 'Enter relationship',
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLines: 1,
                                      onChanged: (value) {
                                        contact1!.relation = value;
                                      },
                                      validator: (value) => value!.isEmpty
                                          ? 'Enter relationship'
                                          : null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shadowColor: Colors.white,
                              elevation: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Emergency Contact - ' + 2.toString(),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(188, 51, 51, 1)),
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Name',
                                          hintText: 'Enter name',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.person,
                                              color: Colors.blue)),
                                      onChanged: (value) {
                                        contact2!.name = value;
                                      },
                                      validator: (value) =>
                                          value!.isEmpty ? 'Enter name' : null,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          counterText: "",
                                          labelText: 'Mobile Number',
                                          hintText: 'Enter mobile number',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.phone,
                                              color: Colors.green)),
                                      onChanged: (value) {
                                        contact2!.phone = value;
                                      },
                                      validator: (value) => value!.isEmpty
                                          ? 'Enter mobile number'
                                          : null,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Relationship',
                                          hintText: 'Enter relationship',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.person_add,
                                              color: Colors.blue)),
                                      onChanged: (value) =>
                                          contact2!.relation = value,
                                      maxLines: 1,
                                      validator: (value) => value!.isEmpty
                                          ? 'Enter relationship'
                                          : null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ])),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                address2 = widget.getAddress2!();
                                address3 = widget.getAddress3!();
                                phone = widget.getPhone!();
                                name = widget.getName!();
                                bloodGroup = widget.getBloodGroup!();
                                //print(context);

                                //print("hii");
                                try {
                                  final GoogleSignInAccount? googleUser =
                                      await AuthService().signIn();
                                  if (googleUser != null) {
                                    dynamic result = await DatabaseService(
                                            email: googleUser.email)
                                        .getUserInfo();
                                    if (result != null) {
                                      AuthService().logOut();

                                      globals.erroralertbox(
                                          'You have Already Registered!!',
                                          _scaffoldKey.currentContext!);
                                      widget.changePage!(0);

                                      //
                                    } else {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await DatabaseService(
                                              email: googleUser.email)
                                          .addUserInfo(
                                              googleUser.email,
                                              name,
                                              phone,
                                              address2,
                                              address3,
                                              contact1,
                                              contact2,
                                              // contact3,
                                              bloodGroup);

                                      // print(jsonEncode(result));
                                      notifier.setHelpstate(
                                          jsonEncode(result), 0);

                                      final GoogleSignInAuthentication
                                          googleAuth =
                                          await googleUser.authentication;

                                      final AuthCredential credential =
                                          GoogleAuthProvider.credential(
                                        accessToken: googleAuth.accessToken,
                                        idToken: googleAuth.idToken,
                                      );

                                      await AuthService()
                                          .signInWithCreds(credential);
                                    }
                                  } else {
                                    // print("4");
                                    AuthService().logOut();
                                  }
                                } catch (e) {
                                  // print(e.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                  globals.erroralertbox(
                                      'Unknown error try again later', context);
                                  widget.changePage!(0);
                                }
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
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            }),
    );
  }
}

// Widget row(index, contact1, contact2, contact3) {
//   return Card(
//     child: Container(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           Text(
//             'Emergency Contact - ' + (index + 1).toString(),
//             textAlign: TextAlign.left,
//             style: const TextStyle(
//               fontSize: 18,
//             ),
//           ),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Name',
//               hintText: 'Enter your name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Mobile Number',
//               hintText: 'Enter your mobile number',
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 1,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Relationship',
//               hintText: 'Enter your relationship',
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 1,
//           )
//         ],
//       ),
//     ),
//   );
//   // return ListTile(
//   //   title: Text(list[index]),
//   // );
// }
