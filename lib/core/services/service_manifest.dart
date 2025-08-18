


import 'package:gosharpsharp/core/utils/exports.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  serviceLocator.registerLazySingleton<ProfileService>(() => ProfileService());
  serviceLocator.registerLazySingleton<DeliveryService>(() => DeliveryService());
  serviceLocator.registerLazySingleton<WalletsService>(() => WalletsService());

  // serviceLocator.registerLazySingleton<User>(() => UserImpl());
}