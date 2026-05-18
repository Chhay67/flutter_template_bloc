
class ProductEntity {
  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
});

  final String id;
  final String name;
  final String description;
  final num price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}