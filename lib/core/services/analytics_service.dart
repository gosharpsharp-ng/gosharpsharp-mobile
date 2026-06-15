import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  late final FirebaseAnalytics _analytics;
  late final FirebaseAnalyticsObserver observer;

  /// Initialize Firebase Analytics
  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      observer = FirebaseAnalyticsObserver(analytics: _analytics);
      print('✅ Firebase Analytics initialized');
    } catch (e) {
      print('❌ Error initializing Firebase Analytics: $e');
    }
  }

  /// Set user ID after login
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      print('✅ Analytics user ID set: $userId');
    } catch (e) {
      print('❌ Error setting user ID: $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      print('✅ Analytics property set: $name = $value');
    } catch (e) {
      print('❌ Error setting user property: $e');
    }
  }

  /// Log custom event
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      print('✅ Analytics event logged: $name');
    } catch (e) {
      print('❌ Error logging event: $e');
    }
  }

  /// Log screen view
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      print('❌ Error logging screen view: $e');
    }
  }

  /// Clear user data on logout
  Future<void> clearUser() async {
    try {
      await _analytics.setUserId(id: null);
      print('✅ Analytics user cleared');
    } catch (e) {
      print('❌ Error clearing user: $e');
    }
  }
}
