import 'package:flutter/services.dart';
import 'package:il_env/index.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.suffixIcon,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 8,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.tertiaryColor),
        ),
        filled: true,
        fillColor: AppColors.tertiaryColor,
        suffixIcon: suffixIcon ?? _buildPasteButton(context),
      ),
    );
  }

  Widget _buildPasteButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.paste_rounded),
      onPressed: () async {
        final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
        if (clipboardData?.text != null && controller != null) {
          controller?.text = clipboardData!.text!;
        }
      },
    );
  }
}
