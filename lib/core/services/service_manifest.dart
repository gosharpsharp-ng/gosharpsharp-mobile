import 'package:gosharpsharp/core/services/restaurant/cart/restaurant_cart_service.dart';
import 'package:gosharpsharp/core/services/restaurant/menu/menu_service.dart';
import 'package:gosharpsharp/core/services/restaurant/orders/orders_service.dart';
import 'package:gosharpsharp/core/services/restaurant/restaurant_service.dart';
import 'package:gosharpsharp/core/services/restaurant/transactions/transactions_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthenticationService>(
    () => AuthenticationService(),
  );
  serviceLocator.registerLazySingleton<ProfileService>(() => ProfileService());
  serviceLocator.registerLazySingleton<DeliveryService>(
    () => DeliveryService(),
  );
  serviceLocator.registerLazySingleton<WalletsService>(() => WalletsService());
  serviceLocator.registerLazySingleton<MenuService>(() => MenuService());
  serviceLocator.registerLazySingleton<OrdersService>(() => OrdersService());
  serviceLocator.registerLazySingleton<RestaurantCartService>(() => RestaurantCartService());
  serviceLocator.registerLazySingleton<TransactionsService>(
    () => TransactionsService(),
  );
  serviceLocator.registerLazySingleton<RestaurantService>(
    () => RestaurantService(),
  );

  // serviceLocator.registerLazySingleton<User>(() => UserImpl());
}
