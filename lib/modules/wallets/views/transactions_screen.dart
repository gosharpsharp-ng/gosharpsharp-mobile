import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/utils/widgets/pagination_button.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Transactions",
        ),
        // bottomNavigationBar: Container(
        //   padding: EdgeInsets.symmetric(vertical: 5.sp),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       PaginationButton(
        //           isForward: false,
        //           isActive: walletController.currentTransactionsPage > 1,
        //           onPressed: () {
        //             walletController.previousTransactionsPage();
        //           }),
        //       customText("${walletController.currentTransactionsPage}",
        //           color: AppColors.primaryColor, fontWeight: FontWeight.w600),
        //       customText(" of ",
        //           color: AppColors.primaryColor, fontWeight: FontWeight.w600),
        //       customText("${walletController.totalTransactionsPages}",
        //           color: AppColors.primaryColor, fontWeight: FontWeight.w600),
        //       PaginationButton(
        //           isForward: true,
        //           isActive: (walletController.currentTransactionsPage <
        //               walletController.totalTransactionsPages),
        //           onPressed: () {
        //             walletController.nextTransactionsPage();
        //           }),
        //     ],
        //   ),
        // ),
        backgroundColor: AppColors.backgroundColor,
        body: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: AppColors.whiteColor,
          onRefresh: () async {
            walletController.getTransactions();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: Visibility(
              visible: walletController.transactions.isNotEmpty,
              replacement: Visibility(
                visible: walletController.isLoading &&
                    walletController.transactions.isEmpty,
                replacement: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: customText("No transactions yet"),
                    ),
                  ],
                ),
                child: Center(
                  child: customText("Loading...."),
                ),
              ),
              child: SingleChildScrollView(
                controller: walletController.transactionsScrollController,
                child: Column(
                  children: [
                    ...List.generate(
                      walletController.transactions.length,
                      (i) => TransactionItem(
                        onTap: () {
                          walletController.setSelectedTransaction(
                              walletController.transactions[i]);
                          Get.toNamed(Routes.TRANSACTION_DETAILS_SCREEN);
                        },
                        transaction: walletController.transactions[i],
                      ),
                    ),
                    Visibility(
                      visible: walletController.fetchingTransactions &&
                          walletController.transactions.isNotEmpty,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customText("Loading more...",
                              color: AppColors.blueColor),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: walletController.transactions ==
                          walletController.totalTransactions,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customText("No more data to load",
                              color: AppColors.blueColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
