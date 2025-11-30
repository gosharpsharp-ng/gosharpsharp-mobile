import 'package:gosharpsharp/core/utils/exports.dart';

class RestaurantService extends CoreService {
  Future<RestaurantService> init() async => this;

  Future<APIResponse> getRestaurants([dynamic data]) async {
    // Debug log to see what data we're receiving
    customDebugPrint("getRestaurants data: $data");

    // Ensure longitude and latitude are present and valid
    if (data['longitude'] == null || data['latitude'] == null) {
      throw Exception("Longitude and latitude are required");
    }

    String queryParams =
        "longitude=${data['longitude']}&latitude=${data['latitude']}";

    // Add optional on_promo parameter
    if (data.containsKey('on_promo') && data['on_promo'] == true) {
      queryParams += "&on_promo=true";
    }

    // Add optional search parameter
    if (data.containsKey('search') && data['search'].toString().isNotEmpty) {
      queryParams += "&search=${Uri.encodeComponent(data['search'])}";
    }

    // Add optional category_id parameter
    if (data.containsKey('category_id') &&
        data['category_id'].toString().isNotEmpty &&
        data['category_id'] != 0) {
      queryParams += "&category_id=${data['category_id']}";
    }

    customDebugPrint("Final query params: $queryParams");
    return await fetch("/restaurants?$queryParams");
  }

  Future<APIResponse> getRestaurantMenu(dynamic data) async {
    return await fetch(
      "/customers/menus?per_page=${data['per_page']}&restaurant_id=${data['restaurant_id']}&category_id=${data['cat_id']}&search=${data['query']}",
    );
  }

  Future<APIResponse> getRestaurantById(dynamic data) async {
    return await fetch("/restaurants/${data['id']}");
  }

  Future<APIResponse> toggleFavouriteRestaurant(dynamic data) async {
    return await send("/me/favorites/restaurants/${data['id']}", {});
  }

  Future<APIResponse> toggleFavouriteMenu(dynamic data) async {
    return await send("/me/favorites/menus/${data['id']}", {});
  }

  Future<APIResponse> getMyFavourites(dynamic data) async {
    return await fetch("/me/favorites?type=${data['type']}");
  }

  Future<APIResponse> getMenuCategories(dynamic data) async {
    final endpoint = "/restaurants/menu-categories?page=${data['page']}&page_size=${data['per_page']}";
    customDebugPrint("Fetching menu categories from: $endpoint");
    final response = await fetch(endpoint);
    customDebugPrint("Menu categories response: ${response.data}");
    return response;
  }

  Future<APIResponse> getMenuCategoryById(dynamic data) async {
    return await fetch("/customer/menu-categories/${data['id']}");
  }

  Future<APIResponse> getAllMenu(dynamic data) async {
    return await fetch(
      "/customer/menus?fresh=${data['fresh']}&page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getMenuById(dynamic data) async {
    return await fetch("/customer/menus/${data['id']}");
  }
}
