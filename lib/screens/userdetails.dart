// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, camel_case_types, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distress_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

_launchPhoneURL(String phoneNumber) async {
  String url = 'tel:' + phoneNumber;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class userDetails extends StatefulWidget {
  String email;
  userDetails(this.email);
  @override
  // ignore: unnecessary_this
  State<userDetails> createState() => _userDetailsState(this.email);
}

class _userDetailsState extends State<userDetails> {
  String email;
  _userDetailsState(this.email);
  var firestoreInstance = FirebaseFirestore.instance;
  dynamic details;

  void fetchUserDetails() {
    firestoreInstance.collection('users').doc(email).get().then((value) {
      setState(() {
        print(value.data());
        details = value.data()!;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //fetchUserDetails();

    ///whatever you want to run on page build
  }

  @override
  Widget build(BuildContext context) {
    print(email);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: DatabaseService().getUserInfo(email),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  details = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Phone',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['phone'].toString()),
                            Text(
                              'Hostel Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['address1'].toString()),
                            Text(
                              'Temporary Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['address2'].toString()),
                            Text(
                              'Permanent Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['address3'].toString()),
                            Text(
                              'Blood Group',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['bloodGroup'].toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Emergency Contact - 1',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['emergencyContact1']['name']
                                .toString()),
                            Text(
                              'Phone',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['emergencyContact1']['phone']
                                .toString()),
                            Text(
                              'Relation',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['emergencyContact1']['relation']
                                .toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Emergency Contact - 2',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['emergencyContact2']['name']
                                .toString()),
                            Text(
                              'Phone',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['emergencyContact2']['phone']
                                .toString()),
                            Text(
                              'Relation',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(details['emergencyContact2']['relation']
                                .toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      details['emergencyContact3']['name'] != null ||
                              details['emergencyContact3']['phone'] != null ||
                              details['emergencyContact3']['relation'] != null
                          ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Emergency Contact - 3',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(details['emergencyContact3']['name']
                                      .toString()),
                                  Text(
                                    'Phone',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(details['emergencyContact3']['phone']
                                      .toString()),
                                  Text(
                                    'Relation',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(details['emergencyContact3']['relation']
                                      .toString()),
                                ],
                              ),
                            )
                          : SizedBox(height: 1),
                      GestureDetector(
                        onTap: () {
                          displayLocation();
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              "View Location",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   child: Text('View Location'),
                      //   onPressed: displayLocation,
                      // ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _launchPhoneURL(details['phone'].toString());
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: Text(
                              "Contact Person",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   child: Text('Contact person'),
                      //   onPressed: () {
                      //     _launchPhoneURL(details['phone'].toString());
                      //   },
                      // )
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }

  void displayLocation() {
    var latitude = '0', longitude = '0';
    print('email $email ');
    firestoreInstance
        .collection('users-help-required')
        .doc(email.trim())
        .get()
        .then((value) {
      print(value.data());
      if (value.data().toString().contains('latitude'))
        latitude = value.data()!['latitude'];
      if (value.data().toString().contains('longitude'))
        longitude = value.data()!['longitude'];
      print(latitude);
      launchURL(
          'https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}');
    });
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}



//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
//
// class userDetails extends StatelessWidget{
//   final String email;
//   const userDetails({required Key key, required this.email}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     print(email);
//     return Scaffold(
//       body: Column(
//         children: [
//           Text('Details'),
//           ElevatedButton(
//               onPressed:launchUrl,
//               child: Text('View Location'))
//         ],
//       ),
//     );
//   }
//   launchUrl() async {
//     var url='https://stackoverflow.com/questions/65883844/flutter-url-launcher-is-not-launching-url-in-release-mode';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }

