import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/profile.dart';
import 'package:noteplan/presenter/database_profile.dart';

class ProfileUser {
  List<ProfileModel>? _listProfile;
  DatabaseProfile databaseProfile =
      DatabaseProfile(uid: MainState.currentUid.toString());
  User? user = FirebaseAuth.instance.currentUser;

  ProfileModel? profileModel;
  String? name;
  String? email;
  String? image;

  Future<List<ProfileModel>?> getProfile() async {
    if (user != null) {
      name = user!.displayName;
      email = user!.email;
      image = user!.photoURL;
      // debugPrint('name: ${name}');

      // debugPrint("image ${image}");

      if (name != null) {
        profileModel =
            ProfileModel(key: null, name: name!, email: email!, image: image!);
        _listProfile = [];
        _listProfile!.add(profileModel!);
      } else {
        setNameProfile(email!).then((value) {
          name = value;
          debugPrint('name ${value}');
          profileModel = ProfileModel(
              key: null, name: name!, email: email!, image: image!);
          _listProfile = [];
          _listProfile!.add(profileModel!);
        });
      }

      databaseProfile.saveProfile(profileModel!);

      return _listProfile!;
    } else {
      debugPrint('Null value profile');
    }
    return null;
  }

  Future<String> setNameProfile(String email) async {
    String name = email.split('@').first;
    return name;
  }
}
