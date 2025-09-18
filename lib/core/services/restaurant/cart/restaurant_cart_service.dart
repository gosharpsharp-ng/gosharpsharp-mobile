import 'package:gosharpsharp/core/utils/exports.dart';

class RestaurantCartService extends CoreService {
  Future<RestaurantCartService> init() async => this;

  Future<APIResponse> getMenuCart() async {
    return await fetch("/menu-cart");
  }

  Future<APIResponse> removeFromMenuCart(dynamic data) async {
    return await remove("/menu-cart/items/${data['id']}");
  }

  Future<APIResponse> addToMenuCart(dynamic data) async {
    return await send("/menu-cart/items",data);
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
      "/customer/menus?fresh=${data['fresh']}&${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getMenuById(dynamic data) async {
    return await fetch("/customer/menus/${data['id']}");
  }
}
