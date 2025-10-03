import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class FeaturedRestaurantBrand extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onPressed;

  const FeaturedRestaurantBrand({
    super.key,
    required this.restaurant,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Restaurant logo
            Container(
              width: 65.sp,
              height: 65.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundColor,
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: restaurant.logo != null && restaurant.logo!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: restaurant.logo!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.backgroundColor,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: customText(
                            restaurant.name.isNotEmpty ? restaurant.name[0].toUpperCase() : "R",
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    : Center(
                        child: customText(
                          restaurant.name.isNotEmpty ? restaurant.name[0].toUpperCase() : "R",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 8.h),
            // Restaurant name
            SizedBox(
              width: 70.w,
              child: customText(
                restaurant.name,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}