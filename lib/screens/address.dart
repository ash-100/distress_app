import 'contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final Function? changePage;
  final Function? setAddress1;
  final Function? setAddress2;
  final Function? setAddress3;
  Address(
      {this.changePage, this.setAddress1, this.setAddress2, this.setAddress3});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address 1',
                  hintText: 'Enter Address',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.setAddress1!(value);
                },
                validator: (value) => value!.isEmpty ? 'Enter Address1' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Address 2',
                    hintText: 'Enter Address',
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  widget.setAddress2!(value);
                },
                validator: (value) => value!.isEmpty ? 'Enter Address2' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Address 3',
                    hintText: 'Enter Address',
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  widget.setAddress3!(value);
                },
                validator: (value) => value!.isEmpty ? 'Enter Address3' : null,
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          widget.changePage!(2);
                        });
                      }
                    },
                    child: const Text('NEXT'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
