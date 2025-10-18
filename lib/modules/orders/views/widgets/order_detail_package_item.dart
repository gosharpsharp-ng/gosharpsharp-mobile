import 'package:gosharpsharp/core/utils/exports.dart';

class OrderDetailPackageItem extends StatelessWidget {
  final String packageName;
  final int quantity;
  final String price;

  const OrderDetailPackageItem({
    super.key,
    required this.packageName,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(25),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    packageName,
                    fontSize: 14.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    'Package Quantity: $quantity',
                    fontSize: 12.sp,
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ],
          ),
          customText(
            price,
            fontSize: 14.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
