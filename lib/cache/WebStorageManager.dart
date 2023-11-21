import 'package:shared_preferences/shared_preferences.dart';
import 'StorageManager.dart';

// MMKV being not available for web, we use shared_preferences instead.

StorageManager initManager() => WebStorageManager();

StorageManager createManager() => WebStorageManager();

class WebStorageManager implements StorageManager {

  WebStorageManager();

  Future<void> initialize() async {}

  Future<String> getString(String key) async {
    return await SharedPreferences.getInstance().then((instance) {
      return instance.getString(key) ?? "";
    });
  }

  Future<void> setString(String key, String value) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.setString(key, value);
    });
  }

  Future<int?> getInt(String key, {int? defaultValue}) async {
    return await SharedPreferences.getInstance().then((instance) {
      return instance.getInt(key) ?? defaultValue ?? 0;
    });
  }

  Future<void> setInt(String key, int value) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.setInt(key, value);
    });
  }

  Future<bool?> getBool(String key) async {
    return await SharedPreferences.getInstance().then((instance) {
      return instance.getBool(key);
    });
  }

  Future<void> setBool(String key, bool value) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.setBool(key, value);
    });
  }

  Future<void> removeByKey(String key) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.remove(key);
    });
  }
}