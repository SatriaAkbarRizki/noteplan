import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/profile.dart';

class DatabaseProfile {
  final String uid;
  List<ProfileModel>? profilemodelList;
  Map<String, ProfileModel>? dataUser;

  DatabaseProfile({required this.uid});

  late DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Users/UID/$uid/Profile');

  Query queryFirebase() {
    return reference;
  }

  Future saveProfile(ProfileModel profileModel) async {
    reference.push().set(profileModel.toJson());
  }

  Future<List<ProfileModel>?> readProfile() async {
    profilemodelList = [];
    final reference = await FirebaseDatabase.instance
        .ref()
        .child('Users/UID/${MainState.currentUid.toString()}/Profile')
        .once();

    final data = reference.snapshot.value as Map<dynamic, dynamic>;

    data.forEach((key, value) {
      ProfileModel profileModel = ProfileModel.fromMap(key, value);
      ;
      profilemodelList?.add(profileModel);
    });

    // print(profilemodelList);
    return profilemodelList;
  }

  Future updateProfile(String key, ProfileModel profileModel) async {
    final profile = profileModel.toJson();

    Map<String, dynamic> update = {};
    update['Users/UID/${MainState.currentUid}/Profile/$key'] = profile;
    return FirebaseDatabase.instance.ref().update(update);
  }

  Future removeProfile(String key) async {
    reference = FirebaseDatabase.instance
        .ref()
        .child("Users/UID/${MainState.currentUid}/Profile/$key");
    await reference.remove();
  }
}
