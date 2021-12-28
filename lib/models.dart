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
  String? role;
  String? category;
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
      this.emergencyContact3,
      this.role,
      this.category});
}

class Request {
  String? name;
  String? email;
  String? latitude;
  String? longitude;
  String? help;
  String? issue;
  Request(
      {this.name,
      this.email,
      this.latitude,
      this.longitude,
      this.help,
      this.issue});
}
