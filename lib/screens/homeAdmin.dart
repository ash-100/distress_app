import 'package:distress_app/screens/userDetails.dart';
import 'package:distress_app/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'fire.dart';
import 'medicalEmergency.dart';
import 'package:flutter/material.dart';
import 'otherEmergencies.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var emergencyList = ['Medical Emergency', 'Fire', 'Other'];
var i = 0;


var firestoreInstance=FirebaseFirestore.instance;
var collection=firestoreInstance.collection('users-help-required');

class homeAdmin extends StatefulWidget {
  @override
  State<homeAdmin> createState() => _homeAdminState();
}

class _homeAdminState extends State<homeAdmin>{
  Future enableLocation(BuildContext context) async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      enableLocationAlert(context);
      return Future.error('Location services are disabled.');
    }
    else{
      _getGeoLocationPermission(context);
    }
  }

  Future _getGeoLocationPermission(BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        locationAlert(context);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      locationAlert(context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void locationAlert(BuildContext context){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Enable Location'),
            content: Text('You must enable location access in order to use this app'),
            actions: [
              TextButton(
                  onPressed:() async{
                    await Geolocator.requestPermission();
                    LocationPermission locationPermission=await Geolocator.checkPermission();
                    if(locationPermission==LocationPermission.whileInUse || locationPermission==LocationPermission.always){
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text('Enable')),
              TextButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    //Navigator.of(context).pop(true);
                  },
                  child: Text('Exit'))
            ],
          );

        });
  }
  void enableLocationAlert(BuildContext context){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Enable Location Service'),
            content: Text('You must enable location access in order to use this app'),
            actions: [
              TextButton(
                  onPressed:() async{
                    //await Geolocator.openLocationSettings();
                    await Geolocator.openLocationSettings();
                    bool service= await Geolocator.isLocationServiceEnabled();
                    if(service){
                      Navigator.of(context).pop(true);
                      _getGeoLocationPermission(context);
                    }

                  },
                  child: Text('Enable')),
              TextButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    //Navigator.of(context).pop(true);
                  },
                  child: Text('Exit'))
            ],
          );

        });
  }

  int selectedIndex=0;
  void onItemTapped(int index){
    setState(() {
      selectedIndex=index;
    });
  }
  List<Widget> pages=<Widget>[GridView.builder(
    padding: EdgeInsets.all(5),
    gridDelegate:
    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemCount: 3,
    itemBuilder: (BuildContext context, int index) {
      return Card(
        child: InkWell(
          child: Center(
            child: Text(emergencyList[index]),
          ),
          onTap: () {
            sendMessage(context, index);
          },
        ),
      );
    },
  ),
    StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var name="",email="",help="";
              if(doc.data().toString().contains('name'))
              name =doc['name'];
              if(doc.data().toString().contains('email'))
              email=doc['email'];
              if(doc.data().toString().contains('help'))
              help=doc['help'];
              return InkWell(
                child: Card(
                    child: Column(
                      children: [
                        Text(help,
                          style: TextStyle(
                              fontSize: 18
                          ),),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Name : $name'),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email : $email'),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              //Delete the document from firestore
                              collection.doc(email.trim()).delete();
                            },
                            child: Text(
                                'Help sent'
                            ))
                      ],
                    )
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=>userDetails(email)));
                },
              );
            }).toList(),
          );
        }
      },
    )

  ];
  @override
  Widget build(BuildContext context) {
    enableLocation(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Help Requests'
          )
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
      body:Center(
        child: pages.elementAt(selectedIndex), //New
      ) ,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Must be redirected to profile page
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('About App'),
              onTap: () {
                // Must be redirected to about app page
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void sendMessage(BuildContext context, int index) async {
  if (index == 0) {
    // Functionality to be added for medical emergency
    //await AuthService().logOut();
     Navigator.push(
         context, MaterialPageRoute(builder: (context) => MedicalEmergency()));
  } else if (index == 1) {
    // Functionality to be added for fire
    Navigator.push(context, MaterialPageRoute(builder: (context) => Fire()));
  } else if (index == 2) {
    // Functionality to be added for other cases
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OtherEmergencies()));
  } else {
    // Error
  }
}



