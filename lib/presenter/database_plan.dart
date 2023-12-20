import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/model/plan/plan.dart';

class DatabasePlan {
  final String uid;
  Map<String, Map<dynamic, dynamic>> planModel = {};
  DatabasePlan({required this.uid});

  late DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Users/UID/$uid/Plan');

  Query query() {
    return reference;
  }

  Future savePlan(Map<String, List> planModel) async {
    reference.push().set(planModel);
  }

  Future<Map<String, Map<dynamic, dynamic>>> readPlan() async {
    final getPlan = await FirebaseDatabase.instance
        .ref()
        .child('Users/UID/$uid/Plan')
        .once();
    final data = getPlan.snapshot.value as Map;
    data.forEach((key, value) {
      planModel[key] = value;
    });

    return planModel;
  }

  Future updatePlan(String key, Map<String, List> planMode) async {
    Map<String, dynamic> referenceUpdate = {};
    referenceUpdate['Users/UID/$uid/Plan/${key}'] = planMode;
    return FirebaseDatabase.instance.ref().update(referenceUpdate);
  }
}
