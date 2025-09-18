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
