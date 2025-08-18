import 'package:gosharpsharp/core/utils/exports.dart';

class PaginationButton extends StatelessWidget {
  final bool isActive;
  final bool isForward;
  final Function onPressed;
  const PaginationButton({super.key, required this.onPressed, this.isActive=true, this.isForward=true});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        if(isActive) {
          onPressed();
        }
      },
      child: Container(
        decoration:  BoxDecoration(
            color: isActive? AppColors.primaryColor:AppColors.obscureTextColor, shape: BoxShape.circle),
        padding: EdgeInsets.all(4.sp),
        margin: EdgeInsets.symmetric(horizontal: 5.sp),
        child: Icon(
          isForward?Icons.arrow_forward_ios_outlined:Icons.arrow_back_ios_new_outlined,
          color: AppColors.whiteColor,
          size: 12.sp,
        ),
      ),
    );
  }
}
