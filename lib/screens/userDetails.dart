import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distress_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class userDetails extends StatefulWidget {
  String email;
  userDetails(this.email);
  @override
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
                        decoration:BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 3
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10)
                          )
                        ) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(details['phone'].toString()),
                            Text('Address1',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['address1'].toString()),
                            Text('Address2',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['address2'].toString()),
                            Text('Address3',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['address3'].toString()),
                            Text('Blood Group',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['bloodGroup'].toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration:BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 3
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10)
                            )
                        ) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Emergency Contact - 1',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text('Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact1']['name'].toString()),
                            Text('Phone',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact1']['phone'].toString()),
                            Text('Relation',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact1']['relation'].toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration:BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 3
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10)
                            )
                        ) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Emergency Contact - 2',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text('Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact2']['name'].toString()),
                            Text('Phone',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact2']['phone'].toString()),
                            Text('Relation',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact2']['relation'].toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        decoration:BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 3
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10)
                            )
                        ) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Emergency Contact - 3',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text('Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact3']['name'].toString()),
                            Text('Phone',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact3']['phone'].toString()),
                            Text('Relation',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(details['emergencyContact3']['relation'].toString()),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        child: Text('View Location'),
                        onPressed: displayLocation,
                      )
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

