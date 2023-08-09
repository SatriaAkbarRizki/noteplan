import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/model/users.dart';

class Presenter {
  final String uid;
  List<UserModel>? dataprofile;

  Presenter({required this.uid});

  get reference => FirebaseDatabase.instance.ref().child('Users').child(uid);

  Query queryFirebase() {
    return reference;
  }

  Future saveData(UserModel userModel) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('Users/${uid}');

    if (databaseReference.key == uid) {
      updateData(uid, userModel);
    } else {
      return databaseReference.push().set(userModel.toJson());
    }
  }

  Future<List<UserModel>?> readData() async {
    final reference = FirebaseDatabase.instance.ref();
    final snap = await reference.child('Users').child(uid).once();

    final data = snap.snapshot.value as Map<dynamic, dynamic>;

    if (data.isEmpty) {
      return null;
    } else {
      dataprofile = [];
      final convertedData =
          data.map((key, value) => MapEntry(key.toString(), value));

      UserModel userModel =
          UserModel.fromMap(convertedData); // Perlu diperbarui

      dataprofile!.add(userModel);
      return dataprofile;
    }
  }

  Future updateData(String uid, UserModel userModel) async {
    final user = userModel.toJson();


    Map<String, dynamic> update = {};
    update['Users/${uid}'] = user;
    FirebaseDatabase.instance.ref().update(update);
  }
}
