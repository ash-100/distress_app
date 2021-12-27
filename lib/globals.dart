import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
