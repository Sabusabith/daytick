import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const keyName = "name";
  static const keyImage = "image";

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "name": prefs.getString(keyName) ?? "Guest",
      "image": prefs.getString(keyImage),
    };
  }
}
