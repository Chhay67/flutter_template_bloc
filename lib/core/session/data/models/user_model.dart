import 'package:flutter_template_bloc/core/enum/user_role_enum.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.username,
    required super.id,
    super.role,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? "",
      role: UserRoleEnum.fromValue(json['role']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'username': username, 'role': role.value};
  }

  @override
  List<Object?> get props => [name, username, id, role];
}
