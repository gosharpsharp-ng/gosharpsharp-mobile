// import 'package:go_logistics_client/middlewares/guard_middleware.dart';

import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/bindings/cart_bindings.dart';
import 'package:gosharpsharp/modules/cart/views/cart_screen.dart';
import 'package:gosharpsharp/modules/cart/views/order_checkout_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/favourites_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/restaurant_detail_screen.dart';
import 'package:gosharpsharp/modules/orders/bindings/orders_bindings.dart';
import 'package:gosharpsharp/modules/orders/views/order_details_screen.dart';
import 'package:gosharpsharp/modules/orders/views/orders_home_screen.dart';
import 'package:gosharpsharp/modules/support/bindings/support_bindings.dart';
import 'package:gosharpsharp/modules/support/views/faq_screen.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingBindings(),
    ),

    //
    GetPage(
      name: Routes.SIGNUP_SCREEN,
      page: () => const SignUpScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: Routes.SIGNUP_OTP_SCREEN,
      page: () => SignUpOtpScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_EMAIL_ENTRY_SCREEN,
      page: () => const ResetPasswordEmailEntry(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_OTP_SCREEN,
      page: () => ResetPasswordOtpScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_NEW_PASSWORD_SCREEN,
      page: () => const NewPasswordScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: Routes.APP_NAVIGATION,
      page: () => AppNavigationScreen(),
      //middlewares: [AuthMiddleware()],
      binding: AppNavigationBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DashboardBindings(),
    ),
    GetPage(
      name: Routes.FAVOURITES_SCREEN,
      page: () => const FavouritesScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DashboardBindings(),
    ),
    GetPage(
      name: Routes.RESTAURANT_DETAILS_SCREEN,
      page: () => const RestaurantDetailScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DashboardBindings(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS_HOME,
      page: () => const NotificationsHomeScreen(),
      //middlewares: [AuthMiddleware()],
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS_DETAILS,
      page: () => const NotificationDetailsScreen(),
      //middlewares: [AuthMiddleware()],
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: Routes.DELIVERIES_HOME,
      page: () => const DeliveriesHomeScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.PROCESSED_DELIVERY_SUMMARY_SCREEN,
      page: () => const ProcessedDeliverySummaryScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_INVOICE_DETAILS,
      page: () => const DeliveryInvoiceDetailsScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_SUCCESS_SCREEN,
      page: () => const DeliverySuccessScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_TRACKING_SCREEN,
      page: () => const DeliveryTrackingScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.INITIATE_DELIVERY_SCREEN,
      page: () => const InitiateDeliveryScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_ITEM_INPUT_SCREEN,
      page: () => const DeliveryItemInputScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.RIDE_SELECTION_SCREEN,
      page: () => const RideSelectionScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_PAYMENT_OPTIONS_SCREEN,
      page: () => const DeliveryPaymentOptionsScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_SUMMARY_SCREEN,
      page: () => const DeliverySummaryScreen(),
      //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.SETTINGS_HOME_SCREEN,
      page: () => const SettingsHomeScreen(),
      //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.DELETE_ACCOUNT_SCREEN,
      page: () => const DeleteAccountPasswordScreen(),
      //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),

    GetPage(
      name: Routes.CHANGE_PASSWORD_SCREEN,
      page: () => const ChangePasswordScreen(),
      //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),

    GetPage(
      name: Routes.FAQS_SCREEN,
      page: () => const FaqScreen(),
      //middlewares: [AuthMiddleware()],
      binding: SupportBindings(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreen(),
      //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.WALLETS_HOME_SCREEN,
      page: () => const WalletHomeScreen(),
      //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.FUND_WALLET_SCREEN,
      page: () => const FundWalletAmountScreen(),
      //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.TRANSACTIONS_SCREEN,
      page: () => const TransactionsScreen(),
      //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.TRANSACTION_DETAILS_SCREEN,
      page: () => const TransactionDetailsScreen(),
      //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.ORDERS_HOME_SCREEN,
      page: () => OrdersHomeScreen(),
      //middlewares: [AuthMiddleware()],
      binding: OrdersBindings(),
    ),
    GetPage(
      name: Routes.ORDER_DETAILS_SCREEN,
      page: () => const OrderDetailsScreen(),
      //middlewares: [AuthMiddleware()],
      binding: OrdersBindings(),
    ),
    GetPage(
      name: Routes.CART_SCREEN,
      page: () => const CartScreen(),
      //middlewares: [AuthMiddleware()],
      binding: CartBindings(),
    ),
    GetPage(
      name: Routes.CHECKOUT_SCREEN,
      page: () => const OrderCheckoutScreen(),
      //middlewares: [AuthMiddleware()],
      binding: CartBindings(),
    ),
    GetPage(
      name: Routes.SELECT_LOCATION_SCREEN,
      page: () => const SelectLocation(),
    ),
  ];
}
