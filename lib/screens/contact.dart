import 'package:distress_app/services/auth.dart';
import 'home.dart';
import 'package:flutter/material.dart';

class EmergencyContact extends StatelessWidget {
  final Function? changePage;
  EmergencyContact({this.changePage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Emergency Contact'),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
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
                onPressed: () async {
                  try {
                    dynamic result = await AuthService().googleSignIn();
                  } catch (e) {
                    print(e);
                  }
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Home()),
                  //     (Route<dynamic> route) => false);
                },
                child: const Text('Register'))
          ],
        ));
  }
}

Widget row(index) {
  return Card(
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Emergency Contact - ' + (index + 1).toString(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              hintText: 'Enter your mobile number',
              border: OutlineInputBorder(),
            ),
            maxLines: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          const TextField(
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
