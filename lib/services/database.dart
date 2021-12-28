import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distress_app/models.dart';

class DatabaseService {
  String? uid;
  String? email;
  DatabaseService({this.uid, this.email});
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference requests =
      FirebaseFirestore.instance.collection('users-help-required');
  Future getUserInfo(String? email) async {
    return users.doc(email).get();
  }

  Stream<Request?> get requestStream {
    return requests.doc(email).snapshots().map(getrequestFromsnapshot);
  }

  Request? getrequestFromsnapshot(DocumentSnapshot? snapshot) {
    dynamic data = snapshot!.data();
    if (data == null) {
      return null;
    }
    Request request = Request();
    request.name = data['name'];
    request.email = email;
    request.help = data['help'];
    request.latitude = data['latitude'];
    request.longitude = data['longitude'];
    request.issue = data['issue'];
    return request;
  }

  Future addUserInfo(
      String? email,
      String? phone,
      String? address1,
      String? address2,
      String? address3,
      Contact? emergencyContact1,
      Contact? emergencyContact2,
      Contact? emergencyContact3,
      String? bloodGroup) async {
    return users.doc(email).set({
      'phone': phone,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'emergencyContact1': {
        'name': emergencyContact1!.name,
        'phone': emergencyContact1.phone,
        'relation': emergencyContact1.relation
      },
      'emergencyContact2': {
        'name': emergencyContact2!.name,
        'phone': emergencyContact2.phone,
        'relation': emergencyContact2.relation
      },
      'emergencyContact3': {
        'name': emergencyContact3!.name,
        'phone': emergencyContact3.phone,
        'relation': emergencyContact3.relation
      },
      'bloodGroup': bloodGroup,
      'role': 'user',
      'category': [],
    });
  }
}
