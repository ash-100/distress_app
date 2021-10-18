import 'package:flutter/material.dart';
import 'address.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'This is the login page',
      home: Address(),
    );
  }
}
