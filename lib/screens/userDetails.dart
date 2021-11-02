import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class userDetails extends StatefulWidget {
  final Function? changePage;
  userDetails({this.changePage});

  @override
  State<userDetails> createState() => _userDetails();
}

class _userDetails extends State<userDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "Register",
              style:
                  TextStyle(color: Color.fromRGBO(49, 39, 79, 1), fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Date of Birth",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
