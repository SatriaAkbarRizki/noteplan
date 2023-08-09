import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/model/users.dart';

class Presenter {
  final String uid;
  List<UserModel> dataprofile = [];

  Presenter({required this.uid});

  get reference => FirebaseDatabase.instance.ref().child('User').child(uid);

  void saveData(UserModel user) {
    return reference;
  }

  Query queryFirebase() {
    return reference;
  }

  Future<List<UserModel>?> parsingData() async {
  final reference = FirebaseDatabase.instance.ref();
  final snap = await reference.child('Users').child(uid).once();

  final data = snap.snapshot.value as Map<dynamic, dynamic>;

  if (data.isEmpty) {
    return null;
  } else {
    final convertedData =
        data.map((key, value) => MapEntry(key.toString(), value));

    UserModel userModel = UserModel.fromMap(convertedData); // Perlu diperbarui

    data.forEach((key, value) {
      dataprofile.add(userModel); // Tanpa memeriksa null
    });
    return dataprofile;
  }
}

}
