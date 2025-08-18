// import 'package:go_logistics_client/middlewares/guard_middleware.dart';

import 'package:gosharpsharp/core/utils/exports.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingBindings(),
    ),

    //
    GetPage(
      name: _Paths.SIGNUP_SCREEN,
      page: () => const SignUpScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: _Paths.SIGNUP_OTP_SCREEN,
      page: () => SignUpOtpScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_EMAIL_ENTRY_SCREEN,
      page: () => const ResetPasswordEmailEntry(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_OTP_SCREEN,
      page: () => ResetPasswordOtpScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_NEW_PASSWORD_SCREEN,
      page: () => const NewPasswordScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: _Paths.APP_NAVIGATION,
      page: () => AppNavigationScreen(),
     //middlewares: [AuthMiddleware()],
      binding: AppNavigationBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DashboardBindings(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS_HOME,
      page: () => const NotificationsHomeScreen(),
     //middlewares: [AuthMiddleware()],
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS_DETAILS,
      page: () => const NotificationDetailsScreen(),
     //middlewares: [AuthMiddleware()],
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERIES_HOME,
      page: () => const DeliveriesHomeScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.PROCESSED_DELIVERY_SUMMARY_SCREEN,
      page: () => const ProcessedDeliverySummaryScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_INVOICE_DETAILS,
      page: () => const DeliveryInvoiceDetailsScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_SUCCESS_SCREEN,
      page: () => const DeliverySuccessScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_TRACKING_SCREEN,
      page: () => const DeliveryTrackingScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.INITIATE_DELIVERY_SCREEN,
      page: () => const InitiateDeliveryScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_ITEM_INPUT_SCREEN,
      page: () => const DeliveryItemInputScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.RIDE_SELECTION_SCREEN,
      page: () => const RideSelectionScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_PAYMENT_OPTIONS_SCREEN,
      page: () => const DeliveryPaymentOptionsScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_SUMMARY_SCREEN,
      page: () => const DeliverySummaryScreen(),
     //middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.SETTINGS_HOME_SCREEN,
      page: () => const SettingsHomeScreen(),
     //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.DELETE_ACCOUNT_SCREEN,
      page: () => const DeleteAccountPasswordScreen(),
     //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),

    GetPage(
      name: _Paths.CHANGE_PASSWORD_SCREEN,
      page: () => const ChangePasswordScreen(),
     //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),

    GetPage(
      name: _Paths.FAQS_SCREEN,
      page: () => const FaqScreen(),
     //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreen(),
     //middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.WALLETS_HOME_SCREEN,
      page: () => const WalletHomeScreen(),
     //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: _Paths.FUND_WALLET_SCREEN,
      page: () => const FundWalletAmountScreen(),
     //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: _Paths.TRANSACTIONS_SCREEN,
      page: () => const TransactionsScreen(),
     //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_DETAILS_SCREEN,
      page: () => const TransactionDetailsScreen(),
     //middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: _Paths.SELECT_LOCATION_SCREEN,
      page: () => const SelectLocation(),
    ),
  ];
}
