import 'package:il_env/index.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomContainer(
        radius: 30,
        padding: EdgeInsets.all(6),
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: AssetImage('assets/icons/logo.webp'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
