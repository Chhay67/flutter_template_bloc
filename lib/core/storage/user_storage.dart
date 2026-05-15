import 'package:hive_ce_flutter/adapters.dart';
import '../session/data/models/user_model.dart';

class UserStorage {
  static const String boxName = 'user';
  static const String _userKey = 'user_key';

  final Box _box;

  UserStorage(this._box);

  Future<void> saveUser(UserModel user) {
    return _box.put(_userKey, user.toJson());
  }

  UserModel? getUser() {
    final data = _box.get(_userKey);

    if (data == null) return null;

    return UserModel.fromJson(data);
  }

  Future<void> clearUser() {
    return _box.delete(_userKey);
  }
}
