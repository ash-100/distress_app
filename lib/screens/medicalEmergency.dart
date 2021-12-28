// ignore: file_names
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:distress_app/models.dart';
import 'package:provider/provider.dart';

class MedicalEmergency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Request? request = Provider.of<Request?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Emergency'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(Icons.arrow_right_outlined),
                      title: Text(
                          'Safety first - Make sure there is no danger to you and victim.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.arrow_right_outlined),
                      title: Text(
                          'Check response - Is the person asleep or unresponsive – Call, Shake, Shout'),
                    ),
                    ListTile(
                      leading: Icon(Icons.arrow_right_outlined),
                      title: Text(
                          'Seek help - Shout or call for help if you are alone but do not leave the person unattended.'),
                    ),
                    ListTile(
                        leading: Icon(Icons.arrow_right_outlined),
                        title: Text(
                            'Quick assessment of victim’s condition - Check consciousness and breathing (look, listen, feel). Look for bleeding and other life threatening conditions'))
                  ],
                ),
              ),
            ),
            request == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () async {
                          // Functionality to be added

                          sendRequest();
                          await globals.successalertbox(
                              "Request sent", context);
                          Navigator.of(context).pop();
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
                      //     child: Text('Send Request'),
                      //     style: ButtonStyle(
                      //       backgroundColor:
                      //           MaterialStateProperty.all(Colors.green),
                      //     ),
                      //     onPressed: () async {
                      //       sendRequest();
                      //       await globals.successalertbox(
                      //           "Request sent", context);
                      //       Navigator.of(context).pop();
                      //     }),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
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
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.all(Colors.red),
                      //   ),
                      //   child: Text('Cancel Request'),
                      //   onPressed: () {
                      //     FirebaseFirestore.instance
                      //         .collection('users-help-required')
                      //         .doc(FirebaseAuth.instance.currentUser!.email)
                      //         .delete();
                      //     globals.erroralertbox("Request cancelled", context);
                      //   },
                      // ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

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
      "help": "Medical",
      "timeStamp": DateTime.now(),
    });
  }
}
