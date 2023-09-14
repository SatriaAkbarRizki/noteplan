import 'package:shared_preferences/shared_preferences.dart';

class SaveUid {
  static String? uidUser;

  Future saveUid(String uid) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('uid', uid);
    uidUser = pref.getString('uid');
  }
}
