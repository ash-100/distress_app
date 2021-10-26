import 'contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final Function? changePage;
  Address({this.changePage});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Address 1',
                hintText: 'Enter Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Address 2',
                  hintText: 'Enter Address',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Address 3',
                  hintText: 'Enter Address',
                  border: OutlineInputBorder()),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.changePage!(2);
                    });

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => EmergencyContact()));
                  },
                  child: const Text('NEXT'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
