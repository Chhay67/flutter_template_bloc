import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/adapters.dart';
class SecureHiveService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    _initialized = true;
  }

  Future<Box> openEncryptedBox(String boxName) async {
    await init();

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }

    final encryptionKey = await _getEncryptionKey(boxName);

    return Hive.openBox(
      boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  static String _getEncryptionKeyName(String boxName) {
    return 'secure_${boxName}_encryption_key';
  }

  Future<List<int>> _getEncryptionKey(String boxName) async {
    final keyName = _getEncryptionKeyName(boxName);

    String? encodedKey = await _secureStorage.read(key: keyName);

    if (encodedKey == null) {
      final key = Hive.generateSecureKey();
      encodedKey = base64UrlEncode(key);

      await _secureStorage.write(key: keyName, value: encodedKey);
    }

    return base64Url.decode(encodedKey);
  }

  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  static Future<void> deleteEncryptionKey(String boxName) async {
    final keyName = _getEncryptionKeyName(boxName);
    await _secureStorage.delete(key: keyName);
  }

  static Future<void> deleteEncryptedBox(String boxName) async {
    await closeBox(boxName);
    await Hive.deleteBoxFromDisk(boxName);
    await deleteEncryptionKey(boxName);
  }
}