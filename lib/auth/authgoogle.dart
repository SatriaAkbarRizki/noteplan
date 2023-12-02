import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteplan/local/saveuid.dart';

class AuthGoogle {
  SaveUid saveUid = SaveUid();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  Future<String?> signInGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await signInAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = authResult.user; // User object

      if (user != null) {
        String uid = user.uid; // UID dari user
        debugPrint('UID Auth: $uid');

        return uid.toString();
      } else {
        debugPrint('User tidak berhasil login.');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Error SignIn Google: ${e.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('data')));
    }
    return null;
  }

  Future signOut() async {
    await googleSignIn.signOut();
  }
}
