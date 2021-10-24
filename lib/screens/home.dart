import 'fire.dart';
import 'medicalEmergency.dart';
import 'package:flutter/material.dart';

var emergencyList = ['Medical Emergency', 'Fire', 'Other'];
var i = 0;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(5),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              child: Center(
                child: Text(emergencyList[index]),
              ),
              onTap: () {
                sendMessage(context, index);
              },
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Must be redirected to profile page
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('About App'),
              onTap: () {
                // Must be redirected to about app page
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void sendMessage(BuildContext context, int index) {
  if (index == 0) {
    // Functionality to be added for medical emergency
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MedicalEmergency()));
  } else if (index == 1) {
    // Functionality to be added for fire
    Navigator.push(context, MaterialPageRoute(builder: (context) => Fire()));
  } else if (index == 2) {
    // Functionality to be added for other cases
  } else {
    // Error
  }
}
