import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A single key-value pair stored in secure storage.
class StorageItem {
  /// Creates a [StorageItem] with a [key] and its associated [value].
  StorageItem(this.key, this.value);

  /// The storage key.
  final String key;

  /// The stored value.
  final String value;
}

/// Service for reading and writing encrypted data using [FlutterSecureStorage].
///
/// On Android, encrypted shared preferences are used for extra security.
class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  /// Writes [value] to secure storage under the given [key].
  Future<void> writeSecureData(String key, String value) async {
    await _secureStorage.write(
        key: key, value: value, aOptions: _getAndroidOptions());
  }

  /// Reads and returns the value stored under [key], or `null` if absent.
  Future<String?> readSecureData(String key) async {
    var readData =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  /// Deletes the entry associated with [key] from secure storage.
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  /// Returns all entries in secure storage as a list of [StorageItem].
  Future<List<StorageItem>> readAllSecureData() async {
    debugPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<StorageItem> list =
        allData.entries.map((e) => StorageItem(e.key, e.value)).toList();
    return list;
  }

  /// Deletes all entries from secure storage.
  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  /// Returns `true` if secure storage contains an entry for [key].
  Future<bool> containsKeyInSecureData(String key) async {
    var containsKey = await _secureStorage.containsKey(
        key: key, aOptions: _getAndroidOptions());
    return containsKey;
  }
}
