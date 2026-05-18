import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/core/use_cases/usecase.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/entities/product_entity.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/use_case/get_products.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductsCubit(this._getProductsUseCase) : super(ProductsInitial());

  Future<void> getProducts() async{
    try {
      emit(ProductsLoading());
      final result = await _getProductsUseCase.call(NoParams());
      emit(ProductsLoaded(products: result));
    } catch (error) {
      emit(ProductError(message: error.toString()));
    }
  }


}
