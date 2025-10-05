import 'dart:math' as math;

import '../../../core/utils/exports.dart';
// TODO: When the user clicks on an item in the list, it should hide the landing screen and show the selected screen; say dashboard screen
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark, // For light status bar text
      ),
      body: Container(
        height: 1.sh,
        padding: EdgeInsets.symmetric(horizontal:15.w,vertical: 70.h),
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(PngAssets.lightWatermark,),fit: BoxFit.cover
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customText("What do you want to get Sharp Sharp?",fontWeight: FontWeight.w500,fontSize: 24.sp,overflow: TextOverflow.visible),
              // SizedBox(height: 15.h,),
              // customText("Let's know what you want to do today?",fontWeight: FontWeight.w500,fontSize: 18.sp,),
              //
              SizedBox(height: 45.h,),
              Center(
                child: Container(
                  width: 450.w,
                  height: 500.h,
                  child: CircularMenu(),
                ),
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

class _CircularMenuState extends State<CircularMenu> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  double _currentRotation = 0.0;
  double _lastRotation = 0.0;
  double _rotationVelocity = 0.0;
  bool _isUserInteracting = false;
  bool _hasUserInteracted = false;

  // Food delivery item for center
  MenuItem get centerItem => MenuItem(
    title: "Food",
    icon: PngAssets.food,
    color: AppColors.secondaryColor,
    onTap: () {
      // Toggle to show restaurant dashboard
      final controller = Get.find<AppNavigationController>();
      controller.toggleToRestaurantView();
    },
  );

  // Surrounding menu items (excluding food delivery)
  List<MenuItem> get menuItems => [
   MenuItem(
      title: "Parcel\nDelivery",
      icon: PngAssets.rider,
      color: AppColors.primaryColor,
      onTap: () {
        // Navigate to parcel delivery flow
        Get.toNamed(Routes.INITIATE_DELIVERY_SCREEN);
      },
    ),
    MenuItem(
      title: "Pharmacy &\nBeauty",
      icon: PngAssets.pharmacy,
      color: AppColors.primaryColor,
      isAvailable: false
    ),
    MenuItem(
      title: "Groceries",
      icon: PngAssets.grocery,
      color: AppColors.primaryColor,
      isAvailable: false
    ),
    MenuItem(
      title: "Shopping",
      icon: PngAssets.shopping,
      color: AppColors.secondaryColor,
      isAvailable: false
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for auto-rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Slower, more elegant rotation
    )..addListener(() {
      if (!_isUserInteracting) {
        setState(() {
          _currentRotation = _rotationController.value * 2 * math.pi;
        });
      }
    });

    // Start initial rotation
    _rotationController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isUserInteracting = true;
      _hasUserInteracted = true;
      _lastRotation = _currentRotation;
    });

    // Stop any ongoing animation
    _rotationController.stop();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    // Calculate rotation based on drag delta
    final center = Offset(225.w, 250.h); // Approximate center of the circular menu
    final angle = math.atan2(
      details.localPosition.dy - center.dy,
      details.localPosition.dx - center.dx,
    );

    setState(() {
      _currentRotation = angle;
      _rotationVelocity = details.delta.dx + details.delta.dy; // Combined velocity
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _isUserInteracting = false;
    });

    // Apply momentum effect based on drag velocity
    final velocity = _rotationVelocity.abs();
    if (velocity > 2.0) {
      // Create momentum animation
      final double momentumRotation = _rotationVelocity / 10;

      // Gradually slow down
      Future.delayed(Duration.zero, () {
        setState(() {
          _currentRotation += momentumRotation;
        });

        // Start 5-second auto-rotation after momentum
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _rotationController.reset();
            _rotationController.forward();
          }
        });
      });
    } else {
      // Start 5-second auto-rotation immediately
      if (mounted) {
        _rotationController.reset();
        _rotationController.forward();
      }
    }

    _rotationVelocity = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate angle step based on number of items
    final angleStep = (2 * math.pi) / menuItems.length;
    final radius = 130.0; // Orbit radius

    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Surrounding orbital menu items
          ...List.generate(menuItems.length, (index) {
            final angle = (index * angleStep) + _currentRotation - (math.pi / 2);
            final x = radius * math.cos(angle);
            final y = radius * math.sin(angle);

            return Transform.translate(
              offset: Offset(x, y),
              child: MenuItemWidget(
                item: menuItems[index],
                isInteracting: _isUserInteracting,
              ),
            );
          }),

          // Center food delivery item (fixed, doesn't rotate)
          MenuItemWidget(
            item: centerItem,
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

  MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    this.isAvailable = true
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
    // Center sun is 15% bigger (138px), planets are 15% smaller (102px)
    final size = isCenter ? 138.0 : 115.0;
    final iconSize = isCenter ? 52.0 : 38.0;

    return GestureDetector(
      onTap: item.onTap,
      child: AnimatedScale(
        scale: isInteracting ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: size.w,
          height: size.h,
          decoration: BoxDecoration(
            gradient: item.isAvailable
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color,
                      item.color.withOpacity(0.8),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade400,
                    ],
                  ),
            borderRadius: BorderRadius.circular(60.r),
            boxShadow: item.isAvailable
                ? [
                    BoxShadow(
                      color: item.color.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle inner glow effect
              if (item.isAvailable)
                Container(
                  margin: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(56.r),
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      center: Alignment.topLeft,
                      radius: 1.5,
                    ),
                  ),
                ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with subtle shadow
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      item.icon,
                      height: iconSize.h,
                      width: iconSize.w,
                      color: item.isAvailable ? null : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  customText(
                    item.title,
                    textAlign: TextAlign.center,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: item.isAvailable
                        ? (item.color == AppColors.primaryColor
                            ? AppColors.whiteColor
                            : AppColors.blackColor)
                        : Colors.grey.shade600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              // Coming Soon overlay with dotted border
              if (!item.isAvailable)
                CustomPaint(
                  size: Size(120.w, 120.h),
                  painter: DottedCircleBorder(
                    color: Colors.white.withOpacity(0.6),
                    strokeWidth: 3,
                    gap: 8,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for dotted circle border
class DottedCircleBorder extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DottedCircleBorder({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (gap + strokeWidth)).floor();
    final angleStep = (2 * math.pi) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * angleStep;
      final endAngle = startAngle + (strokeWidth / radius);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}