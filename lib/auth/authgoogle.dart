import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/presenter/saveuid.dart';

class AuthGoogle {
  SaveUid saveUid = SaveUid();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  Future<String?> SignInGoogle(BuildContext context) async {
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
        print('UID Auth: $uid');

        return uid.toString();
      } else {
        print('User tidak berhasil login.');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Error SignIn Google: ${e.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('data')));
    }
  }

  Future signOut() async {
    await googleSignIn.signOut();
  }
}
