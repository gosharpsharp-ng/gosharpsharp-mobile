import 'package:gosharpsharp/core/utils/exports.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
        builder: (walletController){
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Transaction details",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child:  SingleChildScrollView(
              child: Column(
                children: [
                  SectionBox(children:  [
                    TransactionDetailSummaryItem(
                      title: "Amount",
                      value:formatToCurrency(double.parse(
                          walletController
                              .selectedTransaction?.amount ??
                              "0.0")),
                    ),
                    TransactionDetailSummaryItem(
                      title: "Transaction Ref",
                      value: walletController.selectedTransaction?.paymentReference??"",
                    ),
                    TransactionDetailSummaryTypeItem(
                      title: "Transaction type",
                      value:  walletController.selectedTransaction?.type.capitalize??"",
                    ),
                    const TransactionDetailSummaryTypeItem(
                      title: "Payment Method",
                      value: "GoWallet",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Date",
                      value: "${formatDate(walletController.selectedTransaction!.createdAt)} ${formatTime(walletController.selectedTransaction!.createdAt)}",
                    ),
                    TransactionDetailSummaryStatusItem(
                      title: "Status",
                      value: walletController.selectedTransaction!.status.capitalizeFirst??'',
                    ),
                  ]),
                  // SectionBox(children: const [
                  //   TransactionDetailSummaryItem(
                  //     title: "Sender's Name",
                  //     value: "Ayodeji Sebanjo",
                  //   ),
                  //   TransactionDetailSummaryItem(
                  //     title: "Phone Number",
                  //     value: "08162848289",
                  //   ),
                  //   TransactionDetailSummaryItem(
                  //     title: "Email",
                  //     value: "ayounie@gmail.com",
                  //   ),
                  //   TransactionDetailSummaryItem(
                  //     title: "Address",
                  //     isVertical: true,
                  //     value:
                  //     "Shop 7, Alaba international market, Alaba market Lagos.",
                  //   ),
                  // ]),
                  // SectionBox(children: const [
                  //   TransactionDetailSummaryItem(
                  //     title: "Receiver's Name",
                  //     value: "Maloung Doe",
                  //   ),
                  //   TransactionDetailSummaryItem(
                  //     title: "Phone Number",
                  //     value: "08036322653",
                  //   ),
                  //   TransactionDetailSummaryItem(
                  //     title: "Email",
                  //     value: "emekaleingo@gmail.com",
                  //   ),
                  //   TransactionDetailSummaryItem(
                  //     title: "Address",
                  //     isVertical: true,
                  //     value:
                  //     "Shop 7, Alaba international market, Alaba market Lagos.",
                  //   ),
                  // ]),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
