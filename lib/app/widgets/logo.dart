import 'package:il_env/index.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer( 
    height: 90,
    width: 90,
    child: Image.asset(
      'assets/icons/logo.webp',
      fit: BoxFit.contain, 
    ),
  );
  }
}