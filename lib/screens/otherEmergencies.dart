// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:distress_app/models.dart';

class OtherEmergencies extends StatefulWidget {
  String? issue;
  OtherEmergencies({this.issue});
  @override
  State<OtherEmergencies> createState() => _OtherEmergenciesState();
}

class _OtherEmergenciesState extends State<OtherEmergencies> {
  String? issue;
  void sendRequest() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latitude, longitude;
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();

    var firebaseUser = FirebaseAuth.instance.currentUser;
    var firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance
        .collection('users-help-required')
        .doc(firebaseUser!.email)
        .set({
      "name": firebaseUser.displayName,
      "email": firebaseUser.email,
      "latitude": latitude,
      "longitude": longitude,
      "help": "Other",
      "issue": issue,
      "timeStamp": DateTime.now(),
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Request? request = Provider.of<Request?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Emergencies'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Issue:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.issue,
                readOnly: widget.issue != null,
                decoration: InputDecoration(
                  labelText: 'Issue',
                  hintText: 'Enter Issue',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  issue = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter issue';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              // Text(
              //   'OR',
              //   style: TextStyle(
              //     fontSize: 15,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Text(
              //   'Send a voice message',
              //   style: TextStyle(
              //     fontSize: 15,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // IconButton(
              //   icon: Image.asset('assets/images/microphone.png'),
              //   iconSize: 70,
              //   onPressed: () {
              //     // Recording voice
              //   },
              // ),
              request == null
                  ? Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              sendRequest();
                              await globals.successalertbox(
                                  "Request sent", context);
                              Navigator.of(context).pop();
                            }
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
                                "Send Request",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        //  ElevatedButton(
                        //     style: ButtonStyle(
                        //       backgroundColor:
                        //           MaterialStateProperty.all(Colors.green),
                        //     ),
                        //     child: Text('Send Request'),
                        //     onPressed: () async {
                        //       if (_formKey.currentState!.validate()) {
                        //         sendRequest();
                        //         await globals.successalertbox(
                        //             "Request sent", context);
                        //         Navigator.of(context).pop();
                        //       }
                        //     }),
                      ),
                    )
                  : Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            // Functionality to be added
                            FirebaseFirestore.instance
                                .collection('users-help-required')
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .delete();
                            globals.erroralertbox("Request cancelled", context);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                "Cancel Request",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        //  ElevatedButton(
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         MaterialStateProperty.all(Colors.red),
                        //   ),
                        //   child: Text('Cancel Request'),
                        //   onPressed: () {
                        //     // Functionality to be added
                        //     FirebaseFirestore.instance
                        //         .collection('users-help-required')
                        //         .doc(FirebaseAuth.instance.currentUser!.email)
                        //         .delete();
                        //     globals.erroralertbox("Request cancelled", context);
                        //   },
                        // ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
