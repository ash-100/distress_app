import 'package:flutter/material.dart';

class Fire extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Text('Safety Procedures',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                child: Text('Cancel Request'),
                onPressed: (){
                  // Cancel request for help
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}