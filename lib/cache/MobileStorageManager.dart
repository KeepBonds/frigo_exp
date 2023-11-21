import 'package:mmkv/mmkv.dart';
import 'StorageManager.dart';

// Mobile version uses MMKV to achieve the best performance.

StorageManager initManager() => MobileStorageManager.init();

StorageManager createManager() => MobileStorageManager();

class MobileStorageManager implements StorageManager {
  MMKV? mmkv;
  String? rootDir;

  MobileStorageManager.init();

  MobileStorageManager() {
    mmkv = MMKV.defaultMMKV();
  }

  Future<void> initialize() async {
    rootDir = await MMKV.initialize();
    print('MMKV for flutter with rootDir = $rootDir');
  }


  Future<String?> getString(String key) async {
    if(mmkv != null) {
      return mmkv!.decodeString(key) ?? "";
    }
    return "";
  }

  Future<void> setString(String key, String value) async {
    if(mmkv != null) {
      mmkv!.encodeString(key, value);
    }
  }

  Future<int?> getInt(String key, {int? defaultValue}) async {
    if(mmkv != null) {
      return mmkv!.decodeInt(key, defaultValue: defaultValue ?? 0);
    }
    return defaultValue ?? -1;
  }

  Future<void> setInt(String key, int value) async {
    if(mmkv != null) {
      mmkv!.encodeInt(key, value);
    }
  }

  Future<bool?> getBool(String key) async {
    if(mmkv != null && mmkv!.containsKey(key)) {
      return mmkv!.decodeBool(key);
    }
    return null;
  }

  Future<void> setBool(String key, bool value) async {
    if(mmkv != null) {
      mmkv!.encodeBool(key, value);
    }
  }

  Future<void> removeByKey(String key) async {
    if(mmkv != null) {
      mmkv!.removeValue(key);
    }
  }
}