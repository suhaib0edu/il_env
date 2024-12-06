import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:io';

Future<String?> extractTextFromImage(String imagePath) async {
  try {
    final file = File(imagePath);
    Gemini.init(apiKey: 'AIzaSyDDGPyK8kwBGrWXuwUSlqlT2cw8U6XDVPE');
    Candidates? prompt = await Gemini.instance.prompt(parts: [
      Part.text('استخرج النص الموجود في الصورة فقط'),
      Part.uint8List(file.readAsBytesSync())
    ]);
    print(prompt?.output);

    return prompt?.output;
  } catch (e) {
    debugPrint("حدث خطأ: $e");
    return null;
  }
}
