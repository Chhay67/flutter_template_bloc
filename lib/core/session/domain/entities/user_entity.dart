import 'package:equatable/equatable.dart';
import 'package:flutter_template_bloc/core/session/data/models/user_model.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.name,
    required this.email,
    required this.id,
    required this.age,
  });

  final String id;
  final String name;
  final int? age;

  final String? email;

  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      age: age,
      email: email,
    );
  }

  @override
  List<Object?> get props => [name, email, id, age];
}
