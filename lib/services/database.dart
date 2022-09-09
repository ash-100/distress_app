import 'package:distress_app/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:distress_app/globals.dart' as globals;
import 'dart:convert';

class DatabaseService {
  String? email;
  DatabaseService({this.email});
  Future getUserInfo() async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.get(
      Uri.parse(
        '${globals.domain}/api/userdetails/$email',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    ).catchError((e) {
      throw Exception();
    });
    if (response.statusCode != 200) {
      return null;
    }
    return json.decode(response.body);
  }

  Future removeRequest() async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.delete(
      Uri.parse(
        '${globals.domain}/api/removerequest/$email',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode != 200) {
      throw Exception();
    }
    return json.decode(response.body);
  }

  Future helpsent() async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.put(
      Uri.parse(
        '${globals.domain}/api/helpsent/$email',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    ).catchError((e) {
      throw Exception();
    });
    if (response.statusCode != 200) {
      throw Exception();
    }
    return json.decode(response.body);
  }

  Future addUserInfo(
      String? email,
      String? name,
      String? phone,
      String? address2,
      String? address3,
      Contact? emergencyContact1,
      Contact? emergencyContact2,
      //Contact? emergencyContact3,
      String? bloodGroup) async {
    var data = {};
    data.addAll({
      'email': email,
      'name': name,
      'mobile_no': phone,
      'temporary_address': address2,
      'permanent_address': address3,
      'emergencyContact1': {
        'name': emergencyContact1!.name,
        'mobile_no': emergencyContact1.phone,
        'relation': emergencyContact1.relation
      },
      'emergencyContact2': {
        'name': emergencyContact2!.name,
        'mobile_no': emergencyContact2.phone,
        'relation': emergencyContact2.relation
      },
      'blood_group': bloodGroup,
    });
    // if (emergencyContact3!.name != null) {
    //   data.addAll({
    //     'emergencyContact3': {
    //       'name': emergencyContact3.name,
    //       'mobile_no': emergencyContact3.phone,
    //       'relation': emergencyContact3.relation
    //     },
    //   });
    // }
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http
        .put(Uri.parse("${globals.domain}/api/user/create"),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: json.encode(data))
        .catchError((e) {
      print(e.toString());
      throw Exception();
    });

    if (response.statusCode != 200) {
      throw Exception();
    }
    print(response.body);
    return json.decode(response.body);
  }

  Future updateUserInfo(
      String? email,
      String? name,
      String? phone,
      String? address2,
      String? address3,
      Contact? emergencyContact1,
      Contact? emergencyContact2,
      // Contact? emergencyContact3,
      String? bloodGroup) async {
    var data = {};
    data.addAll({
      'email': email,
      'name': name,
      'mobile_no': phone,
      'temporary_address': address2,
      'permanent_address': address3,
      'emergencyContact1': {
        'name': emergencyContact1!.name,
        'mobile_no': emergencyContact1.phone,
        'relation': emergencyContact1.relation
      },
      'emergencyContact2': {
        'name': emergencyContact2!.name,
        'mobile_no': emergencyContact2.phone,
        'relation': emergencyContact2.relation
      },
      'blood_group': bloodGroup,
    });
    // if (emergencyContact3!.name != null) {
    //   data.addAll({
    //     'emergencyContact3': {
    //       'name': emergencyContact3.name,
    //       'mobile_no': emergencyContact3.phone,
    //       'relation': emergencyContact3.relation
    //     },
    //   });
    // }
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http
        .put(Uri.parse("${globals.domain}/api/user/update"),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: json.encode(data))
        .catchError((e) {
      print(e.toString());
      throw Exception(e.toString());
    });

    if (response.statusCode != 200) {
      throw Exception("error");
    }
    return json.decode(response.body);
  }
}
