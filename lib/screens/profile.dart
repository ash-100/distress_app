import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  final Function? changePage;
  profile({this.changePage});

  @override
  State<profile> createState() => _profile();
}

class _profile extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1), fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Name
                const Text(
                  "Name",
                  style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1), fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "value",
                  style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1), fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Email",
                  style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1), fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                //email
                const Text(
                  "value",
                  style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1), fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Mobile Number",
                    style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, 1), fontSize: 18)),
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
                const Text(
                  "Address",
                  style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1), fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "Address",
                    border: OutlineInputBorder(),
                  ),
                )
              ])),
    );
  }
}
