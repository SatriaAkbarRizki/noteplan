import 'package:shared_preferences/shared_preferences.dart';

class ModeUser {
  late Future<SharedPreferences> preferences;

  ModeUser() {
    preferences = SharedPreferences.getInstance();
  }

  Future saveModeUser(String themeUser) async {
    final prefs = await preferences;
    await prefs.setString('themeUser', themeUser);
  }

  Future getThemeUser() async {
    final prefs = await preferences;
    return prefs.getString('themeUser');
  }

  Future removeThemeUser() async {
    final prefs = await preferences;
    return prefs.remove('themeUser');
  }
}
