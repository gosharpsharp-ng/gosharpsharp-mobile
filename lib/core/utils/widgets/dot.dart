import '../exports.dart';

class Dot extends StatelessWidget {
  final Color color;
  const Dot({super.key, this.color=Colors.black});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 5.sp,
      width: 5.sp,
      decoration: BoxDecoration(color: color,shape: BoxShape.circle),
    );
  }
}
