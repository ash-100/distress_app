import 'package:distress_app/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Address extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Address'),
        ),
        body: Container(
          //height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 20,),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Address 1',
                  hintText: 'Enter Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Address 2',
                    hintText: 'Enter Address',
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(
                height: 20,),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Address 3',
                    hintText: 'Enter Address',
                    border: OutlineInputBorder()
                ),
              ),
              Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyContact()));
                      },
                      child: Text('NEXT'),
                    ),
                  ),
              ),
            ],
          ),
        ),
    );
  }
}