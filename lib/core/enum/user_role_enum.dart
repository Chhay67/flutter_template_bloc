enum UserRoleEnum {
  user('user'),
  admin('admin');

  const UserRoleEnum(this.value);

  final String value;

  static UserRoleEnum fromValue(String? value) {
    return UserRoleEnum.values.firstWhere(
      (role) => role.value == value?.toLowerCase(),
      orElse: () => UserRoleEnum.user,
    );
  }
}
