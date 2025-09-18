import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/dashboard/views/food_detail_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/restaurant_detail_screen.dart';

class DashboardController extends GetxController {
  // Selected category filter
  RxString selectedCategory = 'All'.obs;

  RestaurantModel? selectedRestaurant;

  setSelectedRestaurant(RestaurantModel restaurant) {
    selectedRestaurant = restaurant;
    update();
  }

  // Track favorites (by restaurant id)
  final Set<int> _favoriteRestaurantIds = {};

  void toggleFavorite(RestaurantModel restaurant) {
    if (_favoriteRestaurantIds.contains(restaurant.id)) {
      _favoriteRestaurantIds.remove(restaurant.id);
    } else {
      _favoriteRestaurantIds.add(restaurant.id);
    }
    update(); // refresh UI
  }

  bool isFavorite(int restaurantId) {
    return _favoriteRestaurantIds.contains(restaurantId);
  }

  // Mock data for restaurants
  List<RestaurantModel> restaurants = [
    RestaurantModel(
      id: 1,
      banner: null,
      logo: null,
      name: 'Late Nite Eats',
      description:
          'Forem ipsum dolor sit amet, consectetur adip iscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
      email: 'latenite@example.com',
      phone: '08000000001',
      cuisineType: null,
      isActive: 1,
      isFeatured: 0,
      commissionRate: '15.00',
      businessRegistrationNumber: null,
      taxIdentificationNumber: null,
      status: 'pending',
      userId: 1,
      deletedAt: null,
      createdAt: '2025-08-17T09:07:12.000000Z',
      updatedAt: '2025-08-17T09:07:12.000000Z',
      schedules: [
        Schedule(
          id: 1,
          restaurantId: 1,
          dayOfWeek: 'monday',
          openTime: '2025-08-17T09:00:00.000000Z',
          closeTime: '2025-08-17T21:00:00.000000Z',
          deletedAt: null,
          createdAt: '2025-08-17T09:07:12.000000Z',
          updatedAt: '2025-08-17T09:07:12.000000Z',
        ),
      ],
    ),
    RestaurantModel(
      id: 2,
      banner: null,
      logo: null,
      name: 'Jonny Rockets',
      description: 'Fast food restaurant with great burgers and fries.',
      email: 'jonnyrockets@example.com',
      phone: '08000000002',
      cuisineType: null,
      isActive: 1,
      isFeatured: 0,
      commissionRate: '15.00',
      businessRegistrationNumber: null,
      taxIdentificationNumber: null,
      status: 'pending',
      userId: 1,
      deletedAt: null,
      createdAt: '2025-08-17T09:07:12.000000Z',
      updatedAt: '2025-08-17T09:07:12.000000Z',
      schedules: [],
    ),
    RestaurantModel(
      id: 3,
      banner: null,
      logo: null,
      name: 'Pizza Hut',
      description: 'Delicious pizzas and Italian cuisine.',
      email: 'pizzahut@example.com',
      phone: '08000000003',
      cuisineType: null,
      isActive: 1,
      isFeatured: 1,
      commissionRate: '15.00',
      businessRegistrationNumber: null,
      taxIdentificationNumber: null,
      status: 'pending',
      userId: 1,
      deletedAt: null,
      createdAt: '2025-08-17T09:07:12.000000Z',
      updatedAt: '2025-08-17T09:07:12.000000Z',
      schedules: [],
    ),
  ];

  // Mock data for menu items
  List<FoodModel> menuItems = [
    FoodModel(
      id: '1',
      name: 'Amala and Gbegiri',
      price: '₦3,000.00',
      description:
          'Forem ipsum dolor sit amet, consectetur adip iscing elit. Nunc vulputate libero et velit inter.',
      image: PngAssets.chow1,
      category: 'Swallow',
      preparationTime: '10mins',
      rating: 5.0,
      reviewCount: 500,
      restaurantId: '1',
    ),
    FoodModel(
      id: '2',
      name: 'Drinkupucho',
      price: '₦3,000.00',
      description: 'Refreshing drink with natural ingredients.',
      image: PngAssets.chow2,
      category: 'Drinks',
      preparationTime: '5mins',
      rating: 4.8,
      reviewCount: 324,
      restaurantId: '1',
    ),
    FoodModel(
      id: '3',
      name: 'Jollof Rice',
      price: '₦2,500.00',
      description: 'Traditional Nigerian jollof rice with chicken.',
      image: PngAssets.chow3,
      category: 'Rice',
      preparationTime: '15mins',
      rating: 4.6,
      reviewCount: 432,
      restaurantId: '1',
    ),
  ];

  // Categories
  List<String> categories = [
    'All',
    'Lunch',
    'Breakfast',
    'Grills',
    'Snacks',
    'Bakery',
    'Ice cream',
    'Amala',
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize any required data
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
        foodImage: food.image,
        description: food.description,
        preparationTime: food.preparationTime,
        rating: food.rating,
        reviewCount: food.reviewCount,
      ),
    );
  }

  // Filter restaurants by category
  List<RestaurantModel> getFilteredRestaurants() {
    if (selectedCategory.value == 'All') {
      return restaurants;
    }
    // Add filtering logic here based on restaurant categories
    return restaurants;
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
}

class FoodModel {
  final String id;
  final String name;
  final String price;
  final String description;
  final String image;
  final String category;
  final String preparationTime;
  final double rating;
  final int reviewCount;
  final String restaurantId;

  FoodModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.preparationTime,
    required this.rating,
    required this.reviewCount,
    required this.restaurantId,
  });
}
