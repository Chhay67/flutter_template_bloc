import 'package:equatable/equatable.dart';
import 'package:flutter_template_bloc/core/enum/user_role_enum.dart';
import 'package:flutter_template_bloc/core/session/data/models/user_model.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.name,
    required this.id,
    required this.username,
    this.role = UserRoleEnum.user,
  });

  final String id;
  final String name;
  final String username;
  final UserRoleEnum role;

  UserModel toModel() {
    return UserModel(id: id, name: name, username: username, role: role);
  }

  @override
  List<Object?> get props => [name, username, id, role];
}
