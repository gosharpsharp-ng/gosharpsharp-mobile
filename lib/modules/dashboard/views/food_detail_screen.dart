import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodName;
  final String price;
  final String foodImage;
  final String description;
  final String preparationTime;
  final double rating;
  final int reviewCount;
  final String distance;

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
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> with TickerProviderStateMixin {
  int quantity = 1;
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header Image with Back Button and Menu
          Container(
            height: 300.h,
            width: 1.sw,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.foodImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Back button and menu
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
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.blackColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_vert,
                            color: AppColors.blackColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
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
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),

                    // Food Name and Actions
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: customText(
                              widget.foodName,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Price and Details Row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // Price
                                customText(
                                  widget.price,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                                customText(
                                  " / plate",
                                  fontSize: 14.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                                Spacer(),
                            
                            
                            
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.share,
                                  size: 24.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                              ),
                              SizedBox(width: 15.w),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 24.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.w,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.obscureTextColor,
                                size: 18.sp,
                              ),
                              SizedBox(width: 3.w),
                              customText(
                                "30 min",
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                          // Rating
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18.sp,
                              ),
                              SizedBox(width: 3.w),
                              customText(
                                "${widget.rating}",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor,
                              ),
                              customText(
                                " (${widget.reviewCount})",
                                fontSize: 14.sp,
                                color: AppColors.obscureTextColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Swallow Tag
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: customText(
                          "Swallow",
                          fontSize: 12.sp,
                          color: AppColors.obscureTextColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // Tabs (Details / Reviews)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.blackColor,
                        unselectedLabelColor: AppColors.obscureTextColor,
                        indicatorColor: AppColors.primaryColor,
                        indicatorWeight: 3,
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

                    SizedBox(height: 25.h),

                    // Tab Content
                    Container(
                      height: 100.h,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Details Tab
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  widget.description,
                                  fontSize: 14.sp,
                                  color: AppColors.obscureTextColor,
                                  height: 1.5,
                                ),
                                SizedBox(height: 20.h),
                                customText(
                                  "Preparation time:",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                                SizedBox(height: 5.h),
                                customText(
                                  widget.preparationTime,
                                  fontSize: 14.sp,
                                  color: AppColors.blackColor,
                                ),
                              ],
                            ),
                          ),

                          // Reviews Tab
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                customText(
                                  "Reviews will be displayed here",
                                  fontSize: 14.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // Quantity Selector
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            "Quantity",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: _decrementQuantity,
                                child: Container(
                                  width: 35.w,
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: AppColors.blackColor,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              customText(
                                quantity.toString(),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(width: 15.w),
                              InkWell(
                                onTap: _incrementQuantity,
                                child: Container(
                                  width: 35.w,
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.blackColor,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // Add to Cart Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        width: 1.sw,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add to cart functionality
                            Get.snackbar(
                              "Success",
                              "$quantity ${widget.foodName} added to cart",
                              backgroundColor: AppColors.primaryColor,
                              colorText: AppColors.whiteColor,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: customText(
                            "Add to cart",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // You might also like section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            "You might also like",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                          InkWell(
                            onTap: () {},
                            child: customText(
                              "See all",
                              fontSize: 14.sp,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Similar Items
                    Container(
                      height: 120.h,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            _buildSimilarItem("Rice and Stew", PngAssets.chow2),
                            _buildSimilarItem("Jollof Rice", PngAssets.chow3),
                            _buildSimilarItem("Fried Rice", PngAssets.chow1),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarItem(String name, String image) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(right: 15.w),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          customText(
            name,
            fontSize: 12.sp,
            color: AppColors.blackColor,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}