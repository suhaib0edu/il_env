import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomTextButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          text,
          style: TextStyle(color: Colors.black.withOpacity(0.5)),
        ),
      ),
    );
  }
}
