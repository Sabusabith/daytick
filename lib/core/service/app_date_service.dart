import 'package:hive/hive.dart';

class AppDateService {
  static final Box _appBox = Hive.box('appBox');

  static String get lastOpenedDate => _appBox.get("lastDate", defaultValue: "");

  static Future<void> saveToday(String today) async {
    await _appBox.put("lastDate", today);
  }
}
