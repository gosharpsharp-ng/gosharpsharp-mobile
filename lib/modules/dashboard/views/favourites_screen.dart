// TODO: Build Favourites Screen

import '../../../core/utils/exports.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(centerTitle: true, title: "Favourites"),
      body: GetBuilder<DashboardController>(
        builder: (dashboardController) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              children: [
                ...List.generate(
                  dashboardController.restaurants.length,
                  (i) => RestaurantContainer(
                    restaurant: dashboardController.restaurants[i],
                    onPressed: (){},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
