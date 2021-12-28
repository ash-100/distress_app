import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/profile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future erroralertbox(String message, BuildContext context) async {
  return await Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    title: 'Distress App IITI',
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
    title: 'Distress App IITI',
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
    title: Text('Distress App IITI'),
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
        color: Color.fromRGBO(49, 39, 79, 1),
        size: 50,
      ),
    ),
  );
}
