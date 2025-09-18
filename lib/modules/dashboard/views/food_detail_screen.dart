import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodName;
  final String price;
  final String foodImage;
  final String description;
  final String preparationTime;
  final double rating;
  final int reviewCount;
  final String distance;
  final int? menuId; // Add menu ID for API calls

  const FoodDetailScreen({
    super.key,
    this.foodName = "Amala and Gbegiri",
    this.price = "₦3,000.00",
    this.foodImage = PngAssets.chow1,
    this.description = "Forem ipsum dolor sit amet, consectetur adip iscing elit. Nunc vulputate libero et velit inter.",
    this.preparationTime = "10mins",
    this.rating = 5.0,
    this.reviewCount = 500,
    this.distance = "1.4 Km",
    this.menuId,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> with TickerProviderStateMixin {
  int quantity = 1;
  late TabController _tabController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    showToast(
      message: isFavorite ? "Added to favorites" : "Removed from favorites",
      isError: false,
    );
  }

  void _addToCartAndShowSuccess(CartController cartController) async {
    await cartController.addToCart(widget.menuId!, quantity);

    // Show success bottom sheet instead of dialog
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            customText(
              "Added to Cart!",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            customText(
              "$quantity x ${widget.foodName} has been added to your cart",
              fontSize: 14.sp,
              color: AppColors.greyColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: customText(
                      "Continue Shopping",
                      fontSize: 14.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Routes.CART_SCREEN);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: customText(
                      "View Cart",
                      fontSize: 14.sp,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  double _calculateTotalPrice() {
    double basePrice = double.tryParse(widget.price.replaceAll(RegExp(r'[₦,]'), '')) ?? 0.0;
    return basePrice * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            children: [
              // Header Image with Back Button and Actions
              Container(
                height: 300.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.foodImage.startsWith('http')
                        ? NetworkImage(widget.foodImage)
                        : AssetImage(widget.foodImage) as ImageProvider,
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                ),
                child: Stack(
                  children: [
                    // Dark gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),

                    // Back button and actions
                    Positioned(
                      top: 50.h,
                      left: 20.w,
                      right: 20.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.blackColor,
                                size: 20.sp,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  // Share functionality
                                  showToast(message: "Share functionality coming soon", isError: false);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.share,
                                    color: AppColors.blackColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: _toggleFavorite,
                                child: Container(
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : AppColors.blackColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Food name overlay at bottom
                    Positioned(
                      bottom: 20.h,
                      left: 20.w,
                      right: 20.w,
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              widget.foodName,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                customText(
                                  "${widget.rating}",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                                customText(
                                  " (${widget.reviewCount} reviews)",
                                  fontSize: 14.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Food Details Card
              Expanded(
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.r),
                      topRight: Radius.circular(0.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // Price and Quick Info
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    widget.price,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                  customText(
                                    "per plate",
                                    fontSize: 12.sp,
                                    color: AppColors.obscureTextColor,
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: AppColors.obscureTextColor,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    customText(
                                      widget.preparationTime,
                                      fontSize: 12.sp,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Tabs (Details / Reviews)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: AppColors.blackColor,
                            unselectedLabelColor: AppColors.obscureTextColor,
                            indicatorColor: AppColors.primaryColor,
                            indicatorWeight: 3,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            tabs: [
                              Tab(text: "Details"),
                              Tab(text: "Reviews"),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Tab Content
                        Container(
                          height: 200.h,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Details Tab
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        "Description",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                      SizedBox(height: 8.h),
                                      customText(
                                        widget.description,
                                        fontSize: 14.sp,
                                        color: AppColors.obscureTextColor,
                                        height: 1.6,
                                      ),
                                      SizedBox(height: 16.h),

                                      // Additional details
                                      _buildDetailRow("Preparation Time", widget.preparationTime),
                                      SizedBox(height: 8.h),
                                      _buildDetailRow("Distance", widget.distance),
                                      SizedBox(height: 8.h),
                                      _buildDetailRow("Rating", "${widget.rating}/5.0"),
                                    ],
                                  ),
                                ),
                              ),

                              // Reviews Tab
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Overall rating
                                      Container(
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                customText(
                                                  "${widget.rating}",
                                                  fontSize: 32.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primaryColor,
                                                ),
                                                Row(
                                                  children: List.generate(5, (index) {
                                                    return Icon(
                                                      index < widget.rating.floor()
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.orange,
                                                      size: 16.sp,
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 16.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  customText(
                                                    "Overall Rating",
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.blackColor,
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  customText(
                                                    "Based on ${widget.reviewCount} reviews",
                                                    fontSize: 12.sp,
                                                    color: AppColors.obscureTextColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 16.h),

                                      // Sample reviews
                                      _buildReviewItem("John D.", 5, "Amazing taste! Will definitely order again.", "2 days ago"),
                                      SizedBox(height: 12.h),
                                      _buildReviewItem("Sarah M.", 4, "Good food but delivery took a bit long.", "1 week ago"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Quantity Selector
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      "Quantity",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    customText(
                                      "Total: ₦${_calculateTotalPrice().toStringAsFixed(2)}",
                                      fontSize: 14.sp,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: _decrementQuantity,
                                      child: Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color: quantity > 1
                                              ? AppColors.whiteColor
                                              : AppColors.greyColor.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(10.r),
                                          border: Border.all(
                                            color: AppColors.greyColor.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: quantity > 1
                                              ? AppColors.blackColor
                                              : AppColors.greyColor,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Container(
                                      width: 50.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: customText(
                                          quantity.toString(),
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    InkWell(
                                      onTap: _incrementQuantity,
                                      child: Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.whiteColor,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // You might also like section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "You might also like",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                height: 120.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return _buildSimilarItem(
                                      ["Rice and Stew", "Jollof Rice", "Fried Rice"][index],
                                      [PngAssets.chow2, PngAssets.chow3, PngAssets.chow1][index],
                                      ["₦2,500", "₦3,200", "₦2,800"][index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 100.h), // Extra padding for bottom button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                width: double.infinity,
                height: 56.h,
                backgroundColor: AppColors.primaryColor,
                title: cartController.isAddingToCart
                    ? "Adding to cart..."
                    : "Add $quantity to cart • ₦${_calculateTotalPrice().toStringAsFixed(2)}",
                onPressed: (){
                  if( cartController.isAddingToCart || widget.menuId == null){
                    log("Nothing....");
                  }else{


                      _addToCartAndShowSuccess(cartController);

                  }
                },
                isBusy: cartController.isAddingToCart,
                borderRadius: 12.r,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontColor: AppColors.whiteColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          fontSize: 14.sp,
          color: AppColors.obscureTextColor,
        ),
        customText(
          value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment, String time) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.primaryColor,
                    child: customText(
                      name[0],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        name,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 12.sp,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              customText(
                time,
                fontSize: 12.sp,
                color: AppColors.obscureTextColor,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          customText(
            comment,
            fontSize: 13.sp,
            color: AppColors.obscureTextColor,
            height: 1.4,
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarItem(String name, String image, String price) {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to similar item detail
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    name,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    price,
                    fontSize: 11.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}