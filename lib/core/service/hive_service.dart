import 'package:hive_ce_flutter/adapters.dart';

class HiveService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    _initialized = true;
  }

  static Future<Box> openBox(String boxName) async {
    await init();

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }

    return Hive.openBox(boxName);
  }
}
