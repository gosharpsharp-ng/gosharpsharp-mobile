import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/services/restaurant/restaurant_service.dart';
import 'package:gosharpsharp/core/services/location/location_service.dart';
import 'package:gosharpsharp/core/services/recently_visited_restaurants_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/dashboard/views/food_detail_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/restaurant_detail_screen.dart';

class DashboardController extends GetxController {
  final restaurantService = serviceLocator<RestaurantService>();
  final recentRestaurantsService = RecentlyVisitedRestaurantsService();

  LocationService get locationService {
    try {
      return Get.find<LocationService>();
    } catch (e) {
      // Fallback if service not found - this should not happen in normal flow
      return Get.put(LocationService());
    }
  }

  // Loading states
  bool _isLoadingRestaurants = false;
  bool _isLoadingFavorites = false;
  bool _isLoadingMenus = false;

  get isLoadingRestaurants => _isLoadingRestaurants;
  get isLoadingFavorites => _isLoadingFavorites;
  get isLoadingMenus => _isLoadingMenus;

  void setRestaurantsLoadingState(bool val) {
    _isLoadingRestaurants = val;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void setFavoritesLoadingState(bool val) {
    _isLoadingFavorites = val;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void setMenusLoadingState(bool val) {
    _isLoadingMenus = val;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  // Selected category filter
  RxString selectedCategory = 'All'.obs;

  // Walking distance filter (true = walking distance only, false = all restaurants)
  RxBool isWalkingDistanceFilter = false.obs;

  // Filter states
  RxBool hasDiscountFilter = false.obs;
  RxBool hasFreeDeliveryFilter = false.obs;
  RxString selectedFoodType = ''.obs;

  // Search query state
  RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Category icons mapping
  Map<String, IconData> get categoryIcons => {
    'All': Icons.restaurant_menu,
    'Breakfast': Icons.free_breakfast,
    'Lunch': Icons.lunch_dining,
    'Dinner': Icons.dinner_dining,
    'Snacks': Icons.cookie,
    'Drinks': Icons.local_cafe,
    'Desserts': Icons.icecream,
  };

  // Selected items
  RestaurantModel? selectedRestaurant;
  MenuItemModel? selectedMenuItem;

  // Data lists
  List<RestaurantModel> restaurants = [];
  List<FavouriteRestaurantModel> favoriteRestaurants = [];
  List<MenuItemModel> menuItems = [];
  List<String> categories = [];
  List<CategoryModel> menuCategories = [];

  // Track favorites (by restaurant id)
  final Set<int> _favoriteRestaurantIds = {};

  @override
  void onInit() {
    super.onInit();
    // Defer all network calls to avoid blocking initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDashboard();
      _setupLocationListener();
    });
  }

  void _setupLocationListener() {
    // Get or create LocationController
    final locationController = Get.put(LocationController());

    // Listen to location changes and refetch restaurants
    ever(locationController.selectedLocation, (location) {
      if (location.isNotEmpty && location != 'Choose Location to continue') {
        debugPrint(
          '📍 Location changed to: $location - Refetching restaurants...',
        );
        fetchRestaurants();
        fetchFavoriteRestaurants();
      }
    });
  }

  Future<void> _initializeDashboard() async {
    await Future.wait([
      fetchRestaurants(),
      fetchFavoriteRestaurants(),
      fetchMenuCategories(),
    ]);
  }

  // Set selected restaurant
  setSelectedRestaurant(RestaurantModel restaurant) {
    selectedRestaurant = restaurant;
    // Track this restaurant as recently visited
    recentRestaurantsService.addRecentRestaurant(
      id: restaurant.id,
      name: restaurant.name,
      banner: restaurant.banner,
    );
    // Fetch menu items for this restaurant
    fetchRestaurantMenus(restaurant.id.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  // Set selected menu item
  setSelectedMenuItem(MenuItemModel menuItem) {
    selectedMenuItem = menuItem;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  // Fetch all restaurants using current location (with geofencing)
  Future<void> fetchRestaurants() async {
    try {
      setRestaurantsLoadingState(true);

      // Defer location service calls to avoid render pipeline interference
      await Future.delayed(Duration.zero);

      // Check if we should show restaurants (location permission + service area)
      bool shouldShow = false;
      try {
        shouldShow = locationService.shouldShowRestaurants();
      } catch (e) {
        print('Error checking location service: $e');
        shouldShow = false;
      }

      if (!shouldShow) {
        restaurants = [];
        setRestaurantsLoadingState(false);
        return;
      }

      // Get coordinates from location service (respects delivery location)
      late Map<String, double> coordinates;
      try {
        coordinates = locationService.getCoordinatesForRestaurants();
      } catch (e) {
        print('Error getting coordinates: $e');
        restaurants = [];
        setRestaurantsLoadingState(false);
        return;
      }
      Map<String, dynamic> filter = {
        "longitude": coordinates['longitude'],
        "latitude": coordinates['latitude'],
      };

      // Add promotion filter if enabled
      if (hasDiscountFilter.value) {
        filter['on_promo'] = true;
      }

      // Add search query if not empty
      if (searchQuery.value.isNotEmpty) {
        filter['search'] = searchQuery.value;
      }

      // Add category filter if a specific food type is selected
      if (selectedFoodType.value.isNotEmpty) {
        // Try to find the category ID from menuCategories
        final matchingCategory = menuCategories.firstWhere(
          (cat) =>
              cat.name.toLowerCase() == selectedFoodType.value.toLowerCase(),
          orElse: () => CategoryModel(id: 0, name: '', description: ''),
        );
        if (matchingCategory.id != 0) {
          filter['category_id'] = matchingCategory.id;
        }
      }

      APIResponse response = await restaurantService.getRestaurants(filter);

      if (response.status.toLowerCase() == "success") {
        // Handle both response formats: direct array or nested under 'data'
        final restaurantData = response.data is List
            ? response.data
            : (response.data['data'] ?? response.data);
        restaurants = (restaurantData as List)
            .map((json) => RestaurantModel.fromJson(json))
            .toList();

        // Update favorite IDs set
        _favoriteRestaurantIds.clear();
        for (var restaurant in restaurants) {
          // You can check if restaurant is favorited here based on API response
          // This might come from a separate field in the restaurant data
        }
      } else {
        customDebugPrint("Failed to fetch restaurants: ${response.message}");
        restaurants = [];
      }
    } catch (e) {
      customDebugPrint("Failed to fetch restaurants: $e");
      restaurants = [];
    } finally {
      setRestaurantsLoadingState(false);
    }
  }

  // Fetch favorite restaurants
  Future<void> fetchFavoriteRestaurants() async {
    try {
      setFavoritesLoadingState(true);
      APIResponse response = await restaurantService.getMyFavourites({
        'type': 'restaurant',
      });

      if (response.status.toLowerCase() == "success") {
        if (response.data != null && response.data['data'] != null) {
          final dataList = response.data['data'] as List? ?? [];
          favoriteRestaurants = dataList
              .where((json) => json != null)
              .map((json) {
                try {
                  return FavouriteRestaurantModel.fromJson(
                    json as Map<String, dynamic>,
                  );
                } catch (e, stackTrace) {
                  // Log parsing error for debugging
                  debugPrint('❌ Error parsing favorite restaurant: $e');
                  debugPrint('Stack trace: $stackTrace');
                  debugPrint('JSON data: $json');
                  return null;
                }
              })
              .where((restaurant) => restaurant != null)
              .cast<FavouriteRestaurantModel>()
              .toList();

          // Update favorite IDs set (use favoritableId which is the actual restaurant ID)
          _favoriteRestaurantIds.clear();
          for (var restaurant in favoriteRestaurants) {
            if (restaurant.favoritable != null) {
              _favoriteRestaurantIds.add(restaurant.favoritable!.id);
            }
          }

          debugPrint(
            '✅ Loaded ${favoriteRestaurants.length} favorite restaurants',
          );
          debugPrint('🔖 Favorite restaurant IDs: $_favoriteRestaurantIds');
        } else {
          favoriteRestaurants = [];
        }
      } else {
        // Silent fail - favorites are not critical for app functionality
        debugPrint('⚠️ Failed to fetch favorites: ${response.message}');
        favoriteRestaurants = [];
      }
    } catch (e) {
      // Silent fail - favorites are not critical, just log the error
      debugPrint('❌ Error fetching favorites: $e');
      favoriteRestaurants = [];
    } finally {
      setFavoritesLoadingState(false);
    }
  }

  // Fetch restaurant menus
  Future<void> fetchRestaurantMenus(
    String restaurantId, {
    String categoryId = '',
    String query = '',
  }) async {
    try {
      setMenusLoadingState(true);
      APIResponse response = await restaurantService.getRestaurantMenu({
        'per_page': 50,
        'restaurant_id': restaurantId,
        'cat_id': categoryId,
        'query': query,
      });

      if (response.status.toLowerCase() == "success") {
        if (response.data != null && response.data['data'] != null) {
          final dataList = response.data['data'] as List? ?? [];
          menuItems = dataList
              .where((json) => json != null)
              .map((json) {
                try {
                  return MenuItemModel.fromJson(json as Map<String, dynamic>);
                } catch (e) {
                  // Skip invalid menu items
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<MenuItemModel>()
              .toList();
        } else {
          menuItems = [];
        }
      } else {
        customDebugPrint("Failed to fetch menu items: ${response.message}");
        menuItems = [];
      }
    } catch (e) {
      customDebugPrint("Failed to fetch menu items: $e");
      menuItems = [];
    } finally {
      setMenusLoadingState(false);
    }
  }

  // Fetch menu categories
  Future<void> fetchMenuCategories() async {
    try {
      debugPrint('📋 Fetching menu categories...');
      APIResponse response = await restaurantService.getMenuCategories({
        'page': 1,
        'per_page': 50,
      });

      debugPrint('📋 Menu categories response status: ${response.status}');
      debugPrint('📋 Menu categories response data: ${response.data}');

      if (response.status.toLowerCase() == "success") {
        if (response.data != null) {
          // Handle paginated response: data is nested under response.data['data']['data']
          var categoriesData = response.data['data'];

          if (categoriesData != null) {
            // Check if it's paginated (has 'data' property) or direct array
            var categoryList =
                categoriesData is Map && categoriesData.containsKey('data')
                ? categoriesData['data']
                : categoriesData;

            if (categoryList is List) {
              menuCategories = categoryList
                  .map((json) => CategoryModel.fromJson(json))
                  .toList();

              debugPrint('✅ Loaded ${menuCategories.length} menu categories');
              for (var cat in menuCategories) {
                debugPrint(
                  '   - ${cat.name} (ID: ${cat.id}, Icon: ${cat.iconUrl})',
                );
              }

              // Update categories list for UI
              categories = ['All'];
              categories.addAll(menuCategories.map((cat) => cat.name));

              // Trigger UI update
              update();
            } else {
              debugPrint('⚠️ Category list is not an array: $categoryList');
              menuCategories = [];
            }
          } else {
            debugPrint('⚠️ No categories data found in response');
            menuCategories = [];
          }
        } else {
          debugPrint('⚠️ Response data is null');
          menuCategories = [];
        }
      } else {
        debugPrint('❌ Failed to fetch menu categories: ${response.message}');
        menuCategories = [];
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching menu categories: $e');
      debugPrint('Stack trace: $stackTrace');
      // Silent fail - categories will just not show, no need to interrupt user
      menuCategories = [];
    }
  }

  // Refresh restaurant details (menus and categories)
  Future<void> refreshRestaurantDetails(String restaurantId) async {
    try {
      await Future.wait([
        fetchRestaurantMenus(restaurantId),
        fetchMenuCategories(),
      ]);
    } catch (e) {
      debugPrint('Error refreshing restaurant details: $e');
    }
  }

  // Toggle favorite restaurant
  Future<void> toggleFavorite(RestaurantModel restaurant, BuildContext context) async {
    try {
      APIResponse response = await restaurantService.toggleFavouriteRestaurant({
        'id': restaurant.id,
      });

      if (response.status.toLowerCase() == "success") {
        final bool wasRemoved = _favoriteRestaurantIds.contains(restaurant.id);

        if (wasRemoved) {
          _favoriteRestaurantIds.remove(restaurant.id);
          favoriteRestaurants.removeWhere((r) => r.id == restaurant.id);
        } else {
          _favoriteRestaurantIds.add(restaurant.id);
          fetchFavoriteRestaurants();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          update();
        });

        // Show feedback after state update
        if (context.mounted) {
          if (wasRemoved) {
            ModernSnackBar.showInfo(
              context,
              message: "Removed from favorites",
            );
          } else {
            ModernSnackBar.showSuccess(
              context,
              message: "Added to favorites",
            );
          }
        }
      } else {
        customDebugPrint("Failed to toggle favorite: ${response.message}");
      }
    } catch (e) {
      customDebugPrint("Failed to toggle favorite: $e");
    }
  }

  // Check if restaurant is favorite
  bool isFavorite(int restaurantId) {
    return _favoriteRestaurantIds.contains(restaurantId);
  }

  // Navigate to restaurant detail
  void navigateToRestaurant(RestaurantModel restaurant) {
    setSelectedRestaurant(restaurant);
    Get.toNamed(Routes.RESTAURANT_DETAILS_SCREEN);
  }

  // Navigate to food detail - Updated to use MenuItemModel
  void navigateToFoodDetail(MenuItemModel food) {
    setSelectedMenuItem(food);
    Get.to(() => FoodDetailScreen());
  }

  // Filter restaurants by category and walking distance
  // Note: Promotion, search, and category filters are now handled server-side
  List<RestaurantModel> getFilteredRestaurants() {
    List<RestaurantModel> filteredRestaurants = restaurants;

    // Filter by walking distance (client-side only)
    if (isWalkingDistanceFilter.value) {
      filteredRestaurants = filteredRestaurants.where((restaurant) {
        try {
          // Parse distance string and check if it's walkable (e.g., <= 3 km)
          double distance = double.parse(restaurant.distance);
          return distance <= 3.0; // Walking distance threshold in km
        } catch (e) {
          // If distance parsing fails, assume it's not walkable
          return false;
        }
      }).toList();
    }

    // Filter by category (client-side only)
    if (selectedCategory.value != 'All') {
      filteredRestaurants = filteredRestaurants
          .where(
            (restaurant) =>
                restaurant.cuisineType?.toLowerCase() ==
                selectedCategory.value.toLowerCase(),
          )
          .toList();
    }

    // Filter by free delivery (client-side only)
    if (hasFreeDeliveryFilter.value) {
      filteredRestaurants = filteredRestaurants.where((restaurant) {
        return restaurant.freeDelivery;
      }).toList();
    }

    return filteredRestaurants;
  }

  // Get menu items for a specific restaurant
  List<MenuItemModel> getMenuItemsForRestaurant(String restaurantId) {
    return menuItems
        .where((item) => item.restaurant.id.toString() == restaurantId)
        .toList();
  }

  // Get menu items filtered by category
  List<MenuItemModel> getFilteredMenuItems(String categoryName) {
    if (categoryName == 'All') {
      return menuItems;
    }
    return menuItems
        .where(
          (item) =>
              item.category.name.toLowerCase() == categoryName.toLowerCase(),
        )
        .toList();
  }

  // Get menu items for restaurant filtered by category
  List<MenuItemModel> getFilteredMenuItemsForRestaurant(
    String restaurantId,
    String categoryName,
  ) {
    var restaurantMenus = getMenuItemsForRestaurant(restaurantId);
    if (categoryName == 'All') {
      return restaurantMenus;
    }
    return restaurantMenus
        .where(
          (item) =>
              item.category.name.toLowerCase() == categoryName.toLowerCase(),
        )
        .toList();
  }

  // Update selected category
  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  // Toggle walking distance filter
  void toggleWalkingDistanceFilter() {
    isWalkingDistanceFilter.value = !isWalkingDistanceFilter.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  // Toggle discount filter
  void toggleDiscountFilter() {
    hasDiscountFilter.value = !hasDiscountFilter.value;
    // Refetch restaurants with the promotion filter
    fetchRestaurants();
  }

  // Toggle free delivery filter
  void toggleFreeDeliveryFilter() {
    hasFreeDeliveryFilter.value = !hasFreeDeliveryFilter.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  // Update selected food type
  void updateSelectedFoodType(String foodType) {
    if (selectedFoodType.value == foodType) {
      selectedFoodType.value = ''; // Deselect if already selected
    } else {
      selectedFoodType.value = foodType;
    }
    // Refetch restaurants with the new category filter
    fetchRestaurants();
  }

  // Update search query and refetch restaurants
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    // Refetch restaurants with the new search query
    fetchRestaurants();
  }

  // Clear search query
  void clearSearch() {
    searchQuery.value = '';
    fetchRestaurants();
  }

  // Clear all filters
  void clearAllFilters() {
    selectedCategory.value = 'All';
    hasDiscountFilter.value = false;
    hasFreeDeliveryFilter.value = false;
    selectedFoodType.value = '';
    searchQuery.value = '';
    isWalkingDistanceFilter.value = false;
    // Refetch restaurants without any filters
    fetchRestaurants();
  }

  // Check if any filter is active
  bool get hasActiveFilters =>
      selectedCategory.value != 'All' ||
      hasDiscountFilter.value ||
      hasFreeDeliveryFilter.value ||
      selectedFoodType.value.isNotEmpty ||
      searchQuery.value.isNotEmpty ||
      isWalkingDistanceFilter.value;

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait<void>([
      fetchRestaurants(),
      fetchFavoriteRestaurants(),
      fetchMenuCategories(),
    ]);
  }

  // Get restaurant by ID
  Future<RestaurantModel?> getRestaurantById(int id) async {
    try {
      APIResponse response = await restaurantService.getRestaurantById({
        'id': id,
      });

      if (response.status.toLowerCase() == "success") {
        return RestaurantModel.fromJson(response.data);
      } else {
        customDebugPrint("Failed to fetch restaurant details: ${response.message}");
      }
    } catch (e) {
      customDebugPrint("Failed to fetch restaurant details: $e");
    }
    return null;
  }

  // Get menu item by ID
  Future<MenuItemModel?> getMenuItemById(int id) async {
    try {
      APIResponse response = await restaurantService.getMenuById({'id': id});

      if (response.status.toLowerCase() == "success") {
        return MenuItemModel.fromJson(response.data);
      } else {
        customDebugPrint("Failed to fetch menu item details: ${response.message}");
      }
    } catch (e) {
      customDebugPrint("Failed to fetch menu item details: $e");
    }
    return null;
  }

  // Helper method to check if menu item is available
  bool isMenuItemAvailable(MenuItemModel item) {
    return item.isAvailable == 1 && item.isPublished == 1;
  }

  // Helper method to get menu item availability status
  String getMenuItemAvailabilityStatus(MenuItemModel item) {
    if (item.isAvailable != 1) {
      return "Unavailable";
    }
    if (item.isPublished != 1) {
      return "Not Published";
    }
    return "Available";
  }

  // Get top-rated restaurants (those with best_rated or top_seller badges)
  List<RestaurantModel> getTopRatedRestaurants() {
    return restaurants.where((restaurant) {
      if (restaurant.badges == null || restaurant.badges!.isEmpty) {
        return false;
      }
      return restaurant.badges!.any((badge) =>
          badge.toLowerCase().contains('best_rated') ||
          badge.toLowerCase().contains('top_seller'));
    }).toList();
  }

  // Helper method to check if restaurant is within walking distance
  bool isRestaurantWalkable(RestaurantModel restaurant) {
    try {
      double distance = double.parse(restaurant.distance);
      return distance <= 3.0; // Walking distance threshold in km
    } catch (e) {
      return false;
    }
  }

  // Helper method to check if favourite restaurant is within walking distance
  bool isFavouriteRestaurantWalkable(FavouriteRestaurantModel restaurant) {
    try {
      double distance = double.parse(restaurant.favoritable?.distance ?? "999");
      return distance <= 3.0; // Walking distance threshold in km
    } catch (e) {
      return false;
    }
  }

  // Location management methods - with render-safe wrappers
  String getCurrentLocationAddress() {
    try {
      return locationService.getDisplayAddressForRestaurants();
    } catch (e) {
      return "Jos, Nigeria"; // Default fallback
    }
  }

  Future<void> refreshCurrentLocation() async {
    await locationService.refreshLocation();
    // Refetch restaurants with new location
    await fetchRestaurants();
  }

  Future<void> openLocationPicker() async {
    final selectedLocation = await locationService.selectDeliveryAddress();
    if (selectedLocation != null) {
      // Refetch restaurants with new delivery location
      await fetchRestaurants();
    }
  }

  bool hasValidLocation() {
    // Always return true - we use default location (Jos, Nigeria)
    return true;
  }

  bool shouldShowRestaurants() {
    try {
      return locationService.shouldShowRestaurants();
    } catch (e) {
      return false;
    }
  }

  bool isInServiceArea() {
    try {
      return locationService.shouldShowRestaurants();
    } catch (e) {
      return false;
    }
  }

  String getLocationStatusMessage() {
    try {
      if (!locationService.hasLocationPermission) {
        return "Location permission required to see restaurants";
      }
      if (!locationService.shouldShowRestaurants()) {
        return "We're not operating in your area yet. Select a delivery address in our service area.";
      }
      return "";
    } catch (e) {
      return "Location service unavailable";
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
