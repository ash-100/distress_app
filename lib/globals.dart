import 'dart:io';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

String domain = 'http://103.159.214.169:80';
Future cancelRequest() async {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String url = "$domain/api/cancelrequest/${firebaseUser?.email}";
  String? idToken = await firebaseUser?.getIdToken();
  var response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken'
    },
  ).catchError((e) {
    throw Exception();
  });
}

Future sendRequest() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  String latitude, longitude;
  latitude = position.latitude.toString();
  longitude = position.longitude.toString();

  var firebaseUser = FirebaseAuth.instance.currentUser;
  String url = "$domain/api/sendrequest";
  String? idToken = await firebaseUser?.getIdToken();
  var response = await http
      .post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken'
          },
          body: jsonEncode({
            "name": firebaseUser?.displayName,
            "email": firebaseUser?.email,
            "latitude": latitude,
            "longitude": longitude,
            "help_type": "Medical",
            "request_sent_at": DateTime.now().toString(),
          }))
      .catchError((e) {
    throw Exception();
  });
}

Future erroralertbox(String message, BuildContext context) async {
  return await Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    title: 'Raksha App IITI',
    //message: message,
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    icon: Icon(
      Icons.error,
      color: Colors.white,
    ),
    duration: Duration(seconds: 5),
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.red,
    messageText:
        Text(message, style: TextStyle(color: Colors.white, fontSize: 15)),
  ).show(context);
}

Future successalertbox(String message, BuildContext context) async {
  return await Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    title: 'Raksha App IITI',
    //message: message,
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    icon: Icon(
      Icons.check_circle,
      color: Colors.white,
    ),
    duration: Duration(seconds: 5),
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.green,
    messageText:
        Text(message, style: TextStyle(color: Colors.white, fontSize: 15)),
  ).show(context);
}

Widget HomeDrawer(User user, BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
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
        // ListTile(
        //   title: Text('Profile'),
        //   onTap: () {
        //     // Must be redirected to profile page
        //     Navigator.pop(context);
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => StreamProvider<Object>(
        //                 stream: null,
        //                 builder: (context, snapshot) {
        //                   return Profile();
        //                 })));
        //   },
        // ),
        ListTile(
          title: Text('About App'),
          onTap: () {
            // Must be redirected to about app page
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Sign Out'),
          onTap: () {
            // Must be redirected to profile page
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget alertBox(String message, BuildContext context) {
  return AlertDialog(
    title: Text('Raksha App IITI'),
    content: Text(message),
    actions: <Widget>[
      TextButton(
        child: Text('OK'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget Loading() {
  return Container(
    color: Colors.white,
    child: Center(
      child: SpinKitChasingDots(
        color: Color.fromRGBO(188, 51, 51, 1),
        size: 50,
      ),
    ),
  );
}

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

void requestDeleteAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Raksha IITI'),
          content: Text('Are you sure you want to delete this request?'),
          actions: [
            TextButton(onPressed: () async {}, child: Text('Delete')),
            TextButton(
                onPressed: () {
                  //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  Navigator.of(context).pop(true);
                },
                child: Text('Cancel'))
          ],
        );
      });
}
