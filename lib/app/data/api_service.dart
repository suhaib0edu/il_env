import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:image_picker/image_picker.dart';

Future<String?> extractTextFromImage(XFile? imagePath) async {
  try {
    Uint8List? imageBytes = await imagePath?.readAsBytes();
    if (imageBytes == null) {
      return null;
    }
    debugPrint('weit ...');
    Gemini.init(apiKey: 'AIzaSyDDGPyK8kwBGrWXuwUSlqlT2cw8U6XDVPE');
    Candidates? prompt = await Gemini.instance.prompt(parts: [
      Part.text('استخرج النص الموجود في الصورة فقط'),
      Part.uint8List(imageBytes)
    ]);
    return prompt?.output;
  } catch (e) {
    debugPrint("حدث خطأ: $e");
    return null; 
  }
}
