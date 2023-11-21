import 'StorageManager.dart';

class StorageHelperManager {
  static Future<String?> getString(String key) async {
    StorageManager _manager = StorageManager();
    return await _manager.getString(key);
  }

  static Future<int> getInt(String key, {int? defaultValue}) async {
    StorageManager _manager = StorageManager();
    return await _manager.getInt(key, defaultValue: defaultValue) ?? defaultValue ?? 0;
  }

  static Future<bool?> getBool(String key) async {
    StorageManager _manager = StorageManager();
    return await _manager.getBool(key);
  }

  static Future<void> setString(String key, String value) async {
    StorageManager _manager = StorageManager();
    await _manager.setString(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    StorageManager _manager = StorageManager();
    await _manager.setInt(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    StorageManager _manager = StorageManager();
    await _manager.setBool(key, value);
  }

  static Future<void> removeByKey(String key, {bool useSharedPrefs = false}) async {
    StorageManager _manager = StorageManager();
    await _manager.removeByKey(key);
  }
}