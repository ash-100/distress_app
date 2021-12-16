import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Fire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/How to use fire extinguisher.png'),
                  Image.asset('assets/images/Types of fire extinguishers.png'),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                child: Text('Send Request'),
                onPressed: sendRequest,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                child: Text('Cancel Request'),
                onPressed: () {
                  // Cancel request for help
                  FirebaseFirestore.instance.collection('users-help-required').doc(FirebaseAuth.instance.currentUser!.email).delete();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  void sendRequest() async{
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String latitude, longitude;
    latitude=position.latitude.toString();
    longitude=position.longitude.toString();


    var firebaseUser= FirebaseAuth.instance.currentUser;
    var firestoreInstance= FirebaseFirestore.instance;
    firestoreInstance.collection('users-help-required').doc(firebaseUser!.email).set({
      "name":firebaseUser.displayName,
      "email":firebaseUser.email,
      "latitude":latitude,
      "longitude":longitude,
      "help":"Fire"
    });

  }
}
