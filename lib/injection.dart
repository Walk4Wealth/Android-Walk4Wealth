import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import 'app/core/cache/cache_manager.dart';
import 'app/core/db/local_db.dart';
import 'app/core/network/device_connection.dart';
import 'app/core/network/dio_client.dart';
import 'app/core/setup/device/device_setup.dart';
import 'app/data/datasources/auth/auth_local_datasource.dart';
import 'app/data/datasources/auth/auth_remote_datasource.dart';
import 'app/data/datasources/point/point_local_datasource.dart';
import 'app/data/datasources/point/point_remote_datasource.dart';
import 'app/data/datasources/user/user_local_datasource.dart';
import 'app/data/datasources/user/user_remote_datasource.dart';
import 'app/data/repositories_impl/auth_repository_impl.dart';
import 'app/data/repositories_impl/point_repository_impl.dart';
import 'app/data/repositories_impl/user_repository_impl.dart';
import 'app/domain/repositories/auth_repository.dart';
import 'app/domain/repositories/point_repository.dart';
import 'app/domain/repositories/user_repository.dart';
import 'app/domain/usecases/auth/check_authentication.dart';
import 'app/domain/usecases/auth/get_token.dart';
import 'app/domain/usecases/auth/login_user.dart';
import 'app/domain/usecases/auth/logout_user.dart';
import 'app/domain/usecases/auth/register_user.dart';
import 'app/domain/usecases/point/get_all_product.dart';
import 'app/domain/usecases/point/get_all_vendor.dart';
import 'app/domain/usecases/point/get_history_transaction.dart';
import 'app/domain/usecases/point/get_product_by_id.dart';
import 'app/domain/usecases/point/get_vendor_by_id.dart';
import 'app/domain/usecases/point/reedem_point.dart';
import 'app/domain/usecases/user/delete_user.dart';
import 'app/domain/usecases/user/get_user.dart';
import 'app/domain/usecases/user/update_user.dart';
import 'app/presentation/providers/auth/load_provider.dart';
import 'app/presentation/providers/auth/login_provider.dart';
import 'app/presentation/providers/auth/logout_provider.dart';
import 'app/presentation/providers/auth/register_provider.dart';
import 'app/presentation/providers/shop_provider.dart';
import 'app/presentation/providers/tracking_provider.dart';
import 'app/presentation/providers/transaction_provider.dart';
import 'app/presentation/providers/user_provider.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  DeviceSetup.setup();

  await _globalDependencies();
  _authDependencies();
  _profileDependencies();
  _pointDependencies();
  _trackingDependencies();
}

//* global
Future<void> _globalDependencies() async {
  locator.registerLazySingleton(() => DioClient());
  locator.registerLazySingleton(() => CacheManager());
  locator.registerLazySingleton(() => const Distance());
  locator.registerLazySingleton(() => DeviceConnection());
  locator.registerLazySingletonAsync<Db>(() async {
    final db = Db();
    await db.init(); // init shared prefs
    return db;
  });
  await locator.isReady<Db>();
}

//* auth
void _authDependencies() {
  // provider
  locator.registerFactory(
    () => LoadProvider(authentication: locator<CheckAuthentication>()),
  );
  locator.registerFactory(
    () => LoginProvider(loginUser: locator<LoginUser>()),
  );
  locator.registerFactory(
    () => RegisterProvider(registerUser: locator<RegisterUser>()),
  );
  locator.registerFactory(
    () => LogoutProvider(
      logoutUser: locator<LogoutUser>(),
      deleteUser: locator<DeleteUser>(),
      cacheManager: locator<CacheManager>(),
    ),
  );

  // use case
  locator.registerLazySingleton(
    () => CheckAuthentication(repository: locator<AuthRepository>()),
  );
  locator.registerLazySingleton(
    () => LoginUser(repository: locator<AuthRepository>()),
  );
  locator.registerLazySingleton(
    () => RegisterUser(repository: locator<AuthRepository>()),
  );
  locator.registerLazySingleton(
    () => LogoutUser(repository: locator<AuthRepository>()),
  );
  locator.registerLazySingleton(
    () => GetToken(repository: locator<AuthRepository>()),
  );

  // repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDatasource: locator<AuthLocalDatasource>(),
      remoteDatasource: locator<AuthRemoteDatasource>(),
    ),
  );

  // datasource
  locator.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dioClient: locator<DioClient>(),
      connection: locator<DeviceConnection>(),
    ),
  );
  locator.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(db: locator<Db>()),
  );
}

//* profile
void _profileDependencies() {
  // provider
  locator.registerFactory(
    () => UserProvider(
      getUser: locator<GetUser>(),
      updateUser: locator<UpdateUser>(),
    ),
  );

  // usecase
  locator.registerLazySingleton(
    () => GetUser(repository: locator<UserRepository>()),
  );
  locator.registerLazySingleton(
    () => UpdateUser(repository: locator<UserRepository>()),
  );
  locator.registerLazySingleton(
    () => DeleteUser(repository: locator<UserRepository>()),
  );

  // repository
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      localDatasource: locator<UserLocalDatasource>(),
      remoteDatasource: locator<UserRemoteDatasource>(),
    ),
  );

  // datasource
  locator.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(
      getToken: locator<GetToken>(),
      dioClient: locator<DioClient>(),
      connection: locator<DeviceConnection>(),
    ),
  );
  locator.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(db: locator<Db>()),
  );
}

//* point
void _pointDependencies() {
  // provider
  locator.registerFactory(() => ShopProvider(
        getAllVendor: locator<GetAllVendor>(),
        getVendorById: locator<GetVendorById>(),
        getAllProduct: locator<GetAllProduct>(),
        getProductById: locator<GetProductById>(),
      ));
  locator.registerFactory(() => TransactionProvider(
        reedemPoint: locator<ReedemPoint>(),
        getHistoryTransaction: locator<GetHistoryTransaction>(),
      ));

  // usecase
  locator.registerLazySingleton(
    () => GetAllVendor(repository: locator<PointRepository>()),
  );
  locator.registerLazySingleton(
    () => GetVendorById(repository: locator<PointRepository>()),
  );
  locator.registerLazySingleton(
    () => GetAllProduct(repository: locator<PointRepository>()),
  );
  locator.registerLazySingleton(
    () => GetProductById(repository: locator<PointRepository>()),
  );
  locator.registerLazySingleton(
    () => ReedemPoint(repository: locator<PointRepository>()),
  );
  locator.registerLazySingleton(
    () => GetHistoryTransaction(repository: locator<PointRepository>()),
  );

  // repository
  locator.registerLazySingleton<PointRepository>(
    () => PointRepositoryImpl(
      localDatasource: locator<PointLocalDatasource>(),
      remoteDatasource: locator<PointRemoteDatasource>(),
    ),
  );

  // datasource
  locator.registerLazySingleton<PointRemoteDatasource>(
    () => PointRemoteDatasourceImpl(
      getToken: locator<GetToken>(),
      dioClient: locator<DioClient>(),
      connection: locator<DeviceConnection>(),
    ),
  );
  locator.registerLazySingleton<PointLocalDatasource>(
    () => PointLocalDatasourceImpl(cache: locator<CacheManager>()),
  );
}

//* tracking
void _trackingDependencies() {
  locator.registerFactory(
    () => TrackingProvider(distance: locator<Distance>()),
  );
}
