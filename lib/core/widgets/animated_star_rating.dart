import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gosharpsharp/core/utils/app_colors.dart';
import 'package:gosharpsharp/core/utils/widgets/custom_text.dart';

class AnimatedStarRating extends StatefulWidget {
  final Function(int rating) onRatingSelected;
  final int? initialRating;
  final bool enabled;

  const AnimatedStarRating({
    super.key,
    required this.onRatingSelected,
    this.initialRating,
    this.enabled = true,
  });

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating> {
  int _selectedRating = 0;
  int _hoveredRating = 0;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating ?? 0;
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Bad';
      case 2:
        return 'Poor';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap to rate';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return AppColors.redColor;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return AppColors.primaryColor;
      default:
        return AppColors.greyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayRating = _hoveredRating > 0 ? _hoveredRating : _selectedRating;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            final isSelected = starNumber <= displayRating;

            return GestureDetector(
              onTap: widget.enabled
                  ? () {
                      setState(() {
                        _selectedRating = starNumber;
                        _hoveredRating = 0;
                      });
                      widget.onRatingSelected(starNumber);
                    }
                  : null,
              onTapDown: widget.enabled
                  ? (_) {
                      setState(() {
                        _hoveredRating = starNumber;
                      });
                    }
                  : null,
              onTapUp: widget.enabled
                  ? (_) {
                      setState(() {
                        _hoveredRating = 0;
                      });
                    }
                  : null,
              onTapCancel: widget.enabled
                  ? () {
                      setState(() {
                        _hoveredRating = 0;
                      });
                    }
                  : null,
              child: AnimatedScale(
                scale: _hoveredRating == starNumber ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    isSelected
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 40.sp,
                    color: isSelected
                        ? _getRatingColor(displayRating)
                        : AppColors.greyColor.withAlpha(100),
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 12.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey<int>(displayRating),
            child: customText(
              _getRatingLabel(displayRating),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: displayRating > 0
                  ? _getRatingColor(displayRating)
                  : AppColors.greyColor,
            ),
          ),
        ),
      ],
    );
  }
}
