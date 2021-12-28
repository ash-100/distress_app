// ignore_for_file: file_names

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
import 'package:provider/provider.dart';
import 'package:distress_app/models.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:intl/intl.dart';

var emergencyList = ['Medical', 'Fire', 'Other'];
List<Icon> icons = [
  Icon(Icons.local_hospital),
  Icon(Icons.fireplace),
  Icon(Icons.help_outline),
];
//var emergencyList = ['Medical Emergency', 'Fire'];
var i = 0;

var firestoreInstance = FirebaseFirestore.instance;
var collection = firestoreInstance.collection('users-help-required');

class homeAdmin extends StatefulWidget {
  @override
  State<homeAdmin> createState() => _homeAdminState();
}

class _homeAdminState extends State<homeAdmin> {
  // PermissionStatus? _status;
  // void initState() {
  //   super.initState();
  //   Permission.locationWhenInUse.request().then();
  // }
  // void _updateStatus(PermissionStatus status)
  // {
  //   setState(() {
  //     _status = status;
  //   });
  // }
  Future enableLocation(BuildContext context) async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      enableLocationAlert(context);
      return Future.error('Location services are disabled.');
    } else {
      _getGeoLocationPermission(context);
    }
  }

  Future _getGeoLocationPermission(BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationAlert(context);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      locationAlert(context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void locationAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enable Location'),
            content: Text(
                'You must enable location access in order to use this app'),
            actions: [
              TextButton(
                  onPressed: () async {
                    LocationPermission locationPermission =
                        await Geolocator.checkPermission();
                    if (locationPermission == LocationPermission.whileInUse ||
                        locationPermission == LocationPermission.always) {
                      Navigator.of(context).pop(true);
                    } else {
                      await Geolocator.requestPermission();
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

  void enableLocationAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enable Location Service'),
            content: Text(
                'You must enable location access in order to use this app'),
            actions: [
              TextButton(
                  onPressed: () async {
                    //await Geolocator.openLocationSettings();
                    await Geolocator.openLocationSettings();
                    bool service = await Geolocator.isLocationServiceEnabled();
                    if (service) {
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

  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pages = <Widget>[
    GridView.builder(
      padding: EdgeInsets.all(5),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            child: Center(
              child: Container(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icons[index],
                    Text(
                      emergencyList[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              sendMessage(context, index);
            },
          ),
        );
      },
    ),
    StreamBuilder<QuerySnapshot>(
      stream: collection.orderBy('timeStamp', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: Center(
              child: SpinKitChasingDots(
                color: Color.fromRGBO(49, 39, 79, 1),
                size: 50,
              ),
            ),
          );
        } else if (snapshot.data!.size == 0) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text('No Requests'),
            ),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var name = "", email = "", help = "", issue = "";
              DateTime time = doc['timeStamp'].toDate();
              String t = DateFormat.yMMMd().add_jm().format(time);
              if (doc.data().toString().contains('name')) name = doc['name'];
              if (doc.data().toString().contains('email')) email = doc['email'];
              if (doc.data().toString().contains('help')) help = doc['help'];
              if (doc.data().toString().contains('issue')) issue = doc['issue'];
              return Container(
                padding: EdgeInsets.all(6),
                child: InkWell(
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          help + " Emergency",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Name : $name'),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email : $email'),
                        ),
                        issue.isNotEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Issue : $issue'),
                              )
                            : Container(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Sent at :' + t),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            await collection.doc(email.trim()).delete();
                            globals.successalertbox('Request deleted', context);
                          },
                          child: Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                "Mark as Help Sent",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                        // ), ElevatedButton(
                        //     onPressed: () {
                        //       //Delete the document from firestore
                        //       collection.doc(email.trim()).delete();
                        //     },
                        //     child: Text('Help sent'))
                      ],
                    ),
                  )),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => userDetails(email)));
                  },
                ),
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
    final User user = Provider.of<User>(context);
    final Request? request = Provider.of<Request?>(context);
    // enableLocation(context);
    print(request);
    if (request != null) {
      if (request.help == 'Medical') {
        return MedicalEmergency();
      } else if (request.help == 'Fire') {
        return Fire();
      } else if (request.help == 'Other') {
        return OtherEmergencies(issue: request.issue);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distress App IITI'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromRGBO(49, 39, 79, 1),
        unselectedItemColor: Color.fromRGBO(49, 39, 79, .6),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Help Requests')
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
      body: Center(
        child: pages.elementAt(selectedIndex), //New
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(49, 39, 79, 1),
              ),
              child: Center(
                child: Text(
                  user.displayName!,
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
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                // Must be redirected to profile page
                //  Navigator.pop(context);
                await AuthService().logOut();
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
