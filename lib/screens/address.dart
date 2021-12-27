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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          //height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(25),
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
                  decoration: InputDecoration(
                    labelText: 'Mobile No',
                    hintText: 'Mobile No',
                    border: OutlineInputBorder(),
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
                    labelText: 'Blood Group',
                    hintText: 'Blood Group',
                    border: OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: 'Address 1',
                    hintText: 'Enter Address',
                    border: OutlineInputBorder(),
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
                  decoration: InputDecoration(
                      labelText: 'Address 2',
                      hintText: 'Enter Address',
                      border: OutlineInputBorder()),
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
                  decoration: InputDecoration(
                      labelText: 'Address 3',
                      hintText: 'Enter Address',
                      border: OutlineInputBorder()),
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
    );
  }
}
