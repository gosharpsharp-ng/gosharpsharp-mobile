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

  RestaurantModel? selectedRestaurant;

  // Data lists
  List<RestaurantModel> restaurants = [];
  List<RestaurantModel> favoriteRestaurants = [];
  List<FoodModel> menuItems = [];
  List<String> categories = [];
  List<MenuCategory> menuCategories = [];

  // Track favorites (by restaurant id)
  final Set<int> _favoriteRestaurantIds = {};

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
    fetchFavoriteRestaurants();
    // fetchMenuCategories();
  }

  // Set selected restaurant
  setSelectedRestaurant(RestaurantModel restaurant) {
    selectedRestaurant = restaurant;
    // Fetch menu items for this restaurant
    fetchRestaurantMenus(restaurant.id.toString());
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
      APIResponse response = await restaurantService.getMyFavourites({'type': 'restaurant'});


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
      showToast(message: "Failed to fetch favorite restaurants: $e", isError: true);
    } finally {
      setFavoritesLoadingState(false);
    }
  }

  // Fetch restaurant menus
  Future<void> fetchRestaurantMenus(String restaurantId, {String categoryId = '', String query = ''}) async {
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
            .map((json) => FoodModel.fromJson(json))
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
            .map((json) => MenuCategory.fromJson(json))
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
      APIResponse response = await restaurantService.toggleFavouriteRestaurant({'id': restaurant.id});

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
    Get.to(() => RestaurantDetailScreen());
  }

  // Navigate to food detail
  void navigateToFoodDetail(FoodModel food) {
    Get.to(
          () => FoodDetailScreen(
        foodName: food.name,
        price: food.price,
        foodImage: food.image ?? '',
        description: food.description ?? '',
        preparationTime: food.preparationTime ?? '15mins',
        rating: food.rating ?? 0.0,
        reviewCount: food.reviewCount ?? 0,
      ),
    );
  }

  // Filter restaurants by category
  List<RestaurantModel> getFilteredRestaurants() {
    if (selectedCategory.value == 'All') {
      return restaurants;
    }
    // Filter by cuisine type or add restaurant categories logic
    return restaurants.where((restaurant) =>
    restaurant.cuisineType?.toLowerCase() == selectedCategory.value.toLowerCase()
    ).toList();
  }

  // Get menu items for a specific restaurant
  List<FoodModel> getMenuItemsForRestaurant(String restaurantId) {
    return menuItems
        .where((item) => item.restaurantId == restaurantId)
        .toList();
  }

  // Update selected category
  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
    update();
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      fetchRestaurants(),
      fetchFavoriteRestaurants(),
      fetchMenuCategories(),
    ]);
  }

  // Get restaurant by ID
  Future<RestaurantModel?> getRestaurantById(int id) async {
    try {
      APIResponse response = await restaurantService.getRestaurantById({'id': id});

      if (response.status.toLowerCase() == "success") {
        return RestaurantModel.fromJson(response.data);
      }
    } catch (e) {
      showToast(message: "Failed to fetch restaurant details: $e", isError: true);
    }
    return null;
  }
}

// Updated FoodModel to work with API
class FoodModel {
  final int id;
  final String name;
  final String price;
  final String? description;
  final String? image;
  final String? category;
  final String? preparationTime;
  final double? rating;
  final int? reviewCount;
  final String restaurantId;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.image,
    this.category,
    this.preparationTime,
    this.rating,
    this.reviewCount,
    required this.restaurantId,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      description: json['description'],
      image: json['image'],
      category: json['category']?['name'],
      preparationTime: json['preparation_time'],
      rating: json['rating']?.toDouble(),
      reviewCount: json['review_count'],
      restaurantId: json['restaurant_id']?.toString() ?? '',
      isAvailable: json['is_available'] == 1,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
      'preparation_time': preparationTime,
      'rating': rating,
      'review_count': reviewCount,
      'restaurant_id': restaurantId,
      'is_available': isAvailable,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// Menu Category Model
class MenuCategory {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuCategory({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}