import 'package:flutter_template_bloc/core/network/dio_client.dart';
import 'package:flutter_template_bloc/core/session/data/models/user_model.dart';
import 'package:flutter_template_bloc/features/dashboard/data/models/product_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<UserModel> getUserProfile();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({required this.dioClient});
  final DioClient dioClient;

  static const String kProducts = "/products";

  static const String kProfile = "/auth/profile";

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dioClient.get(kProducts);
      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> list = responseData['data'] as List<dynamic>;
      return list
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserProfile() async{
    try {
      final response = await dioClient.get(kProfile);

      return UserModel.fromJson(response.data["data"]);
    } catch (_) {
      rethrow;
    }
  }
}
