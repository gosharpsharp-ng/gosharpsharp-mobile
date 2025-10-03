import '../../utils/exports.dart';

class SupportService extends CoreService {
  Future<SupportService> init() async => this;

  Future<APIResponse> getFaq() async {
    return await fetch("/faqs");
  }


}
