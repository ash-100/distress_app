import 'package:distress_app/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(hostedDomain: 'iiti.ac.in');

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        dynamic result = await DatabaseService().getUserInfo(googleUser.email);
        if (result.data() == null) {
          return 1;
        }
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
        return 2;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future register(
      String? phone,
      String? address1,
      String? address2,
      String? address3,
      Contact? emergencyContact1,
      Contact? emergencyContact2,
      Contact? emergencyContact3,
      String? bloodGroup) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        dynamic result = await DatabaseService().getUserInfo(googleUser.email);
        if (result.data() != null) {
          return 1;
        } else {
          dynamic result = await DatabaseService().addUserInfo(
              googleUser.email,
              phone,
              address1,
              address2,
              address3,
              emergencyContact1,
              emergencyContact2,
              emergencyContact3,
              bloodGroup);
        }
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
        return 2;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
