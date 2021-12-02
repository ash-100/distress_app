import 'package:flutter/material.dart';

class Contact {
  String? name;
  String? phone;
  String? relation;
  Contact({this.name, this.phone, this.relation});
}

class UserData {
  String? name;
  String? phone;
  String? address1;
  String? address2;
  String? address3;
  String? bloodGroup;
  String? email;
  Contact? emergencyContact1;
  Contact? emergencyContact2;
  Contact? emergencyContact3;
  UserData(
      {this.name,
      this.phone,
      this.address1,
      this.address2,
      this.address3,
      this.bloodGroup,
      this.email,
      this.emergencyContact1,
      this.emergencyContact2,
      this.emergencyContact3});
}
