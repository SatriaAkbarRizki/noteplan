import 'package:shared_preferences/shared_preferences.dart';

class SaveUid {
  static String? currentUID;

  Future saveUid(String uid) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref
        .setString('uid', uid)
        .whenComplete(() => currentUID = pref.getString('uid'));
  }

  Future<String?> getUid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString('uid');
  }

  Future removeUid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.remove('uid');
  }
}
