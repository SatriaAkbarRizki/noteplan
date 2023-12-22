// ignore_for_file: unused_import

import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/model/plan/plan.dart';

class DatabasePlan {
  final String uid;
  Map<String, Map<dynamic, dynamic>>? planModel = {};
  Map<String, dynamic>? doneModel = {};
  DatabasePlan({required this.uid});

  late DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Users/UID/$uid/Plan');

  Query query() {
    return reference;
  }

  Future savePlan(Map<String, List> planModel) async {
    reference.push().set(planModel);
  }

  Future saveDonePlan(Map<String, bool> data) async {
    DatabaseReference doneRef = FirebaseDatabase.instance
        .ref()
        .child('Users/UID/$uid/Plan/listDonePlan');
    doneRef.remove();
    doneRef.push().set(data);
  }

  Future<Map<String, Map>?> readPlan() async {
    final getPlan = await FirebaseDatabase.instance
        .ref()
        .child('Users/UID/$uid/Plan')
        .once();
    final data = getPlan.snapshot.value as Map?;

    if (data != null) {
      await data.remove('listDonePlan');

      data.forEach((key, value) {
        planModel?[key] = value;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      return planModel;
    } else {
      await removeDonePlan();
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    }
  }

  Future readDonePlan() async {
    final getPlan = await FirebaseDatabase.instance
        .ref()
        .child('Users/UID/$uid/Plan/listDonePlan')
        .once();

    final data = getPlan.snapshot.value as Map?;

    data?.forEach((key, value) {
      doneModel?[key] = value;
    });

    return doneModel;
  }

  Future updatePlan(String key, Map<String, List> planList) async {
    Map<String, dynamic> referenceUpdate = {};
    referenceUpdate['Users/UID/$uid/Plan/$key'] = planList;
    return FirebaseDatabase.instance.ref().update(referenceUpdate);
  }

  Future updateDonePlan(String key, Map<String, bool> planDone) async {
    String updatePath = 'Users/UID/$uid/Plan/listDonePlan/$key';
    return FirebaseDatabase.instance.ref().child(updatePath).update(planDone);
  }

  Future removePlan(String key) async {
    return FirebaseDatabase.instance
        .ref()
        .child('Users/UID/$uid/Plan/$key')
        .remove();
  }

  Future removeDonePlan() async {
    DatabaseReference doneRef = FirebaseDatabase.instance
        .ref()
        .child('Users/UID/$uid/Plan/listDonePlan');
    doneRef.remove();
  }
}
