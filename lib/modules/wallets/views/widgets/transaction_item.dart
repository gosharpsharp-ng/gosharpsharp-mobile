import 'package:gosharpsharp/core/utils/exports.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function onTap;
  TransactionItem({super.key, required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            transaction.type.toLowerCase() == "wallet"
                ? SvgPicture.asset(SvgAssets.walletTransactionIcon)
                : SvgPicture.asset(SvgAssets.orderTransactionIcon),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(transaction.paymentReference,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            overflow: TextOverflow.visible),
                        customText(
                          formatTime(transaction.createdAt),
                          color: AppColors.obscureTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          formatDate(transaction.createdAt),
                          color: AppColors.obscureTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                        customText(
                            formatToCurrency(double.parse(transaction.amount)),
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.montserrat().fontFamily!,
                            fontSize: 15.sp,
                            overflow: TextOverflow.visible),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            transaction.type.toLowerCase() == "withdrawal"
                ? SvgPicture.asset(SvgAssets.outflowCircleIcon)
                : SvgPicture.asset(SvgAssets.inflowCircleIcon),
          ],
        ),
      ),
    );
  }
}
