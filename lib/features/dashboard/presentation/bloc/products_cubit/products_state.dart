part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}


final class ProductsLoading extends ProductsState{}

final class ProductsLoaded extends ProductsState{
  final List<ProductEntity> products;
  ProductsLoaded({required this.products});
}

final class ProductError extends ProductsState{
  final String message;
  ProductError({required this.message});
}