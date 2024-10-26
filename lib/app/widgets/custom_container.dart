import 'package:flutter/material.dart';
import 'package:il_env/app/utils/colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color color;
  final double radius;
  final EdgeInsets padding;
  final EdgeInsets margin;



  const CustomContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.color = AppColors.tertiaryColor,
    this.radius = 24,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color:color,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: child,
    );
  }
}
