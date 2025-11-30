import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  String selectedCategory = 'All';
  late final DashboardController dashboardController;
  late final CartController cartController;

  @override
  void initState() {
    super.initState();
    dashboardController = Get.find<DashboardController>();
    cartController = Get.find<CartController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dashboardController.selectedRestaurant != null) {
        dashboardController.fetchRestaurantMenus(
          dashboardController.selectedRestaurant!.id.toString(),
        );
        dashboardController.fetchMenuCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return GetBuilder<CartController>(
          builder: (cartController) {
            final restaurant = dashboardController.selectedRestaurant;

            if (restaurant == null) {
              return Scaffold(
                appBar: AppBar(title: const Text("Restaurant Details")),
                body: Center(
                  child: customText(
                    "No restaurant selected",
                    fontSize: 16.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ),
              );
            }

            return Scaffold(
              backgroundColor: AppColors.whiteColor,
              body: Column(
                children: [
                  _RestaurantHeader(
                    restaurant: restaurant,
                    dashboardController: dashboardController,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: 35.h),
                  Expanded(
                    child: _RestaurantBody(
                      restaurant: restaurant,
                      dashboardController: dashboardController,
                      cartController: cartController,
                      selectedCategory: selectedCategory,
                      onCategoryChanged: (category) {
                        setState(() => selectedCategory = category);
                      },
                      onRefresh: () => _refreshRestaurantDetails(dashboardController),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _refreshRestaurantDetails(DashboardController controller) async {
    final restaurant = controller.selectedRestaurant;
    if (restaurant != null) {
      await controller.refreshRestaurantDetails(restaurant.id.toString());
    }
  }
}

class _RestaurantHeader extends StatelessWidget {
  final RestaurantModel restaurant;
  final DashboardController dashboardController;
  final VoidCallback onBack;

  const _RestaurantHeader({
    required this.restaurant,
    required this.dashboardController,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180.h,
          width: 1.sw,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _getHeaderImage(),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildOverlay(),
              _buildTopBar(context),
              _buildLogo(),
            ],
          ),
        ),
      ],
    );
  }

  ImageProvider _getHeaderImage() {
    if (restaurant.bannerUrl != null && restaurant.bannerUrl!.isNotEmpty) {
      return NetworkImage(restaurant.bannerUrl!);
    }
    if (restaurant.logoUrl != null && restaurant.logoUrl!.isNotEmpty) {
      return NetworkImage(restaurant.logoUrl!);
    }
    if (restaurant.banner != null && restaurant.banner!.isNotEmpty) {
      return NetworkImage(restaurant.banner!);
    }
    if (restaurant.logo != null && restaurant.logo!.isNotEmpty) {
      return NetworkImage(restaurant.logo!);
    }
    return const AssetImage('assets/images/default_restaurant_banner.png');
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.6),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 50.h,
      left: 20.w,
      right: 20.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios,
            onTap: onBack,
          ),
          _CircleIconButton(
            icon: dashboardController.isFavorite(restaurant.id)
                ? Icons.favorite
                : Icons.favorite_border,
            iconColor: dashboardController.isFavorite(restaurant.id)
                ? Colors.red
                : AppColors.whiteColor,
            onTap: () => _toggleFavorite(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Positioned(
      top: 130.h,
      left: 20.w,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.whiteColor, width: 4.w),
        ),
        child: CircleAvatar(
          radius: 40.r,
          backgroundColor: AppColors.primaryColor,
          backgroundImage: _getLogoImage(),
          child: _shouldShowInitial()
              ? Text(
                  restaurant.name.isNotEmpty
                      ? restaurant.name[0].toUpperCase()
                      : "R",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  ImageProvider? _getLogoImage() {
    if (restaurant.logoUrl != null && restaurant.logoUrl!.isNotEmpty) {
      return NetworkImage(restaurant.logoUrl!);
    }
    if (restaurant.logo != null && restaurant.logo!.isNotEmpty) {
      return NetworkImage(restaurant.logo!);
    }
    return null;
  }

  bool _shouldShowInitial() {
    return (restaurant.logoUrl == null || restaurant.logoUrl!.isEmpty) &&
        (restaurant.logo == null || restaurant.logo!.isEmpty);
  }

  void _toggleFavorite(BuildContext context) async {
    try {
      await dashboardController.toggleFavorite(restaurant, context);
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }
}

class _RestaurantBody extends StatelessWidget {
  final RestaurantModel restaurant;
  final DashboardController dashboardController;
  final CartController cartController;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final Future<void> Function() onRefresh;

  const _RestaurantBody({
    required this.restaurant,
    required this.dashboardController,
    required this.cartController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (restaurant.description != null &&
                  restaurant.description!.isNotEmpty) ...[
                _RestaurantInfo(restaurant: restaurant),
                SizedBox(height: 10.h),
              ],
              _OpeningHoursRow(restaurant: restaurant),
              SizedBox(height: 30.h),
              _CategoryTabs(
                categories: dashboardController.menuCategories,
                selectedCategory: selectedCategory,
                onCategoryChanged: onCategoryChanged,
              ),
              SizedBox(height: 20.h),
              _MenuHeader(
                selectedCategory: selectedCategory,
                isLoading: dashboardController.isLoadingMenus,
              ),
              SizedBox(height: 15.h),
              _MenuItemsList(
                dashboardController: dashboardController,
                selectedCategory: selectedCategory,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantInfo extends StatelessWidget {
  final RestaurantModel restaurant;

  const _RestaurantInfo({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            restaurant.name.capitalizeFirst ?? restaurant.name,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 4.h),
          if (restaurant.cuisineType != null)
            customText(
              restaurant.cuisineType!.capitalizeFirst ?? restaurant.cuisineType!,
              fontSize: 16.sp,
              color: AppColors.obscureTextColor,
            ),
          customText(
            restaurant.description!.capitalizeFirst ?? restaurant.description!,
            fontSize: 16.sp,
            color: AppColors.obscureTextColor,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _OpeningHoursRow extends StatelessWidget {
  final RestaurantModel restaurant;

  const _OpeningHoursRow({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          customText(
            "Opening hours:",
            fontSize: 14.sp,
            color: AppColors.obscureTextColor,
          ),
          SizedBox(width: 8.w),
          customText(
            getOpeningHours(restaurant),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final List<dynamic> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const _CategoryTabs({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            _CategoryTab(
              title: "All",
              isSelected: selectedCategory == "All",
              onTap: () => onCategoryChanged("All"),
            ),
            ...categories.map(
              (category) => _CategoryTab(
                title: category.name,
                isSelected: selectedCategory == category.name,
                onTap: () => onCategoryChanged(category.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 15.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.obscureTextColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            customText(
              title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.whiteColor : AppColors.obscureTextColor,
            ),
            if (isSelected && title != 'All') ...[
              SizedBox(width: 8.w),
              Icon(Icons.close, size: 16.sp, color: AppColors.whiteColor),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  final String selectedCategory;
  final bool isLoading;

  const _MenuHeader({
    required this.selectedCategory,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            "Menu Items ${selectedCategory != 'All' ? '($selectedCategory)' : ''}",
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.obscureTextColor,
          ),
          if (isLoading)
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.refresh,
                size: 12.sp,
                color: AppColors.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _MenuItemsList extends StatelessWidget {
  final DashboardController dashboardController;
  final String selectedCategory;

  const _MenuItemsList({
    required this.dashboardController,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (dashboardController.isLoadingMenus) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        child: SkeletonLoaders.menuItem(count: 8),
      );
    }

    final filteredItems = _getFilteredMenuItems();
    if (filteredItems.isEmpty) {
      return const _EmptyMenuState();
    }

    return Column(
      children: filteredItems
          .map((menuItem) => _MenuItemCard(
                menuItem: menuItem,
                dashboardController: dashboardController,
              ))
          .toList(),
    );
  }

  List<MenuItemModel> _getFilteredMenuItems() {
    final restaurant = dashboardController.selectedRestaurant;
    if (restaurant == null) return [];

    return dashboardController.getFilteredMenuItemsForRestaurant(
      restaurant.id.toString(),
      selectedCategory,
    );
  }
}

class _EmptyMenuState extends StatelessWidget {
  const _EmptyMenuState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 60.sp,
            color: AppColors.obscureTextColor.withValues(alpha: 0.5),
          ),
          SizedBox(height: 15.h),
          customText(
            "No Menu Items Available",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          customText(
            "This restaurant hasn't added any menu items yet",
            fontSize: 14.sp,
            color: AppColors.obscureTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItemModel menuItem;
  final DashboardController dashboardController;

  const _MenuItemCard({
    required this.menuItem,
    required this.dashboardController,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = dashboardController.isMenuItemAvailable(menuItem);

    return InkWell(
      onTap: () => dashboardController.navigateToFoodDetail(menuItem),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border(
            bottom: BorderSide(color: AppColors.obscureTextColor, width: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MenuItemImage(menuItem: menuItem),
            SizedBox(width: 15.w),
            Expanded(
              flex: 5,
              child: _MenuItemDetails(
                menuItem: menuItem,
                isAvailable: isAvailable,
                dashboardController: dashboardController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemImage extends StatelessWidget {
  final MenuItemModel menuItem;

  const _MenuItemImage({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.backgroundColor,
            image: menuItem.files.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(menuItem.files[0].url),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: menuItem.files.isEmpty
              ? Icon(
                  Icons.restaurant,
                  color: AppColors.obscureTextColor,
                  size: 30.sp,
                )
              : null,
        ),
        if (menuItem.discountBadgeText != null)
          Positioned(
            bottom: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.redColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: customText(
                menuItem.discountBadgeText!,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _MenuItemDetails extends StatelessWidget {
  final MenuItemModel menuItem;
  final bool isAvailable;
  final DashboardController dashboardController;

  const _MenuItemDetails({
    required this.menuItem,
    required this.isAvailable,
    required this.dashboardController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          menuItem.name.capitalizeFirst ?? menuItem.name,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
        SizedBox(height: 4.h),
        if (menuItem.description != null && menuItem.description!.isNotEmpty)
          customText(
            menuItem.description!.capitalizeFirst ?? menuItem.description!,
            fontSize: 14.sp,
            color: AppColors.blackColor,
            overflow: TextOverflow.visible,
            maxLines: 2,
          ),
        SizedBox(height: 8.h),
        customText(
          formatToCurrency(menuItem.price),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
        SizedBox(height: 8.h),
        _MenuItemBadges(menuItem: menuItem),
        if (!isAvailable) ...[
          SizedBox(height: 4.h),
          customText(
            dashboardController.getMenuItemAvailabilityStatus(menuItem),
            fontSize: 13.sp,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ],
      ],
    );
  }
}

class _MenuItemBadges extends StatelessWidget {
  final MenuItemModel menuItem;

  const _MenuItemBadges({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 6.h,
      children: [
        if (menuItem.plateSize != null && menuItem.plateSize!.isNotEmpty)
          _InfoBadge(
            icon: Icons.restaurant_menu,
            label: menuItem.plateSize!,
          ),
        _InfoBadge(
          icon: Icons.access_time,
          label: "${menuItem.prepTimeMinutes} mins",
        ),
      ],
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withAlpha(20),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: AppColors.greyColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.blackColor, size: 14.sp),
          SizedBox(width: 4.w),
          customText(
            label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
