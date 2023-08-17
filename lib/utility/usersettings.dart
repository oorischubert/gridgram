import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserSettings {
  static SharedPreferences? _preferences;

  static const _keyDark = 'darkBool';
  static const _keyUserID = 'authString';
  static const _classKey = 'classKey';

//initializer
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

   //darkBool setter
  static Future setDark(bool dark) async =>
      await _preferences?.setBool(_keyDark, dark);

  //darkBool getter
  static bool getDark() => _preferences?.getBool(_keyDark) ?? true;

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    //google sign in user key setter
  static Future setUserID(String userKey) async =>
      await _preferences?.setString(_keyUserID, userKey);

  //user key getter (remove initial key once google login complete!)
  static String getUserID() => _preferences?.getString(_keyUserID) ?? ''; 

  //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  //student access key
  static Future setClassKey(String classKey) async =>
      await _preferences?.setString(_classKey, classKey);

  //student access key getter
  static String getClassKey() => _preferences?.getString(_classKey) ?? '';

}

//provides instances for Provider!
class UserProvider extends ChangeNotifier {

  bool _isDark = true;
  bool get isDark => _isDark;

  String _userID = '';
  String get userID => _userID;

  String _classKey = '';
  String get classKey => _classKey;

  //initializer
  UserProvider() {
    getDark();
    getUserKey();
    getClassKey();
  }

  getDark() async {
    _isDark = UserSettings.getDark();
    notifyListeners();
  }

  set isDark(bool value) {
    _isDark = value;
    UserSettings.setDark(value);
    notifyListeners();
  }

  getUserKey() async {
    _userID = UserSettings.getUserID();
    notifyListeners();
  }

  set userID(String value) {
    _userID = value;
    UserSettings.setUserID(value);
    notifyListeners();
  }

  getClassKey() async {
    _classKey = UserSettings.getClassKey();
    notifyListeners();
  }

  set classKey(String value) {
    _classKey = value;
    UserSettings.setClassKey(value);
    notifyListeners();
  }

}
