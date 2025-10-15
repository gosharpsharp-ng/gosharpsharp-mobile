import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

class RecentlyVisitedRestaurantsService {
  static const String _storageKey = 'recent_restaurants';
  static const int _maxRecentRestaurants = 2;

  final GetStorage _storage = GetStorage();

  /// Add a restaurant to the recently visited list
  Future<void> addRecentRestaurant({
    required int id,
    required String name,
    String? banner,
  }) async {
    try {
      // Get current list
      List<Map<String, dynamic>> recentList = getRecentRestaurants();

      // Remove if already exists (to avoid duplicates and update position)
      recentList.removeWhere((restaurant) => restaurant['id'] == id);

      // Add to the front (most recent)
      recentList.insert(0, {
        'id': id,
        'name': name,
        'banner': banner,
        'visitedAt': DateTime.now().toIso8601String(),
      });

      // Keep only the most recent N restaurants
      if (recentList.length > _maxRecentRestaurants) {
        recentList = recentList.sublist(0, _maxRecentRestaurants);
      }

      // Save back to storage
      await _storage.write(_storageKey, recentList);
      debugPrint('✅ Added restaurant to recent: $name (ID: $id)');
    } catch (e) {
      debugPrint('❌ Error adding recent restaurant: $e');
    }
  }

  /// Get the list of recently visited restaurants
  List<Map<String, dynamic>> getRecentRestaurants() {
    try {
      final data = _storage.read(_storageKey);
      if (data == null) return [];

      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((item) => Map<String, dynamic>.from(item)),
        );
      }
    } catch (e) {
      debugPrint('❌ Error reading recent restaurants: $e');
    }
    return [];
  }

  /// Clear all recently visited restaurants
  Future<void> clearRecentRestaurants() async {
    try {
      await _storage.remove(_storageKey);
      debugPrint('✅ Cleared recent restaurants');
    } catch (e) {
      debugPrint('❌ Error clearing recent restaurants: $e');
    }
  }

  /// Check if a restaurant is in the recent list
  bool isRecentRestaurant(int id) {
    final recentList = getRecentRestaurants();
    return recentList.any((restaurant) => restaurant['id'] == id);
  }

  /// Get a specific recent restaurant by ID
  Map<String, dynamic>? getRecentRestaurantById(int id) {
    final recentList = getRecentRestaurants();
    try {
      return recentList.firstWhere((restaurant) => restaurant['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
