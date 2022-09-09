// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, camel_case_types, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, avoid_print, file_names

import 'package:distress_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class userDetails extends StatefulWidget {
  String email;
  String latitude;
  String longitude;
  userDetails(this.email, this.latitude, this.longitude);
  @override
  // ignore: unnecessary_this
  State<userDetails> createState() =>
      _userDetailsState(this.email, this.latitude, this.longitude);
}

class _userDetailsState extends State<userDetails> {
  String email;
  String latitude;
  String longitude;
  _userDetailsState(this.email, this.latitude, this.longitude);
  dynamic details;

  @override
  void initState() {
    super.initState();
    //fetchUserDetails();

    ///whatever you want to run on page build
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: DatabaseService(email: email).getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  details = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  spreadRadius: 1,
                                  blurRadius: 6)
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    // text: 'Hello ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Name: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: details['name']),
                                    ],
                                  ),
                                )),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    // text: 'Hello ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Phone: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: details['mobile_no']),
                                    ],
                                  ),
                                )),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  // text: 'Hello ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Temporary address: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: details['temporary_address']),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    // text: 'Hello ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Permanent address: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: details['permanent_address']),
                                    ],
                                  ),
                                )),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    // text: 'Hello ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Blood group: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: details['blood_group']),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          //padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          itemCount: details['emergency_contact'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: 1,
                                            blurRadius: 6)
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Emergency Contact - ${index + 1}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              // text: 'Hello ',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Name: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: details[
                                                            'emergency_contact']
                                                        [index]['name']),
                                              ],
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              // text: 'Hello ',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Phone: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: details[
                                                            'emergency_contact']
                                                        [index]['mobile_no']),
                                              ],
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              // text: 'Hello ',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Relation: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: details[
                                                            'emergency_contact']
                                                        [index]['relation']),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                      GestureDetector(
                        onTap: () {
                          displayLocation(latitude, longitude);
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
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          FlutterPhoneDirectCaller.callNumber(
                              '91' + details['mobile_no']);
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

  void displayLocation(String latitude, String longitude) {
    launchURL(
        'https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}');
  }

  launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
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

