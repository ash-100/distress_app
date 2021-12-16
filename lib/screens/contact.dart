import 'package:distress_app/models.dart';
import 'package:distress_app/services/auth.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:distress_app/globals.dart' as globals;

class EmergencyContact extends StatefulWidget {
  final Function? changePage;
  final Function? getAddress1;
  final Function? getAddress2;
  final Function? getAddress3;
  final Function? getBloodGroup;
  final Function? getPhone;

  EmergencyContact(
      {this.changePage,
      this.getAddress1,
      this.getAddress2,
      this.getAddress3,
      this.getBloodGroup,
      this.getPhone});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Contact? contact1 = Contact();
  Contact? contact2 = Contact();
  Contact? contact3 = Contact();
  String? address1;
  String? address2;
  String? address3;
  String? phone;
  String? bloodGroup;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Expanded(
                      child: ListView(children: [
                    Card(
                      shadowColor: Colors.white,
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Emergency Contact - ' + 1.toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(49, 39, 79, 1)),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Enter your name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                contact1!.name = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Entername' : null,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                hintText: 'Enter your mobile number',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                contact1!.phone = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter mobile number' : null,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Relationship',
                                hintText: 'Enter your relationship',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 1,
                              onChanged: (value) {
                                contact1!.relation = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter relationship' : null,
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shadowColor: Colors.white,
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Emergency Contact - ' + 2.toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(49, 39, 79, 1)),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Enter your name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                contact2!.name = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter name' : null,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                hintText: 'Enter your mobile number',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                contact2!.phone = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter mobile number' : null,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Relationship',
                                hintText: 'Enter your relationship',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => contact2!.relation = value,
                              maxLines: 1,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter relationship' : null,
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shadowColor: Colors.white,
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Emergency Contact - ' + 3.toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(49, 39, 79, 1)),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Enter your name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                contact3!.name = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter name' : null,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                hintText: 'Enter your mobile number',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 1,
                              onChanged: (value) {
                                contact3!.phone = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter mobile number' : null,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Relationship',
                                hintText: 'Enter your relationship',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 1,
                              onChanged: (value) {
                                contact3!.relation = value;
                              },
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter relationship' : null,
                            )
                          ],
                        ),
                      ),
                    ),
                  ])),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        address1 = widget.getAddress1!();
                        address2 = widget.getAddress2!();
                        address3 = widget.getAddress3!();
                        phone = widget.getPhone!();
                        bloodGroup = widget.getBloodGroup!();

                        try {
                          dynamic result = await AuthService().register(
                              phone,
                              address1,
                              address2,
                              address3,
                              contact1,
                              contact2,
                              contact3,
                              bloodGroup);
                          if (result == 1) {
                            globals.erroralertbox(
                                'You have Already Registered!!', context);
                            widget.changePage!(0);
                          }
                        } catch (e) {
                          print(e);
                        }
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
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

// Widget row(index, contact1, contact2, contact3) {
//   return Card(
//     child: Container(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           Text(
//             'Emergency Contact - ' + (index + 1).toString(),
//             textAlign: TextAlign.left,
//             style: const TextStyle(
//               fontSize: 18,
//             ),
//           ),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Name',
//               hintText: 'Enter your name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Mobile Number',
//               hintText: 'Enter your mobile number',
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 1,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Relationship',
//               hintText: 'Enter your relationship',
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 1,
//           )
//         ],
//       ),
//     ),
//   );
//   // return ListTile(
//   //   title: Text(list[index]),
//   // );
// }
