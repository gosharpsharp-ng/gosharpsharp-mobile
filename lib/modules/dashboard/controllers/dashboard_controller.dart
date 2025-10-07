import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/services/restaurant/restaurant_service.dart';
import 'package:gosharpsharp/core/services/location/location_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/dashboard/views/food_detail_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/restaurant_detail_screen.dart';

class DashboardController extends GetxController {
  final restaurantService = serviceLocator<RestaurantService>();

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
        debugPrint('📍 Location changed to: $location - Refetching restaurants...');
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
      dynamic filter = {
        "longitude": coordinates['longitude'],
        "latitude": coordinates['latitude']
      };

      APIResponse response = await restaurantService.getRestaurants(filter);

      if (response.status.toLowerCase() == "success") {
        restaurants = (response.data['data'] as List)
            .map((json) => RestaurantModel.fromJson(json))
            .toList();

        // Update favorite IDs set
        _favoriteRestaurantIds.clear();
        for (var restaurant in restaurants) {
          // You can check if restaurant is favorited here based on API response
          // This might come from a separate field in the restaurant data
        }
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to fetch restaurants: $e", isError: true);
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
                  return FavouriteRestaurantModel.fromJson(json as Map<String, dynamic>);
                } catch (e) {
                  // Skip invalid favorites
                  return null;
                }
              })
              .where((restaurant) => restaurant != null)
              .cast<FavouriteRestaurantModel>()
              .toList();

          // Update favorite IDs set
          _favoriteRestaurantIds.clear();
          for (var restaurant in favoriteRestaurants) {
            _favoriteRestaurantIds.add(restaurant.id);
          }
        } else {
          favoriteRestaurants = [];
        }
      } else {
        showToast(message: response.message, isError: true);
        favoriteRestaurants = [];
      }
    } catch (e) {
      showToast(
        message: "Failed to fetch favorite restaurants: $e",
        isError: true,
      );
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
        showToast(message: response.message, isError: true);
        menuItems = [];
      }
    } catch (e) {
      showToast(message: "Failed to fetch menu items: $e", isError: true);
      menuItems = [];
    } finally {
      setMenusLoadingState(false);
    }
  }

  // Fetch menu categories
  Future<void> fetchMenuCategories() async {
    try {
      APIResponse response = await restaurantService.getMenuCategories({
        'page': 1,
        'per_page': 50,
      });

      if (response.status.toLowerCase() == "success") {
        menuCategories = (response.data['data'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        // Update categories list for UI
        categories = ['All'];
        categories.addAll(menuCategories.map((cat) => cat.name));
      }
    } catch (e) {
      showToast(message: "Failed to fetch menu categories: $e", isError: true);
    }
  }

  // Toggle favorite restaurant
  Future<void> toggleFavorite(RestaurantModel restaurant) async {
    try {
      APIResponse response = await restaurantService.toggleFavouriteRestaurant({
        'id': restaurant.id,
      });

      if (response.status.toLowerCase() == "success") {
        if (_favoriteRestaurantIds.contains(restaurant.id)) {
          _favoriteRestaurantIds.remove(restaurant.id);
          favoriteRestaurants.removeWhere((r) => r.id == restaurant.id);
          showToast(message: "Removed from favorites", isError: false);
        } else {
          _favoriteRestaurantIds.add(restaurant.id);
          fetchFavoriteRestaurants();
          showToast(message: "Added to favorites", isError: false);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          update();
        });
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to update favorites: $e", isError: true);
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
  List<RestaurantModel> getFilteredRestaurants() {
    List<RestaurantModel> filteredRestaurants = restaurants;

    // Filter by walking distance first (if enabled)
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

    // Then filter by category
    if (selectedCategory.value != 'All') {
      filteredRestaurants = filteredRestaurants
          .where(
            (restaurant) =>
                restaurant.cuisineType?.toLowerCase() ==
                selectedCategory.value.toLowerCase(),
          )
          .toList();
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
      }
    } catch (e) {
      showToast(
        message: "Failed to fetch restaurant details: $e",
        isError: true,
      );
    }
    return null;
  }

  // Get menu item by ID
  Future<MenuItemModel?> getMenuItemById(int id) async {
    try {
      APIResponse response = await restaurantService.getMenuById({'id': id});

      if (response.status.toLowerCase() == "success") {
        return MenuItemModel.fromJson(response.data);
      }
    } catch (e) {
      showToast(
        message: "Failed to fetch menu item details: $e",
        isError: true,
      );
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
}
