import 'package:gosharpsharp/core/utils/exports.dart';

class RestaurantService extends CoreService {
  Future<RestaurantService> init() async => this;

  Future<APIResponse> getRestaurants([dynamic data]) async {
    return await fetch("/restaurants");
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
    return await fetch(
      "/customer/menu-categories?page=${data['page']}&page_size=${data['per_page']}",
    );
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