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
import '../../features/auth/presentation/cubit/login_cubit/login_cubit.dart';
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

Future<void> initBootDependencies() async {
  await _initCoreServices();
  await _initCoreStorage();

  _initSessionDependencies();
  _initAppBootCore();
}

Future<void> initLazyDependencies() async {
 await _initNetwork();

  initAuthDependencies();
  // initProductDependencies();
}

Future<void> _initCoreServices() async {
  if (!serviceLocator.isRegistered<HiveService>()) {
    serviceLocator.registerLazySingleton<HiveService>(
          () => HiveService(),
    );
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
  serviceLocator.registerLazySingleton<SessionLocalDataSource>(
        () => SessionLocalDataSourceImpl(
      tokenStorage: serviceLocator<TokenStorage>(),
      userStorage: serviceLocator<UserStorage>(),
    ),
  );

  serviceLocator.registerLazySingleton<SessionRepository>(
        () => SessionRepositoryImpl(
      sessionLocalDataSource: serviceLocator<SessionLocalDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetSavedSessionUseCase>(
        () => GetSavedSessionUseCase(repository:  serviceLocator<SessionRepository>()),
  );

  serviceLocator.registerLazySingleton<SaveSessionUseCase>(
        () => SaveSessionUseCase( repository: serviceLocator<SessionRepository>()),
  );

  serviceLocator.registerLazySingleton<ClearSessionUseCase>(
        () => ClearSessionUseCase(repository: serviceLocator<SessionRepository>()),
  );
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

Future<void> _initNetwork() async{
  if (!serviceLocator.isRegistered<DioClient>()) {
    serviceLocator.registerLazySingleton<DioClient>(
          () => DioClient(
        baseUrl: AppConfig.baseUrl,
        tokenStorage: serviceLocator<TokenStorage>(),
        appLoadingCubit: serviceLocator<AppLoadingCubit>(),
      ),
    );
  }
}

void initAuthDependencies() {
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      dioClient: serviceLocator<DioClient>(),
    ),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(repository: serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerLazySingleton<LogoutUseCase>(
        () => LogoutUseCase(repository: serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerFactory<LoginCubit>(
        () => LoginCubit(
      loginUseCase: serviceLocator<LoginUseCase>(),
      appSessionCubit: serviceLocator<AppSessionCubit>(),
    ),
  );
}