
import 'package:flutter_template_bloc/core/session/domain/entities/user_entity.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/entities/product_entity.dart';

abstract class DashboardRepository {
  Future<List<ProductEntity>> getProducts();

  Future<UserEntity> getUserProfile();
}