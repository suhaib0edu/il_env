import 'dart:typed_data';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:il_env/index.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> extractTextFromImage(XFile? imagePath) async {
  try {
    Uint8List? imageBytes = await imagePath?.readAsBytes();
    if (imageBytes == null) {
      return null;
    }
    final agent = Agent();
    
    final apiKey = await agent.getAPI(await agent.getSelectedModel());
    debugPrint('weit ...');
    Gemini.init(apiKey: apiKey);
    Candidates? prompt = await Gemini.instance.prompt(parts: [
      Part.text('وظيفتك هي استخراج النصوص من الصور'),
      Part.uint8List(imageBytes)
    ]);
    return prompt?.output;
  } catch (e) {
    debugPrint("حدث خطأ: $e");
    return null;
  }
}
