import 'package:flutter_template_bloc/features/auth/domain/use_cases/register.dart';
import 'package:flutter_template_bloc/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:flutter_template_bloc/features/dashboard/data/data_sources/remote_data_source.dart';
import 'package:flutter_template_bloc/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/use_case/get_products.dart';
import 'package:flutter_template_bloc/features/dashboard/domain/use_case/get_user_profile.dart';
import 'package:flutter_template_bloc/features/dashboard/presentation/bloc/user_profile_cubit/user_profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../app/bloc/app_loading_cubit/app_loading_cubit.dart';
import '../../app/bloc/app_session_cubit/app_session_cubit.dart';
import '../../app/route/app_router.dart';
import '../../features/auth/data/data_sources/remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/use_cases/login.dart';
import '../../features/auth/domain/use_cases/logout.dart';
import '../../features/auth/domain/use_cases/refresh_token.dart';
import '../../features/auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../features/dashboard/presentation/bloc/products_cubit/products_cubit.dart';
import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../service/hive_service.dart';
import '../service/secure_hive_service.dart';
import '../session/data/data_source/local_data_source.dart';
import '../session/data/repository/session_repository_impl.dart';
import '../session/domain/repository/session_repository.dart';
import '../session/domain/use_cases/clear_session.dart';
import '../session/domain/use_cases/get_saved_session.dart';
import '../session/domain/use_cases/save_session.dart';
import '../storage/token_storage.dart';
import '../storage/user_storage.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCoreServices();
  await _initCoreStorage();

  _initSessionDependencies();
  _initAppBootCore();
  _initNetwork();
  _initAuthDependencies();
  _initDashboardDependencies();
}

Future<void> _initCoreServices() async {
  if (!serviceLocator.isRegistered<HiveService>()) {
    serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  }

  if (!serviceLocator.isRegistered<SecureHiveService>()) {
    serviceLocator.registerLazySingleton<SecureHiveService>(
      () => SecureHiveService(),
    );
  }
}

Future<void> _initCoreStorage() async {
  final secureHive = serviceLocator<SecureHiveService>();

  if (!serviceLocator.isRegistered<TokenStorage>()) {
    final tokenBox = await secureHive.openEncryptedBox(TokenStorage.boxName);

    serviceLocator.registerLazySingleton<TokenStorage>(
      () => TokenStorage(tokenBox),
    );
  }

  if (!serviceLocator.isRegistered<UserStorage>()) {
    final userBox = await secureHive.openEncryptedBox(UserStorage.boxName);

    serviceLocator.registerLazySingleton<UserStorage>(
      () => UserStorage(userBox),
    );
  }
}

void _initSessionDependencies() {
  if (!serviceLocator.isRegistered<SessionLocalDataSource>()) {
    serviceLocator.registerLazySingleton<SessionLocalDataSource>(
      () => SessionLocalDataSourceImpl(
        tokenStorage: serviceLocator<TokenStorage>(),
        userStorage: serviceLocator<UserStorage>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<SessionRepository>()) {
    serviceLocator.registerLazySingleton<SessionRepository>(
      () => SessionRepositoryImpl(
        sessionLocalDataSource: serviceLocator<SessionLocalDataSource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetSavedSessionUseCase>()) {
    serviceLocator.registerLazySingleton<GetSavedSessionUseCase>(
      () => GetSavedSessionUseCase(
        repository: serviceLocator<SessionRepository>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<SaveSessionUseCase>()) {
    serviceLocator.registerLazySingleton<SaveSessionUseCase>(
      () => SaveSessionUseCase(repository: serviceLocator<SessionRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<ClearSessionUseCase>()) {
    serviceLocator.registerLazySingleton<ClearSessionUseCase>(
      () => ClearSessionUseCase(
        repository: serviceLocator<SessionRepository>(),
      ),
    );
  }
}

void _initAppBootCore() {
  if (!serviceLocator.isRegistered<AppLoadingCubit>()) {
    serviceLocator.registerLazySingleton<AppLoadingCubit>(
      () => AppLoadingCubit(),
    );
  }

  if (!serviceLocator.isRegistered<AppSessionCubit>()) {
    serviceLocator.registerLazySingleton<AppSessionCubit>(
      () => AppSessionCubit(
        getSavedSessionUseCase: serviceLocator<GetSavedSessionUseCase>(),
        saveSessionUseCase: serviceLocator<SaveSessionUseCase>(),
        clearSessionUseCase: serviceLocator<ClearSessionUseCase>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GoRouter>()) {
    serviceLocator.registerLazySingleton<GoRouter>(
      () => AppGoRouter.createRouter(
        appSessionCubit: serviceLocator<AppSessionCubit>(),
      ),
    );
  }
}

void _initNetwork() {
  if (!serviceLocator.isRegistered<DioClient>()) {
    serviceLocator.registerLazySingleton<DioClient>(
      () => DioClient(
        baseUrl: AppConfig.baseUrl,
        tokenStorage: serviceLocator<TokenStorage>(),
        appLoadingCubit: serviceLocator<AppLoadingCubit>(),
        appSessionCubit: serviceLocator<AppSessionCubit>(),
      ),
    );
  }
}

void _initAuthDependencies() {
  if (!serviceLocator.isRegistered<AuthRemoteDataSource>()) {
    serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dioClient: serviceLocator<DioClient>()),
    );
  }

  if (!serviceLocator.isRegistered<AuthRepository>()) {
    serviceLocator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<LoginUseCase>()) {
    serviceLocator.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(repository: serviceLocator<AuthRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<LogoutUseCase>()) {
    serviceLocator.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(repository: serviceLocator<AuthRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<RegisterUseCase>()) {
    serviceLocator.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(repository: serviceLocator<AuthRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<RefreshTokenUseCase>()) {
    serviceLocator.registerLazySingleton<RefreshTokenUseCase>(
      () => RefreshTokenUseCase(repository: serviceLocator<AuthRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<RegisterCubit>()) {
    serviceLocator.registerFactory<RegisterCubit>(
      () => RegisterCubit(serviceLocator<RegisterUseCase>()),
    );
  }

  if (!serviceLocator.isRegistered<LoginCubit>()) {
    serviceLocator.registerFactory<LoginCubit>(
      () => LoginCubit(
        loginUseCase: serviceLocator<LoginUseCase>(),
        appSessionCubit: serviceLocator<AppSessionCubit>(),
      ),
    );
  }
}

void _initDashboardDependencies() {
  if (!serviceLocator.isRegistered<DashboardRemoteDataSource>()) {
    serviceLocator.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(
        dioClient: serviceLocator<DioClient>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<DashboardRepository>()) {
    serviceLocator.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: serviceLocator<DashboardRemoteDataSource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetProductsUseCase>()) {
    serviceLocator.registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(
        repository: serviceLocator<DashboardRepository>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetUserProfileUseCase>()) {
    serviceLocator.registerLazySingleton<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(
        repository: serviceLocator<DashboardRepository>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<ProductsCubit>()) {
    serviceLocator.registerFactory<ProductsCubit>(
      () => ProductsCubit(serviceLocator<GetProductsUseCase>()),
    );
  }

  if (!serviceLocator.isRegistered<UserProfileCubit>()) {
    serviceLocator.registerFactory<UserProfileCubit>(
      () => UserProfileCubit(serviceLocator<GetUserProfileUseCase>()),
    );
  }
}
