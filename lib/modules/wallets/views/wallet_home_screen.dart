import 'package:gosharpsharp/core/utils/exports.dart';

class WalletHomeScreen extends StatelessWidget {
  const WalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            implyLeading: true,
            title: "Go-Wallet",
          ),
          body: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              walletController.getTransactions();
              walletController.getWalletBalance();
            },
            child: Container(
              height: 1.sh,
              width: 1.sw,
              padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
              decoration: const BoxDecoration(color: AppColors.backgroundColor),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.symmetric(
                        vertical: 18.sp,
                        horizontal: 15.sp,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.deepPrimaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              customText(
                                "Go-wallet balance",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(width: 10.w),
                              InkWell(
                                highlightColor: AppColors.transparent,
                                onTap: () {
                                  walletController
                                      .toggleWalletBalanceVisibility();
                                },
                                child: Icon(
                                  walletController.walletBalanceVisibility
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.whiteColor,
                                  size: 18.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                walletController.walletBalanceVisibility
                                    ? formatToCurrency(
                                        double.parse(
                                          walletController
                                                  .walletBalanceData
                                                  ?.balance ??
                                              "0.0",
                                        ),
                                      )
                                    : "*****",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontStyle: GoogleFonts.inter().fontStyle,
                                fontSize: 30.sp,
                                overflow: TextOverflow.visible,
                              ),

                              CustomGreenTextButton(
                                onPressed: () {
                                  walletController.clearFundingFields();
                                  Get.toNamed(Routes.FUND_WALLET_SCREEN);
                                },
                                title: "Fund wallet",
                                bgColor: AppColors.primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "Bonus Balance",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                               fontStyle: GoogleFonts.inter().fontStyle,
                                fontSize: 15.sp,
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(height: 10.h),
                              customText(
                                walletController.walletBalanceVisibility
                                    ? formatToCurrency(
                                        double.parse(
                                          walletController
                                                  .walletBalanceData
                                                  ?.bonusBalance ??
                                              "0.0",
                                        ),
                                      )
                                    : "*****",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontStyle: GoogleFonts.inter().fontStyle,
                                fontSize: 20.sp,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 2.w),
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: 18.sp, horizontal: 15.sp),
                    //   decoration: BoxDecoration(
                    //       color: AppColors.whiteColor,
                    //       borderRadius: BorderRadius.circular(14.r)),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             SvgPicture.asset(
                    //               SvgAssets.courierIcon,
                    //               height: 25.sp,
                    //               width: 25.sp,
                    //             ),
                    //             SizedBox(
                    //               height: 12.h,
                    //             ),
                    //             customText("Invoices and payments history",
                    //                 color: AppColors.blackColor,
                    //                 fontWeight: FontWeight.normal,
                    //                 fontFamily:
                    //                     GoogleFonts.inter().fontFamily!,
                    //                 fontSize: 14.sp,
                    //                 overflow: TextOverflow.visible),
                    //           ],
                    //         ),
                    //       ),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: [
                    //           SvgPicture.asset(
                    //             SvgAssets.rightChevronIcon,
                    //             height: 12.sp,
                    //             width: 12.sp,
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 10.h),
                    PartialViewHeader(
                      onPressed: () {
                        Get.toNamed(Routes.TRANSACTIONS_SCREEN);
                        // Get.to(const TransactionsScreen());
                      },
                      title: "Transactions history",
                    ),
                    SizedBox(height: 10.h),
                    Visibility(
                      visible: walletController.transactions.isNotEmpty,
                      replacement: Visibility(
                        visible:
                            walletController.isLoading &&
                            walletController.transactions.isEmpty,
                        replacement: Container(
                          height: 150.sp,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: customText("No transactions yet")),
                            ],
                          ),
                        ),
                        child: Container(
                          height: 150.sp,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: customText("Loading....")),
                            ],
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                              walletController.transactions.take(5).length,
                              (i) => TransactionItem(
                                onTap: () {
                                  walletController.setSelectedTransaction(
                                    walletController.transactions[i],
                                  );
                                  Get.toNamed(
                                    Routes.TRANSACTION_DETAILS_SCREEN,
                                  );
                                },
                                transaction: walletController.transactions[i],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
