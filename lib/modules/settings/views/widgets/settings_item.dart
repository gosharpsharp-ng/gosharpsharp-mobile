import 'package:gosharpsharp/core/utils/exports.dart';

class SettingsItem extends StatelessWidget {
  final String icon;
  final String title;
  final bool isLast;
  final bool isLogout;
  final Function onPressed;
  SettingsItem(
      {super.key,
        this.title = "Edit Profile",
        this.isLogout=false,
        this.isLast=false,
        this.icon = SvgAssets.editIcon,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 5.sp),
        padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),

        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border(
            bottom: BorderSide(
              color: isLast?AppColors.transparent:AppColors.obscureTextColor, // Set the border color
              width: 0.09,        // Set the border thickness
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              icon,
              color: isLogout?AppColors.redColor:AppColors.blackColor,
              height: 22.sp,
              width: 22.sp,
            ),
            SizedBox(
              width: 20.sp,
            ),
            Expanded(
              child: customText(
                title,
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
                color: isLogout?AppColors.redColor:AppColors.blackColor,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.disabledColor,
            )
          ],
        ),
      ),
    );
  }
}

Widget profileSectionTitle({String title = ""}) {
  return Container(
    margin: EdgeInsets.only(top: 22.sp, bottom: 4.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        customText(title,
            color: AppColors.disabledColor, fontWeight: FontWeight.w600),
      ],
    ),
  );
}