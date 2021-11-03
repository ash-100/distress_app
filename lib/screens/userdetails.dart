import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class userdetails extends StatefulWidget {
  final Function? changePage;
  userdetails({this.changePage});

  @override
  State<userdetails> createState() => _userdetails();
}

class _userdetails extends State<userdetails> {
  late int selectedRadio;
  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  final userList = ['Student', 'Faculty', 'Staff'];
  String? dropDownValue;
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
              height: 120,
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
            ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
              const Text("Male"),
              Radio(
                value: 1,
                groupValue: selectedRadio,
                activeColor: Colors.green,
                onChanged: (val) {
                  print("Radio $val");
                  setSelectedRadio(1);
                  print(selectedRadio);
                },
              ),
              const Text("Female"),
              Radio(
                value: 2,
                groupValue: selectedRadio,
                activeColor: Colors.green,
                onChanged: (val) {
                  print("Radio $val");
                  setSelectedRadio(2);
                  print(selectedRadio);
                },
              ),
            ]),
            Center(
              child: DropdownButton<String>(
                items: userList.map(buildMenuItem).toList(),
                value: dropDownValue,
                isExpanded: true,
                onChanged: (value) =>
                    setState(() => this.dropDownValue = value),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(49, 39, 79, 1),
              ),
              child: Center(
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
        ),
      );
}
