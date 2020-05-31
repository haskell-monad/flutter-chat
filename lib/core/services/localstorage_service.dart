import 'dart:convert';

import 'package:flutterchat/core/common/matrix_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {

  /// 用戶
  static const String UserKey = 'user';

  /// 語言
  static const String AppLanguagesKey = 'languages';

  /// 主題
  static const String DarkModeKey = 'darkMode';


  static LocalStorageService _instance;
  static SharedPreferences _preferences;
  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  MatrixClient get user {
    var userJson = _getFromDisk(UserKey);
    if (userJson == null) {
      return null;
    }
    return MatrixClient.fromJson(json.decode(userJson));
  }

  set user(MatrixClient userToSave) {
    _saveToDisk(UserKey, json.encode(userToSave.toJson()));
  }

  bool get darkMode => _getFromDisk(DarkModeKey);

  set darkMode(bool value) => _saveToDisk(DarkModeKey, value);

  List<String> get languages => _getFromDisk(AppLanguagesKey);

  set languages(List<String> appLanguages) =>
      _saveToDisk(AppLanguagesKey, appLanguages);

  /// 保存到本地
  void _saveToDisk<T>(String key, T content) {
    print(
        '(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  /// 從本地獲取
  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

}
