import 'package:flutter/services.dart';

import 'contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final Function? changePage;
  final Function? setAddress1;
  final Function? setAddress2;
  final Function? setAddress3;
  final Function? setBloodGroup;
  final Function? setPhone;
  Address(
      {this.changePage,
      this.setAddress1,
      this.setAddress2,
      this.setAddress3,
      this.setBloodGroup,
      this.setPhone});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              widget.changePage!(0);
            },
          ),
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            //height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: const Text('User Details',
                          style: TextStyle(
                              color: Color.fromRGBO(49, 39, 79, 1),
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: Colors.green),
                      counterText: "",
                      isDense: true,
                      labelText: 'Mobile No',
                      hintText: 'Mobile No',
                      border: OutlineInputBorder(),
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onChanged: (value) {
                      widget.setPhone!(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Mobile No' : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.bloodtype,
                        color: Colors.red,
                      ),
                      isDense: true,
                      labelText: 'Blood Group',
                      hintText: 'Blood Group',
                      border: OutlineInputBorder(),
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onChanged: (value) {
                      widget.setBloodGroup!(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Blood Group' : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.apartment, color: Colors.blue),
                      isDense: true,
                      labelText: 'Hostel Address',
                      hintText: 'Enter Address',
                      border: OutlineInputBorder(),
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onChanged: (value) {
                      widget.setAddress1!(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Address1' : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.home_work, color: Colors.blue),
                      labelText: 'Temporary Address',
                      hintText: 'Enter Address',
                      border: OutlineInputBorder(),
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onChanged: (value) {
                      widget.setAddress2!(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Address2' : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.home, color: Colors.blue),
                      isDense: true,
                      labelText: 'Permanent Address',
                      hintText: 'Enter Address',
                      border: OutlineInputBorder(),
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onChanged: (value) {
                      widget.setAddress3!(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Address3' : null,
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              widget.changePage!(2);
                            });
                          }
                        },
                        child: Container(
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
