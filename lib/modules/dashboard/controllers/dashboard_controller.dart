import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/dashboard/views/food_detail_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/restaurant_detail_screen.dart';

class DashboardController extends GetxController {
  // Selected category filter
  RxString selectedCategory = 'All'.obs;

  // Mock data for restaurants
  List<RestaurantModel> restaurants = [
    RestaurantModel(
      id: '1',
      name: 'Late Nite Eats',
      description: 'Forem ipsum dolor sit amet, consectetur adip iscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
      location: 'AYA, Abuja',
      openingHours: '7:00 AM - 10:30 PM',
      image: PngAssets.chow1,
      rating: 4.5,
      distance: '1.2 km',
      deliveryTime: '20-30 min',
      isWalkable: true,
      isFreeDelivery: true,
    ),
    RestaurantModel(
      id: '2',
      name: 'Jonny Rockets',
      description: 'Fast food restaurant with great burgers and fries.',
      location: 'Wuse 2, Abuja',
      openingHours: '8:00 AM - 11:00 PM',
      image: PngAssets.chow2,
      rating: 4.2,
      distance: '2.1 km',
      deliveryTime: '25-35 min',
      isWalkable: false,
      isFreeDelivery: false,
    ),
    RestaurantModel(
      id: '3',
      name: 'Pizza Hut',
      description: 'Delicious pizzas and Italian cuisine.',
      location: 'Garki, Abuja',
      openingHours: '10:00 AM - 10:00 PM',
      image: PngAssets.chow3,
      rating: 4.7,
      distance: '1.8 km',
      deliveryTime: '30-40 min',
      isWalkable: false,
      isFreeDelivery: true,
    ),
  ];

  // Mock data for menu items
  List<FoodModel> menuItems = [
    FoodModel(
      id: '1',
      name: 'Amala and Gbegiri',
      price: '₦3,000.00',
      description: 'Forem ipsum dolor sit amet, consectetur adip iscing elit. Nunc vulputate libero et velit inter.',
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
    'Amala'
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize any required data
  }

  // Navigate to restaurant detail
  void navigateToRestaurant(RestaurantModel restaurant) {
    Get.to(() => RestaurantDetailScreen(
      restaurantName: restaurant.name,
      restaurantImage: restaurant.image,
      restaurantDescription: restaurant.description,
      location: restaurant.location,
      openingHours: restaurant.openingHours,
    ));
  }

  // Navigate to food detail
  void navigateToFoodDetail(FoodModel food) {
    Get.to(() => FoodDetailScreen(
      foodName: food.name,
      price: food.price,
      foodImage: food.image,
      description: food.description,
      preparationTime: food.preparationTime,
      rating: food.rating,
      reviewCount: food.reviewCount,
    ));
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
    return menuItems.where((item) => item.restaurantId == restaurantId).toList();
  }

  // Update selected category
  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
    update();
  }
}

// Model classes
class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String openingHours;
  final String image;
  final double rating;
  final String distance;
  final String deliveryTime;
  final bool isWalkable;
  final bool isFreeDelivery;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.openingHours,
    required this.image,
    required this.rating,
    required this.distance,
    required this.deliveryTime,
    required this.isWalkable,
    required this.isFreeDelivery,
  });
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