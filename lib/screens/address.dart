import 'package:flutter/services.dart';

import 'contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final Function? changePage;
  final Function? setAddress2;
  final Function? setAddress3;
  final Function? setBloodGroup;
  final Function? setPhone;
  final Function? setName;
  Address({
    this.changePage,
    this.setAddress2,
    this.setAddress3,
    this.setBloodGroup,
    this.setPhone,
    this.setName,
  });

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _bloodGroup;
  List<String> groups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            // height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: FractionalOffset.center,
                    child: const Text('User Details',
                        style: TextStyle(
                            color: Color.fromRGBO(188, 51, 51, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      isDense: true,
                      labelText: 'Full Name',
                      hintText: 'Full Name',
                      border: OutlineInputBorder(),
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onChanged: (value) {
                      widget.setName!(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Full Name' : null,
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
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     prefixIcon: Icon(
                  //       Icons.bloodtype,
                  //       color: Colors.red,
                  //     ),
                  //     isDense: true,
                  //     labelText: 'Blood Group',
                  //     hintText: 'Blood Group',
                  //     border: OutlineInputBorder(),
                  //     suffixText: '*',
                  //     suffixStyle: TextStyle(
                  //       color: Colors.red,
                  //     ),
                  //   ),
                  //   onChanged: (value) {
                  //     widget.setBloodGroup!(value);
                  //   },
                  //   validator: (value) =>
                  //       value!.isEmpty ? 'Enter Blood Group' : null,
                  // ),
                  DropdownButtonFormField<String>(
                      validator: ((value) {
                        value == "" ? 'Select Blood Group' : null;
                      }),
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
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      ),
                      // dropdownColor: Colors.blueAccent,
                      value: _bloodGroup,
                      onChanged: (String? newValue) {
                        setState(() {
                          _bloodGroup = newValue!;
                          widget.setBloodGroup!(newValue);
                        });
                      },
                      items: groups.map((String item) {
                        return DropdownMenuItem<String>(
                            child: Text(item), value: item);
                      }).toList()),

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
                            color: Color.fromRGBO(188, 51, 51, 1),
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
