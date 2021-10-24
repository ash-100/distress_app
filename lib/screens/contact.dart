import 'home.dart';
import 'package:flutter/material.dart';
import 'next.dart';

class EmergencyContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Emergency Contact'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, i) {
                    return row(i);
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false);
                },
                child: Text('NEXT'))
          ],
        ));
  }
}

Widget row(index) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Emergency Contact - ' + (index + 1).toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              hintText: 'Enter your mobile number',
              border: OutlineInputBorder(),
            ),
            maxLines: 1,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Relationship',
              hintText: 'Enter your relationship',
              border: OutlineInputBorder(),
            ),
            maxLines: 1,
          )
        ],
      ),
    ),
  );
  // return ListTile(
  //   title: Text(list[index]),
  // );
}
