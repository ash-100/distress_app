import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
}
