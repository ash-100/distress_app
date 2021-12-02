import 'package:flutter/material.dart';

class OtherEmergencies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Emergencies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Issue:',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Issue',
                hintText: 'Enter Issue',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'OR',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Send a voice message',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            IconButton(
              icon: Image.asset('assets/images/microphone.png'),
              iconSize: 70,
              onPressed: () {
                // Recording voice
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  child: Text('Send Request'),
                  onPressed: () {
                    // Functionality to be added
                  },
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                child: Text('Cancel Request'),
                onPressed: () {
                  // Functionality to be added
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
