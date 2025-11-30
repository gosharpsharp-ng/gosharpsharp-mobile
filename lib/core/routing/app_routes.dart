// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const SIGN_IN = '/sign_in';
  static const SIGNUP_SCREEN = '/signup_screen';
  static const SIGNUP_OTP_SCREEN = '/signup_otp_screen';
  static const SIGNUP_SUCCESS_SCREEN = '/signup_success_screen';
  static const RESET_PASSWORD_EMAIL_ENTRY_SCREEN =
      '/reset_password_email_entry_screen';
  static const RESET_PASSWORD_NEW_PASSWORD_SCREEN =
      '/reset_password_new_password_screen';
  static const RESET_PASSWORD_OTP_SCREEN = '/reset_password_otp_screen';

  static const RESET_PASSWORD_SUCCESS_SCREEN = '/reset_password_success_screen';
  static const DASHBOARD = '/dashboard';
  static const ONBOARDING_BUSINESS_OPERATIONS =
      '/onboarding_business_operations';
  static const ONBOARDING_BANK_INFORMATION = '/onboarding_bank_information';
  static const APP_NAVIGATION = '/app_navigation';

  static const DELIVERIES_HOME = '/deliveries_home';
  static const DELIVERY_DETAILS = '/delivery_details';
  static const PROCESSED_DELIVERY_SUMMARY_SCREEN =
      '/processed_delivery_details';
  static const DELIVERY_TRACKING_SCREEN = '/delivery_tracking_screen';
  static const DELIVERY_INVOICE_DETAILS = '/delivery_invoice_details';
  static const INITIATE_DELIVERY_SCREEN = '/initiate_delivery_screen';
  static const DELIVERY_SUCCESS_SCREEN = '/delivery_success_screen';
  static const DELIVERY_FAILURE_SCREEN = '/delivery_failure_screen';
  static const DELIVERY_ITEM_INPUT_SCREEN = '/delivery_item_input_screen';
  static const DELIVERY_PAYMENT_OPTIONS_SCREEN =
      '/delivery_payment_options_screen';
  static const RIDE_SELECTION_SCREEN = '/ride_selection_screen';
  static const DELIVERY_SUMMARY_SCREEN = '/delivery_summary_screen';

  static const NOTIFICATIONS_HOME = '/notifications_home';
  static const NOTIFICATIONS_DETAILS = '/notifications_details';

  static const SETTINGS_HOME_SCREEN = '/settings_home_screen';
  static const PROFILE_SETTINGS_SCREEN = '/profile_settings_screen';
  static const DELETE_ACCOUNT_SCREEN = '/delete_account_screen';
  static const EDIT_PROFILE_SCREEN = '/edit_profile_screen';
  static const CHANGE_PASSWORD_SCREEN = '/change_password_screen';
  static const NEW_PASSWORD_ENTRY_SCREEN = '/new_password_entry_screen';
  static const FAQS_SCREEN = '/faqs_screen';
  static const FAVOURITES_SCREEN = '/favourites_screen';

  static const WALLETS_HOME_SCREEN = '/wallets_home_screen';
  static const FUND_WALLET_SCREEN = '/fund_wallet_screen';
  static const FUND_WALLET_SUCCESS_SCREEN = '/fund_wallet_success_screen';
  static const FUND_WALLET_FAILURE_SCREEN = '/fund_wallet_failure_screen';
  static const TRANSACTIONS_SCREEN = '/transactions_screen';
  static const TRANSACTION_DETAILS_SCREEN = '/transaction_details_screen';

  static const RATINGS_AND_REVIEWS_HOME = '/ratings_and_reviews_home';
  static const SELECT_LOCATION_SCREEN = '/select_location_screen';
  static const LOCATION_PERMISSION_SCREEN = '/location_permission_screen';

  // Orders
  static const ORDERS_HOME_SCREEN = '/orders_home_screen';
  static const ORDER_DETAILS_SCREEN = '/order_details_screen';
  static const CART_SCREEN = '/cart_screen';
  static const CHECKOUT_SCREEN = '/checkout_screen';
  static const ORDER_SUCCESS_SCREEN = '/order_success_screen';
  static const ORDER_FAILURE_SCREEN = '/order_failure_screen';

  // Parcel Deliveries
  static const PARCEL_DELIVERIES_HOME_SCREEN = '/parcel_deliveries_home_screen';
  static const PARCEL_DELIVERY_DETAILS_SCREEN = '/parcel_delivery_details_screen';
  static const PARCEL_DELIVERY_TRACKING_SCREEN = '/parcel_delivery_tracking_screen';

//   Restaurant

  static const RESTAURANT_DETAILS_SCREEN = '/restaurant_details_screen';
}


