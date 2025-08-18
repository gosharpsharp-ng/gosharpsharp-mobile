import 'dart:developer';

import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WalletController extends GetxController {
  final walletService = serviceLocator<WalletsService>();
  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  final ScrollController transactionsScrollController = ScrollController();
  bool fetchingTransactions = false;

  void _transactionsScrollListener() {
    if (transactionsScrollController.position.pixels >=
        transactionsScrollController.position.maxScrollExtent - 100) {
      getTransactions(isLoadMore: true);
    }
  }

  int transactionsPageSize = 15;
  int totalTransactions = 0;
  int currentTransactionsPage = 1;
  List<Transaction> transactions = [];

  setTotalTransactions(int val) {
    totalTransactions = val;
    update();
  }

  getTransactions({bool isLoadMore = false}) async {
    if (fetchingTransactions ||
        (isLoadMore && transactions.length >= totalTransactions)) return;

    fetchingTransactions = true;
    update();

    if (!isLoadMore) {
      transactions.clear(); // Clear only when not loading more
      currentTransactionsPage = 1;
    }

    dynamic data = {
      "page": currentTransactionsPage,
      "per_page": transactionsPageSize,
    };

    APIResponse response = await walletService.getAllTransactions(data);
    fetchingTransactions = false;

    if (response.status == "success") {
      List<Transaction> newTransactions = (response.data['data'] as List)
          .map((tr) => Transaction.fromJson(tr))
          .toList();

      if (isLoadMore) {
        transactions.addAll(newTransactions);
      } else {
        transactions = newTransactions;
      }

      setTotalTransactions(response.data['total']);
      currentTransactionsPage++; // Increment for next load more
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  Transaction? selectedTransaction;
  setSelectedTransaction(Transaction tr) {
    selectedTransaction = tr;
    update();
  }

  getTransactionById() async {
    setLoadingState(true);
    dynamic data = {
      'id': selectedTransaction!.id,
    };
    APIResponse response = await walletService.getSingleTransaction(data);

    setLoadingState(false);
    if (response.status == "success") {
      selectedTransaction = Transaction.fromJson(response.data);
      update();
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
    }
  }

  bool walletBalanceVisibility = false;
  GetStorage getStorage = GetStorage();
  toggleWalletBalanceVisibility() {
    walletBalanceVisibility = !walletBalanceVisibility;
    getStorage.write("walletBalanceVisibility", walletBalanceVisibility);
    update();
  }

  WalletBalanceDataModel? walletBalanceData;
  getWalletBalance() async {
    APIResponse response = await walletService.getWalletBalance();
    setLoadingState(false);

    if (response.status == "success") {
      walletBalanceData = WalletBalanceDataModel.fromJson(response.data);
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  PayStackAuthorizationModel? payStackAuthorizationData;

  final fundWalletFormKey = GlobalKey<FormState>();
  bool fundingWallet = false;
  TextEditingController amountEntryController = TextEditingController();
  fundWallet() async {
    if (fundWalletFormKey.currentState!.validate()) {
      fundingWallet = true;
      update();
      dynamic data = {
        'amount': stripCurrencyFormat(amountEntryController.text),
      };

      APIResponse response = await walletService.fundWallet(data);
      fundingWallet = false;
      update();
      if (response.status == "success") {
        payStackAuthorizationData =
            PayStackAuthorizationModel.fromJson(response.data['data']);
        // amountEntryController.clear();
        update();
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  List<BankModel> banks = [];
  getBankList() async {
    setLoadingState(true);
    APIResponse response = await walletService.getBankList();
    showToast(message: response.message, isError: response.status != "success");
    setLoadingState(false);
    if (response.status == "success") {
      banks =
          (response.data as List).map((bk) => BankModel.fromJson(bk)).toList();
    }
  }

  clearFundingFields() {
    amountEntryController.clear();
    payStackAuthorizationData = null;
    update();
  }

  final payoutAccountFormKey = GlobalKey<FormState>();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  verifyPayoutBank() async {
    if (payoutAccountFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'account_number': accountNumberController.text,
        'bank_code': bankCodeController.text,
      };
      APIResponse response = await walletService.verifyPayoutBank(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {}
    }
  }

  TextEditingController otpController = TextEditingController();
  updatePayoutAccount() async {
    if (payoutAccountFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'bank_account_number': accountNumberController.text,
        'bank_code': bankCodeController.text,
        "otp": "1234",
      };
      APIResponse response = await walletService.updatePayoutAccount(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {}
    }
  }

  @override
  void onInit() {
    super.onInit();
    // transactionsScrollController.addListener(_transactionsScrollListener);
    // if (getStorage.read("walletBalanceVisibility") == null) {
    //   getStorage.write("walletBalanceVisibility", false);
    //   walletBalanceVisibility = getStorage.read("walletBalanceVisibility");
    // }
    // update();
    // getWalletBalance();
    // getTransactions();
  }
}
