import 'package:distress_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:distress_app/models.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? name;
  String? phone;
  String? _bloodGroup;
  String? hostel;
  String? temporary;
  String? permanent;

  Contact? contact1 = Contact();
  Contact? contact2 = Contact();
  Contact? contact3 = Contact();
  bool loading = false;
  List<String> groups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  Future getProfile() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    //globals.getIdToken();
    String? url = "${globals.domain}/api/userdetails/$email";
    dynamic response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
    ).catchError((e) {
      throw Exception();
    });
    response = jsonDecode(response.body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: loading
          ? globals.Loading()
          : FutureBuilder(
              future: getProfile(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  dynamic data = snapshot.data;
                  name = data['name'];
                  phone = data['mobile_no'];
                  _bloodGroup = data['blood_group'];
                  hostel = data['hostel_address'];
                  temporary = data['temporary_address'];
                  permanent = data['permanent_address'];
                  contact1 = Contact(
                      name: data['emergency_contact'][0]['name'],
                      phone: data['emergency_contact'][0]['mobile_no'],
                      relation: data['emergency_contact'][0]['relation']);
                  contact2 = Contact(
                      name: data['emergency_contact'][1]['name'],
                      phone: data['emergency_contact'][1]['mobile_no'],
                      relation: data['emergency_contact'][1]['relation']);
                  return SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20),
                            Card(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(6, 10, 0, 10),
                                    //height: 45,
                                    child: Text(
                                      'Basic Details',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                    color: Color.fromRGBO(188, 51, 51, 1)),
                                Container(
                                    padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Name:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          initialValue: name,
                                          onChanged: (value) {
                                            //setState(() {
                                            name = value;
                                            // });
                                          },
                                          validator: (value) => value!.isEmpty
                                              ? 'Enter Name'
                                              : null,
                                        ),
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Mobile No:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          initialValue: phone,
                                          onChanged: (value) {
                                            phone = value;
                                          },
                                          validator: (value) => value!.isEmpty
                                              ? 'Enter Mobile no'
                                              : null,
                                        ),
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Blood Group:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        DropdownButtonFormField<String>(
                                            validator: ((value) {
                                              value!.isEmpty
                                                  ? 'Select Blood Group'
                                                  : null;
                                            }),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                            ),
                                            // dropdownColor: Colors.blueAccent,
                                            value: _bloodGroup,
                                            onChanged: (String? newValue) {
                                              _bloodGroup = newValue!;
                                            },
                                            items: groups.map((String item) {
                                              return DropdownMenuItem<String>(
                                                  child: Text(item),
                                                  value: item);
                                            }).toList()),
                                      ],
                                    )),

                                Container(
                                    padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Temporary Address:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          initialValue: temporary,
                                          onChanged: (value) {
                                            temporary = value;
                                          },
                                          validator: (value) => value!.isEmpty
                                              ? 'Enter temporary address'
                                              : null,
                                        ),
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Permanent Address:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          initialValue: permanent,
                                          onChanged: (value) {
                                            permanent = value;
                                          },
                                          validator: (value) => value!.isEmpty
                                              ? 'Enter permanent address'
                                              : null,
                                        ),
                                      ],
                                    )),

                                //
                                //TextFormField()
                              ],
                            )),
                            Card(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(6, 10, 0, 10),
                                        //height: 45,
                                        child: Text(
                                          'Emergency Contact-1',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                        color: Color.fromRGBO(188, 51, 51, 1)),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 8, 5, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Name:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              initialValue: contact1!.name,
                                              onChanged: (value) {
                                                contact1!.name = value;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Enter Name'
                                                      : null,
                                            ),
                                          ],
                                        )),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 8, 5, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Mobile no:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              initialValue: contact1!.phone,
                                              onChanged: (value) {
                                                contact1!.phone = value;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Enter Mobile no'
                                                      : null,
                                            ),
                                          ],
                                        )),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 8, 5, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Relation:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              initialValue: contact1!.relation,
                                              onChanged: (value) {
                                                contact1!.relation = value;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Enter Relation'
                                                      : null,
                                            ),
                                          ],
                                        )),
                                  ]),
                            ),
                            Card(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(6, 10, 0, 10),
                                        //height: 45,
                                        child: Text(
                                          'Emergency Contact-2',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                        color: Color.fromRGBO(188, 51, 51, 1)),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 8, 5, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Name:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              initialValue: contact2!.name,
                                              onChanged: (value) {
                                                contact2!.name = value;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Enter Name'
                                                      : null,
                                            ),
                                          ],
                                        )),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 8, 5, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Mobile no:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              initialValue: contact2!.phone,
                                              onChanged: (value) {
                                                contact2!.phone = value;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Enter Mobile no'
                                                      : null,
                                            ),
                                          ],
                                        )),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 8, 5, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Relation:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              initialValue: contact2!.relation,
                                              onChanged: (value) {
                                                contact2!.relation = value;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Enter Relation'
                                                      : null,
                                            ),
                                          ],
                                        )),
                                  ]),
                            ),
                          ],
                        )),
                  );
                } else {
                  return globals.Loading();
                }
              }),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              loading = true;
            });
            try {
              await DatabaseService().updateUserInfo(
                  FirebaseAuth.instance.currentUser?.email,
                  name,
                  phone,
                  temporary,
                  permanent,
                  contact1,
                  contact2,
                  _bloodGroup);
              setState(() {
                loading = false;
              });
              globals.successalertbox("profile updated successfully", context);
            } catch (e) {
              setState(() {
                loading = false;
              });
              globals.erroralertbox("An Error Occured", context);
            }
          }
          // Add your onPressed code here!
        },
        label: const Text('Save'),
        // icon: const Icon(Icons.thumb_up),
        backgroundColor: Color.fromRGBO(188, 51, 51, 1),
      ),
    ));
  }
}
