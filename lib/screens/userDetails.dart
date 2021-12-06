import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class userDetails extends StatefulWidget{
  String email;
  userDetails(this.email);
  @override
  State<userDetails> createState() => _userDetailsState(this.email);
}

class _userDetailsState extends State<userDetails>{
  String email;
  _userDetailsState(this.email);
  var firestoreInstance=FirebaseFirestore.instance;
  Map details= Map<String, String>();

  void fetchUserDetails(){
    firestoreInstance.collection('users').doc(email).get().then((value){
      setState(() {
        details=value.data()!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    fetchUserDetails();
    print(email);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        children: [
          Text('Phone'),
          Text(details['phone'].toString()),
          Text('Address1'),
          Text(details['address1'].toString()),
          Text('Address2'),
          Text(details['address2'].toString()),
          Text('Address3'),
          Text(details['address3'].toString()),
          Text('Blood Group'),
          Text(details['bloodGroup'].toString()),
          Text('Emergency Contact - 1'),
          Text('Name'),
          Text(details['emergencyContact1']['name'].toString()),
          Text('Phone'),
          Text(details['emergencyContact1']['phone'].toString()),
          Text('Relation'),
          Text(details['emergencyContact1']['relation'].toString()),
          Text('Emergency Contact - 2'),
          Text('Name'),
          Text(details['emergencyContact2']['name'].toString()),
          Text('Phone'),
          Text(details['emergencyContact2']['phone'].toString()),
          Text('Relation'),
          Text(details['emergencyContact2']['relation'].toString()),
          Text('Emergency Contact - 3'),
          Text('Name'),
          Text(details['emergencyContact3']['name'].toString()),
          Text('Phone'),
          Text(details['emergencyContact3']['phone'].toString()),
          Text('Relation'),
          Text(details['emergencyContact3']['relation'].toString()),
          ElevatedButton(
            child: Text('View Location'),
            onPressed: displayLocation,
          )

        ],
      ),
    );
  }
  
  void displayLocation(){
    var latitude='0',longitude='0';
    print('email $email ');
    firestoreInstance.collection('users-help-required').doc(email.trim()).get().then((value) {
      print(value.data());
      if(value.data().toString().contains('latitude'))
        latitude=value.data()!['latitude'];
      if(value.data().toString().contains('longitude'))
        longitude=value.data()!['longitude'];
      print(latitude);
      launchURL('https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}');

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

