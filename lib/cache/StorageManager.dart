import 'StorageStub.dart'
if (dart.library.io) 'MobileStorageManager.dart'
if (dart.library.html) 'WebStorageManager.dart';

abstract class StorageManager {
  // factory constructor to return the correct implementation.
  factory StorageManager() => createManager();

  factory StorageManager.init() => initManager();

  // Must be called in the main before runApp
  Future<void> initialize() async {}

  Future<String?> getString(String key) async {
    return "";
  }

  Future<void> setString(String key, String value) async {}

  Future<int?> getInt(String key, {int? defaultValue}) async {
    return defaultValue ?? -1;
  }

  Future<void> setInt(String key, int value) async {}

  Future<bool?> getBool(String key) async {
    return false;
  }

  Future<void> setBool(String key, bool value) async {}

  Future<void> removeByKey(String key) async {}
}