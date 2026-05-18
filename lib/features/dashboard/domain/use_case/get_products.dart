
import 'package:flutter_template_bloc/core/use_cases/usecase.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/entities/product_entity.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/repository/dashboard_repository.dart';

class GetProductsUseCase extends UseCase<List<ProductEntity>,NoParams> {
  GetProductsUseCase({required this.repository});
  final DashboardRepository repository;


  @override
  Future<List<ProductEntity>> call(NoParams params) async{
    return await repository.getProducts();
  }

}