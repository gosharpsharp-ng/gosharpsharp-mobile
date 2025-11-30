import 'package:gosharpsharp/core/utils/exports.dart';

class OrderDetailMenuItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final int quantity;
  final String price;
  final String? description;
  final String? plateSize;

  const OrderDetailMenuItem({
    super.key,
    required this.name,
    this.imageUrl,
    required this.quantity,
    required this.price,
    this.description,
    this.plateSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.greyColor.withAlpha(25),
            ),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Icon(
                          Icons.fastfood,
                          color: AppColors.greyColor,
                          size: 24.sp,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.fastfood,
                    color: AppColors.greyColor,
                    size: 24.sp,
                  ),
          ),

          SizedBox(width: 12.w),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  name.capitalizeFirst ?? name,
                  fontSize: 14.sp,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                ),
                if (description != null && description!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  customText(
                    description!.capitalizeFirst ?? description!,
                    fontSize: 12.sp,
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.normal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4.h),
                // Price moved under description
                customText(
                  price,
                  fontSize: 14.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    customText(
                      'Qty: $quantity',
                      fontSize: 12.sp,
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.normal,
                    ),
                    if (plateSize != null && plateSize!.isNotEmpty) ...[
                      customText(
                        ' • ',
                        fontSize: 12.sp,
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.normal,
                      ),
                      customText(
                        'Size: $plateSize',
                        fontSize: 12.sp,
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
