import 'package:distress_app/help.dart';
import 'package:distress_app/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database.dart';
import 'package:distress_app/globals.dart' as globals;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    hostedDomain: 'iiti.ac.in',
    //clientId:
    // '938777725296-iad8rke2kcs9gc2v7pkhfkic2k1caoul.apps.googleusercontent.com'
  );

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future signIn() async {
    return await _googleSignIn.signIn();
  }

  Future signOut() async {
    return await _googleSignIn.signOut();
  }

  Future signInWithCreds(credential) async {
    return await _auth.signInWithCredential(credential);
  }

  Future googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        dynamic result =
            await DatabaseService(email: googleUser.email).getUserInfo();
        if (result == null) {
          _googleSignIn.signOut();
          return 1;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        //print(result);
        //await Provider.of<RequiredHelp>
        RequiredHelp().setHelpstate(jsonEncode(result['userInfo']), 0);
        final UserCredential? authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult?.user;
        //print(_auth.currentUser!.getIdToken());
        return result['userInfo'];
      } else {
        _googleSignIn.signOut();
        return 2;
      }
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  Future register(
      String? phone,
      String? name,
      String? address1,
      String? address2,
      String? address3,
      Contact? emergencyContact1,
      Contact? emergencyContact2,
      // Contact? emergencyContact3,
      String? bloodGroup) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        dynamic result =
            await DatabaseService(email: googleUser.email).getUserInfo();
        if (result != null) {
          _googleSignIn.signOut();
          return 1;
        } else {
          dynamic result = await DatabaseService().addUserInfo(
              googleUser.email,
              name,
              phone,
              address2,
              address3,
              emergencyContact1,
              emergencyContact2,
              // emergencyContact3,
              bloodGroup);
        }
        await RequiredHelp().setHelpstate(jsonEncode(result), 0);
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential? authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult?.user;
        return user;
      } else {
        _googleSignIn.signOut();
        return 2;
      }
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  Future logOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }
}
