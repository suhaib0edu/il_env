import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsets? textPadding;
  final double? fontSize;

  const CustomTextButton({super.key, required this.text, this.onPressed, this.textPadding, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: textPadding?? const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          text,
          style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: fontSize?? 16),
        ),
      ),
    );
  }
}
