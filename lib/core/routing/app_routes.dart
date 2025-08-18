// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const SIGNUP_SCREEN = _Paths.SIGNUP_SCREEN;
  static const SIGNUP_OTP_SCREEN = _Paths.SIGNUP_OTP_SCREEN;
  static const SIGNUP_SUCCESS_SCREEN = _Paths.SIGNUP_SUCCESS_SCREEN;
  static const RESET_PASSWORD_EMAIL_ENTRY_SCREEN =
      _Paths.RESET_PASSWORD_EMAIL_ENTRY_SCREEN;
  static const RESET_PASSWORD_NEW_PASSWORD_SCREEN =
      _Paths.RESET_PASSWORD_NEW_PASSWORD_SCREEN;
  static const RESET_PASSWORD_OTP_SCREEN = _Paths.RESET_PASSWORD_OTP_SCREEN;
  static const RESET_PASSWORD_SUCCESS_SCREEN =
      _Paths.RESET_PASSWORD_SUCCESS_SCREEN;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const ONBOARDING_BUSINESS_OPERATIONS =
      _Paths.ONBOARDING_BUSINESS_OPERATIONS;
  static const ONBOARDING_BANK_INFORMATION = _Paths.ONBOARDING_BANK_INFORMATION;
  static const APP_NAVIGATION = _Paths.APP_NAVIGATION;

  static const DELIVERIES_HOME = _Paths.DELIVERIES_HOME;
  static const DELIVERY_DETAILS = _Paths.DELIVERY_DETAILS;
  static const PROCESSED_DELIVERY_SUMMARY_SCREEN =
      _Paths.PROCESSED_DELIVERY_SUMMARY_SCREEN;
  static const DELIVERY_INVOICE_DETAILS = _Paths.DELIVERY_INVOICE_DETAILS;
  static const DELIVERY_TRACKING_SCREEN = _Paths.DELIVERY_TRACKING_SCREEN;
  static const RIDE_SELECTION_SCREEN = _Paths.RIDE_SELECTION_SCREEN;
  static const INITIATE_DELIVERY_SCREEN = _Paths.INITIATE_DELIVERY_SCREEN;
  static const DELIVERY_ITEM_INPUT_SCREEN = _Paths.DELIVERY_ITEM_INPUT_SCREEN;
  static const DELIVERY_SUCCESS_SCREEN = _Paths.DELIVERY_SUCCESS_SCREEN;
  static const DELIVERY_PAYMENT_OPTIONS_SCREEN =
      _Paths.DELIVERY_PAYMENT_OPTIONS_SCREEN;
  static const DELIVERY_SUMMARY_SCREEN = _Paths.DELIVERY_SUMMARY_SCREEN;
  static const NOTIFICATIONS_HOME = _Paths.NOTIFICATIONS_HOME;
  static const NOTIFICATIONS_DETAILS = _Paths.NOTIFICATIONS_DETAILS;
  static const RATINGS_AND_REVIEWS_HOME = _Paths.RATINGS_AND_REVIEWS_HOME;
  static const SETTINGS_HOME_SCREEN = _Paths.SETTINGS_HOME_SCREEN;
  static const PROFILE_SETTINGS_SCREEN = _Paths.PROFILE_SETTINGS_SCREEN;
  static const EDIT_PROFILE_SCREEN = _Paths.EDIT_PROFILE_SCREEN;
  static const CHANGE_PASSWORD_SCREEN = _Paths.CHANGE_PASSWORD_SCREEN;
  static const NEW_PASSWORD_ENTRY_SCREEN = _Paths.NEW_PASSWORD_ENTRY_SCREEN;
  static const WALLETS_HOME_SCREEN = _Paths.WALLETS_HOME_SCREEN;
  static const TRANSACTIONS_SCREEN = _Paths.TRANSACTIONS_SCREEN;
  static const TRANSACTION_DETAILS_SCREEN = _Paths.TRANSACTION_DETAILS_SCREEN;
  static const FUND_WALLET_SCREEN = _Paths.FUND_WALLET_SCREEN;
  static const FAQS_SCREEN = _Paths.FAQS_SCREEN;
  static const DELETE_ACCOUNT_SCREEN = _Paths.DELETE_ACCOUNT_SCREEN;
  static const SELECT_LOCATION_SCREEN = _Paths.SELECT_LOCATION_SCREEN;
}

abstract class _Paths {
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

  static const WALLETS_HOME_SCREEN = '/wallets_home_screen';
  static const FUND_WALLET_SCREEN = '/fund_wallet_screen';
  static const TRANSACTIONS_SCREEN = '/transactions_screen';
  static const TRANSACTION_DETAILS_SCREEN = '/transaction_details_screen';

  static const RATINGS_AND_REVIEWS_HOME = '/ratings_and_reviews_home';
  static const SELECT_LOCATION_SCREEN = '/select_location_screen';
}
