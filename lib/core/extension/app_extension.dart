


extension ListIndexNullable<T> on List<T> {
  int? indexWhereOrNull(bool Function(T item) test) {
    final index = indexWhere(test);
    return index == -1 ? null : index;
  }
}