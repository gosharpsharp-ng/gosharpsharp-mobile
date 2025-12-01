import 'package:gosharpsharp/core/utils/exports.dart';

/// Small badge chip widget for displaying restaurant badges
class RestaurantBadgeChip extends StatelessWidget {
  final String badge;

  const RestaurantBadgeChip({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFreeDelivery = _isFreeDeliveryBadge(badge);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: _getBadgeColor(badge),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getBadgeColor(badge).withAlpha(100),
          width: 0.5,
        ),
      ),
      child: customText(
        _formatBadgeName(badge),
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: isFreeDelivery ? AppColors.blackColor : AppColors.whiteColor,
      ),
    );
  }

  /// Check if badge is free delivery
  bool _isFreeDeliveryBadge(String badge) {
    final badgeLower = badge.toLowerCase();
    return badgeLower.contains('free') && badgeLower.contains('delivery');
  }

  /// Get color based on badge type
  Color _getBadgeColor(String badge) {
    final badgeLower = badge.toLowerCase();
    if (badgeLower.contains('free') && badgeLower.contains('delivery')) {
      return AppColors.secondaryColor;
    } else if (badgeLower.contains('best_rated') || badgeLower.contains('top_seller')) {
      return AppColors.primaryColor;
    } else if (badgeLower.contains('new')) {
      return AppColors.greenColor;
    } else if (badgeLower.contains('featured')) {
      return AppColors.amberColor;
    } else if (badgeLower.contains('verified')) {
      return AppColors.blueColor;
    } else {
      return AppColors.greyColor;
    }
  }

  /// Format badge name for display
  String _formatBadgeName(String badge) {
    // Replace underscores with spaces and capitalize words
    return badge
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }
}
