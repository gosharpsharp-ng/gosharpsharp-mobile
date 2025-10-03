import 'package:gosharpsharp/core/utils/exports.dart';

class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/customers/profile");
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await update("/customers/profile", data);
  }

  Future<APIResponse> getNotifications(dynamic data) async {
    return await fetch("/customers/notification");
  }

  Future<APIResponse> getNotificationById(dynamic data) async {
    return await fetch("/customers/notifications/${data['id']}");
  }

  Future<APIResponse> changePassword(dynamic data) async {
    return await send("/customers/change-password", data);
  }

  Future<APIResponse> deleteAccount(dynamic data) async {
    return await remove("/me");
  }
}
