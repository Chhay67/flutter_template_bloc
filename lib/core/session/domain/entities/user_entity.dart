import 'package:equatable/equatable.dart';
import 'package:flutter_template_bloc/core/session/data/models/user_model.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.name,
    required this.id,
    required this.username,
  });

  final String id;
  final String name;
  final String username;

  UserModel toModel() {
    return UserModel(id: id, name: name, username: username);
  }

  @override
  List<Object?> get props => [name, username, id];
}
