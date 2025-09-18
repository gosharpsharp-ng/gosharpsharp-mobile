import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignInController extends GetxController {
  final authService = serviceLocator<AuthenticationService>();
  final signInFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  bool signInPasswordVisibility = false;

  togglePasswordVisibility() {
    signInPasswordVisibility = !signInPasswordVisibility;
    update();
  }

  bool signInWithEmail = true;

  toggleSignInWithEmail() {
    signInWithEmail = !signInWithEmail;
    loginController.clear();
    update();
  }

  TextEditingController loginController = TextEditingController();

  setPhoneNumber(val) {
    loginController.text = val;
    update();
  }

  PhoneNumber? filledPhoneNumber;
  setFilledPhoneNumber(PhoneNumber num) {
    filledPhoneNumber = num;
    update();
  }

  TextEditingController passwordController = TextEditingController();
  signIn() async {
    if (signInFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'login': signInWithEmail
            ? loginController.text
            : filledPhoneNumber?.completeNumber ?? "",
        'password': passwordController.text,
      };
      APIResponse response = await authService.login(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);

      if (response.status.toLowerCase() == "success") {
        loginController.clear();
        passwordController.clear();
        filledPhoneNumber=null;
        update();
        final getStorage = GetStorage();
        getStorage.write("token", response.data['auth_token']);
        Get.put(WalletController());
        Get.put(SettingsController());
        Get.put(DeliveriesController());
        Get.toNamed(Routes.APP_NAVIGATION);
      }
    }
  }
}
