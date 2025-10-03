import 'dart:io';

import 'package:gosharpsharp/core/models/faq_data_model.dart';
import 'package:gosharpsharp/core/services/support/support_service.dart';

import '../../../core/utils/exports.dart';

class SupportController extends GetxController {
  final supportService = serviceLocator<SupportService>();
  final GetStorage getStorage = GetStorage();

  setSelectedFaq({required FaqDataModel faq}) {
    selectedFaq = faq;
    update();
  }

  bool fetchingFaqs = false;
  FaqDataModel? selectedFaq;
  List<FaqDataModel> faqs = [];
  String selectedFaqCategory = "";
  getFaqs() async {
    fetchingFaqs = true;
    update();
    APIResponse response = await supportService.getFaq();
    fetchingFaqs = false;
    update();
    if (response.status == "success") {
      customDebugPrint(response.data['categories']);
      faqs = (response.data['categories'] as List)
          .map((fq) => FaqDataModel.fromJson(fq))
          .toList();
      if (faqs.isNotEmpty) {
          setSelectedFaq(faq: faqs[0]);
      }
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
          message: response.message,
          isError: response.status != "success",
        );
      }
    }
  }

  @override
  void onInit() async {
    await getFaqs();
    super.onInit();
  }
}
