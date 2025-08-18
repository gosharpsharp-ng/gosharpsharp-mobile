import 'package:gosharpsharp/core/utils/exports.dart';

class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/me");
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await formUpdate("/me", data);
  }

  Future<APIResponse> getNotifications(dynamic data) async {
    return await fetch(
        "/me/notifications?page=${data['page']}&page_size=${data['per_page']}");
  }

  Future<APIResponse> getNotificationById(dynamic data) async {
    return await fetch("/me/notifications/${data['id']}");
  }

  Future<APIResponse> changePassword(dynamic data) async {
    return await send("/auth/change-password", data);
  }

  Future<APIResponse> deleteAccount(dynamic data) async {
    return await remove("/me", data);
  }
}
