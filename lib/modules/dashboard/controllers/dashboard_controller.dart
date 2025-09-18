import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/services/restaurant/restaurant_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/dashboard/views/food_detail_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/restaurant_detail_screen.dart';

class DashboardController extends GetxController {
  final restaurantService = serviceLocator<RestaurantService>();

  // Loading states
  bool _isLoadingRestaurants = false;
  bool _isLoadingFavorites = false;
  bool _isLoadingMenus = false;

  get isLoadingRestaurants => _isLoadingRestaurants;
  get isLoadingFavorites => _isLoadingFavorites;
  get isLoadingMenus => _isLoadingMenus;

  void setRestaurantsLoadingState(bool val) {
    _isLoadingRestaurants = val;
    update();
  }

  void setFavoritesLoadingState(bool val) {
    _isLoadingFavorites = val;
    update();
  }

  void setMenusLoadingState(bool val) {
    _isLoadingMenus = val;
    update();
  }

  // Selected category filter
  RxString selectedCategory = 'All'.obs;

  // Selected items
  RestaurantModel? selectedRestaurant;
  MenuItemModel? selectedMenuItem;

  // Data lists
  List<RestaurantModel> restaurants = [];
  List<RestaurantModel> favoriteRestaurants = [];
  List<MenuItemModel> menuItems = [];
  List<String> categories = [];
  List<CategoryModel> menuCategories = [];

  // Track favorites (by restaurant id)
  final Set<int> _favoriteRestaurantIds = {};

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
    fetchFavoriteRestaurants();
    fetchMenuCategories();
  }

  // Set selected restaurant
  setSelectedRestaurant(RestaurantModel restaurant) {
    selectedRestaurant = restaurant;
    // Fetch menu items for this restaurant
    fetchRestaurantMenus(restaurant.id.toString());
    update();
  }

  // Set selected menu item
  setSelectedMenuItem(MenuItemModel menuItem) {
    selectedMenuItem = menuItem;
    update();
  }

  // Fetch all restaurants
  Future<void> fetchRestaurants() async {
    try {
      setRestaurantsLoadingState(true);
      APIResponse response = await restaurantService.getRestaurants({});

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
        favoriteRestaurants = (response.data['data'] as List)
            .map((json) => RestaurantModel.fromJson(json['favoritable']))
            .toList();

        // Update favorite IDs set
        _favoriteRestaurantIds.clear();
        for (var restaurant in favoriteRestaurants) {
          _favoriteRestaurantIds.add(restaurant.id);
        }
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(
        message: "Failed to fetch favorite restaurants: $e",
        isError: true,
      );
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
        menuItems = (response.data['data'] as List)
            .map((json) => MenuItemModel.fromJson(json))
            .toList();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to fetch menu items: $e", isError: true);
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
          favoriteRestaurants.add(restaurant);
          showToast(message: "Added to favorites", isError: false);
        }
        update();
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

  // Filter restaurants by category
  List<RestaurantModel> getFilteredRestaurants() {
    if (selectedCategory.value == 'All') {
      return restaurants;
    }
    // Filter by cuisine type or add restaurant categories logic
    return restaurants
        .where(
          (restaurant) =>
              restaurant.cuisineType?.toLowerCase() ==
              selectedCategory.value.toLowerCase(),
        )
        .toList();
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
    update();
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
    return item.isAvailable == 1 && item.availableQuantity > 0;
  }

  // Helper method to get menu item availability status
  String getMenuItemAvailabilityStatus(MenuItemModel item) {
    if (item.isAvailable != 1) {
      return "Unavailable";
    }
    if (item.availableQuantity <= 0) {
      return "Out of Stock";
    }
    if (item.availableQuantity < 5) {
      return "Limited Stock";
    }
    return "Available";
  }
}
