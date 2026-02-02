import 'dart:math' as math;
import '../../../core/utils/exports.dart';
import '../../../core/services/recently_visited_restaurants_service.dart';
import '../../../core/models/restaurant_model.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.whiteColor,
      appBar: flatEmptyAppBar(
        topColor: AppColors.transparent,
        navigationColor: AppColors.whiteColor,
      ),
      body: Container(
        height: 1.sh,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 70.h),
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PngAssets.lightWatermark),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LocationDisplayWidget(
                textColor: AppColors.blackColor,
                iconColor: AppColors.blackColor,
                fontSize: 14,
              ),
              SizedBox(height: 24.h),
              customText(
                "Order food, send parcels, let's do it Sharp Sharp!",
                fontWeight: FontWeight.w500,
                fontSize: 24.sp,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: 1.sw,
                height: 1.sh * 0.50,
                child: const CircularMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularMenu extends StatefulWidget {
  const CircularMenu({super.key});

  @override
  State<CircularMenu> createState() => _CircularMenuState();
}

class _CircularMenuState extends State<CircularMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  double _currentRotation = 0.0;
  double _rotationVelocity = 0.0;
  bool _isUserInteracting = false;

  final _recentRestaurantsService = RecentlyVisitedRestaurantsService();

  MenuItem get _centerItem => MenuItem(
        title: "Food",
        icon: PngAssets.food,
        color: AppColors.secondaryColor,
        onTap: () {
          final controller = Get.find<AppNavigationController>();
          controller.toggleToRestaurantView();
        },
      );

  List<MenuItem> get _menuItems {
    final items = <MenuItem>[];

    // Add recent restaurants (max 2)
    for (var restaurant in _recentRestaurantsService.getRecentRestaurants()) {
      items.add(MenuItem(
        title: _truncateName(restaurant['name'] ?? 'Restaurant'),
        icon: PngAssets.food,
        color: AppColors.secondaryColor,
        isRecent: true,
        restaurantId: restaurant['id'],
        restaurantBanner: restaurant['banner'],
        onTap: () => _navigateToRecentRestaurant(restaurant['id']),
      ));
    }

    // Add static menu items
    items.addAll([
      MenuItem(
        title: "Parcel\nDelivery",
        icon: PngAssets.rider,
        color: AppColors.primaryColor,
        onTap: _handleParcelDeliveryTap,
      ),
      MenuItem(
        title: "Pharmacy &\nBeauty",
        icon: PngAssets.pharmacy,
        color: AppColors.primaryColor,
        isAvailable: false,
      ),
      MenuItem(
        title: "Groceries",
        icon: PngAssets.grocery,
        color: AppColors.primaryColor,
        isAvailable: false,
      ),
      MenuItem(
        title: "Shopping",
        icon: PngAssets.shopping,
        color: AppColors.secondaryColor,
        isAvailable: false,
      ),
    ]);

    return items;
  }

  void _handleParcelDeliveryTap() {
    // Clear fields if controller exists, otherwise it will be created by the binding
    if (Get.isRegistered<DeliveriesController>()) {
      Get.find<DeliveriesController>().clearFields();
    }
    Get.toNamed(Routes.INITIATE_DELIVERY_SCREEN);
  }

  String _truncateName(String name) {
    if (name.length <= 12) return name;
    final words = name.split(' ');
    if (words.length > 1 && words[0].length <= 10) {
      return '${words[0]}\n${words[1].substring(0, math.min(10, words[1].length))}...';
    }
    return '${name.substring(0, 10)}...';
  }

  Future<void> _navigateToRecentRestaurant(int restaurantId) async {
    try {
      final dashboardController = Get.find<DashboardController>();
      RestaurantModel? restaurant;

      try {
        restaurant = dashboardController.restaurants.firstWhere(
          (r) => r.id == restaurantId,
        );
      } catch (e) {
        restaurant = null;
      }

      restaurant ??= await dashboardController.getRestaurantById(restaurantId);

      if (restaurant != null) {
        dashboardController.setSelectedRestaurant(restaurant);
        Get.toNamed(Routes.RESTAURANT_DETAILS_SCREEN);
      } else {
        showToast(message: 'Restaurant not found', isError: true);
      }
    } catch (e) {
      debugPrint('Error navigating to recent restaurant: $e');
      showToast(message: 'Unable to load restaurant', isError: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() => _isUserInteracting = true);
    _rotationController.stop();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final centerX = screenWidth < 600 ? 205.w : 235.w;
    final center = Offset(centerX, 250.h);
    final angle = math.atan2(
      details.localPosition.dy - center.dy,
      details.localPosition.dx - center.dx,
    );
    setState(() {
      _currentRotation = angle;
      _rotationVelocity = details.delta.dx + details.delta.dy;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() => _isUserInteracting = false);

    if (_rotationVelocity.abs() > 2.0) {
      final momentumRotation = _rotationVelocity / 10;
      Future.delayed(Duration.zero, () {
        setState(() => _currentRotation += momentumRotation);
      });
    }
    _rotationVelocity = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final angleStep = (2 * math.pi) / _menuItems.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final radius = screenWidth < 600 ? 130.0 : 160.0;

    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(_menuItems.length, (index) {
            final angle = (index * angleStep) + _currentRotation - (math.pi / 2);
            final x = radius * math.cos(angle);
            final y = radius * math.sin(angle);

            return Transform.translate(
              offset: Offset(x, y),
              child: MenuItemWidget(
                item: _menuItems[index],
                isInteracting: _isUserInteracting,
              ),
            );
          }),
          MenuItemWidget(
            item: _centerItem,
            isInteracting: false,
            isCenter: true,
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String icon;
  final Color color;
  final bool isAvailable;
  final VoidCallback? onTap;
  final bool isRecent;
  final int? restaurantId;
  final String? restaurantBanner;

  MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    this.isAvailable = true,
    this.isRecent = false,
    this.restaurantId,
    this.restaurantBanner,
  });
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final bool isInteracting;
  final bool isCenter;

  const MenuItemWidget({
    super.key,
    required this.item,
    this.isInteracting = false,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isCenter ? 130.0 : 110.0;
    final iconSize = isCenter ? 50.0 : 32.0;

    return GestureDetector(
      onTap: item.onTap,
      child: AnimatedScale(
        scale: isInteracting ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: CustomPaint(
          size: Size(size.w, size.h),
          painter: AmoebicShapePainter(
            gradient: _buildGradient(),
            shadowColor: _buildShadowColor(),
            borderColor: Colors.white.withValues(alpha: 0.3),
            isCenter: isCenter,
          ),
          child: SizedBox(
            width: size.w,
            height: size.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(iconSize),
                _buildTitle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _buildGradient() {
    if (item.isAvailable) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [item.color, item.color.withValues(alpha: 0.8)],
      );
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.grey.shade300, Colors.grey.shade400],
    );
  }

  Color _buildShadowColor() {
    return item.isAvailable
        ? item.color.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.1);
  }

  Widget _buildIcon(double iconSize) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: item.isRecent && item.restaurantBanner != null
          ? _buildRecentRestaurantImage(iconSize)
          : _buildDefaultIcon(iconSize),
    );
  }

  Widget _buildRecentRestaurantImage(double iconSize) {
    return ClipOval(
      child: Image.network(
        item.restaurantBanner!,
        height: iconSize.h,
        width: iconSize.w,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildDefaultIcon(iconSize),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: iconSize.h,
            width: iconSize.w,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultIcon(double iconSize) {
    return Image.asset(
      item.icon,
      height: iconSize.h,
      width: iconSize.w,
      color: item.isAvailable ? null : Colors.grey.shade600,
    );
  }

  Widget _buildTitle() {
    return customText(
      item.title,
      textAlign: TextAlign.center,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
      color: _getTitleColor(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Color _getTitleColor() {
    if (!item.isAvailable) return Colors.grey.shade600;
    return item.color == AppColors.primaryColor
        ? AppColors.whiteColor
        : AppColors.blackColor;
  }
}

class AmoebicShapePainter extends CustomPainter {
  final Gradient gradient;
  final Color shadowColor;
  final Color borderColor;
  final bool isCenter;

  AmoebicShapePainter({
    required this.gradient,
    required this.shadowColor,
    required this.borderColor,
    this.isCenter = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2;
    const int points = 36;

    final offsets = _generateOffsets(points);
    final shapePath = _createShapePath(center, baseRadius, points, offsets);

    // Draw shadow
    canvas.drawShadow(shapePath, shadowColor, 15, true);
    canvas.drawShadow(shapePath, Colors.black.withValues(alpha: 0.1), 8, true);

    // Fill with gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(shapePath, gradientPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(shapePath, borderPaint);

    // Add inner glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withValues(alpha: 0.2), Colors.transparent],
        center: Alignment.topLeft,
        radius: 1.5,
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(shapePath, glowPaint);
  }

  List<double> _generateOffsets(int points) {
    return List.generate(points, (i) {
      final variation = (math.sin(i * 0.5) * 0.08) +
          (math.sin(i * 0.3) * 0.05) +
          (math.sin(i * 0.7) * 0.03);
      return 1.0 + variation;
    });
  }

  Path _createShapePath(
    Offset center,
    double baseRadius,
    int points,
    List<double> offsets,
  ) {
    final path = Path();

    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;
      final radiusOffset = offsets[i % points];
      final radius = baseRadius * radiusOffset * 0.92;

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevAngle = ((i - 1) / points) * 2 * math.pi;
        final prevRadiusOffset = offsets[(i - 1) % points];
        final prevRadius = baseRadius * prevRadiusOffset * 0.92;
        final prevX = center.dx + prevRadius * math.cos(prevAngle);
        final prevY = center.dy + prevRadius * math.sin(prevAngle);

        final controlX = (prevX + x) / 2;
        final controlY = (prevY + y) / 2;

        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant AmoebicShapePainter oldDelegate) {
    return gradient != oldDelegate.gradient ||
        shadowColor != oldDelegate.shadowColor ||
        borderColor != oldDelegate.borderColor;
  }
}