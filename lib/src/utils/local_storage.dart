import 'package:roll_dice_demo/src/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._privateConstructor();

  factory LocalStorage() {
    return _instance;
  }

  late SharedPreferences _prefs;

  LocalStorage._privateConstructor() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  setRollingData({required int attemptRemaining, required int score}) async {
    await _prefs.setInt(ConstantStrings.attemptRemaining, attemptRemaining);
    await _prefs.setInt(ConstantStrings.score, score);
  }

  setUserData({required String id, required String name}) async {
    await _prefs.setString(ConstantStrings.userId, id);
    await _prefs.setString(ConstantStrings.userName, name);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> clearPreferences() async {
    return await _prefs.clear();
  }
}
