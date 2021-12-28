import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:distress_app/models.dart';

class Fire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Request? request = Provider.of<Request?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire'),
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
                    Image.asset(
                        'assets/images/How to use fire extinguisher.png'),
                    Image.asset(
                        'assets/images/Types of fire extinguishers.png'),
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
                      //   style: ButtonStyle(
                      //     backgroundColor:
                      //         MaterialStateProperty.all(Colors.green),
                      //   ),
                      //   child: Text('Send Request'),
                      //   onPressed: () async {
                      //     sendRequest();
                      //     await globals.successalertbox("Request sent", context);
                      //     Navigator.of(context).pop();
                      //   },
                      // ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          // Cancel request for help
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
                      //     backgroundColor:
                      //         MaterialStateProperty.all(Colors.red),
                      //   ),
                      //   child: Text('Cancel Request'),
                      //   onPressed: () {
                      //     // Cancel request for help
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
      "help": "Fire",
      "timeStamp": DateTime.now(),
    });
  }
}
