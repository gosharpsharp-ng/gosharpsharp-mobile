import 'package:gosharpsharp/core/utils/exports.dart';

class MenuService extends CoreService {
  Future<MenuService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/me");
  }

  Future<APIResponse> updateMenu(dynamic data) async {
    return await update("/customer/menus", data);
  }

  Future<APIResponse> getMenuCategories(dynamic data) async {
    return await fetch(
      "/customers/menu-categories?page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getMenuCategoryById(dynamic data) async {
    return await fetch("/customer/menu-categories/${data['id']}");
  }

  Future<APIResponse> getAllMenu(dynamic data) async {
    return await fetch(
      "/customers/menus?restaurant_id=${data['restaurant_id']}&per_page=${data['per_page']}&search=${data['search'] ?? ''}",
    );
  }

  Future<APIResponse> getMenuById(dynamic data) async {
    return await fetch("/customer/menus/${data['id']}");
  }
}
