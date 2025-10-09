import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gosharpsharp/core/utils/app_colors.dart';
import 'package:gosharpsharp/core/utils/app_assets.dart';

class WormToggleWidget extends StatefulWidget {
  final bool isActive;
  final VoidCallback onToggle;
  final Duration animationDuration;
  final Curve animationCurve;

  const WormToggleWidget({
    super.key,
    required this.isActive,
    required this.onToggle,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOutCubic,
  });

  @override
  State<WormToggleWidget> createState() => _WormToggleWidgetState();
}

class _WormToggleWidgetState extends State<WormToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _stretchAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Position animation: moves from left (0.0) to right (1.0)
    _positionAnimation = Tween<double>(
      begin: widget.isActive ? 1.0 : 0.0,
      end: widget.isActive ? 1.0 : 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );

    // Stretch animation: creates the "worm" effect
    // Stretches to 1.5x size in the middle of the animation
    _stretchAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.6)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.6, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(WormToggleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _animateToggle();
    }
  }

  void _animateToggle() {
    if (widget.isActive) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 1.sp,
          vertical: 5.h,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              children: [
                _buildIconContainer(
                  icon: SvgAssets.bikeIcon,
                  isSelected: !widget.isActive,
                  animationValue: _controller.value,
                  isLeftIcon: true,
                ),
                _buildIconContainer(
                  icon: SvgAssets.walkIcon,
                  isSelected: widget.isActive,
                  animationValue: _controller.value,
                  isLeftIcon: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIconContainer({
    required String icon,
    required bool isSelected,
    required double animationValue,
    required bool isLeftIcon,
  }) {
    // Calculate stretch based on position in animation
    double stretch = 1.0;

    if (isLeftIcon) {
      // Left icon (bike): stretch when animating away (going to walk)
      if (!widget.isActive && animationValue < 0.5) {
        stretch = _stretchAnimation.value;
      }
    } else {
      // Right icon (walk): stretch when animating towards it (going to walk)
      if (widget.isActive && animationValue < 0.5) {
        stretch = _stretchAnimation.value;
      }
    }

    // Calculate scale for smooth size transition
    double scale = isSelected ? 1.0 : 0.85;
    scale = scale + (animationValue * (isLeftIcon ? -0.15 : 0.15));

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..scale(stretch, 1.0) // Horizontal stretch for worm effect
        ..scale(scale), // Overall scale
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondaryColor : AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(5.sp),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      child: SvgPicture.asset(
        icon,
        height: 20.sp,
        width: 20.sp,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.blackColor : AppColors.whiteColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}