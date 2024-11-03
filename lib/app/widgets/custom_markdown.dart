import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:il_env/index.dart';

class CustomMarkdown extends StatelessWidget {
  final String data;
  const CustomMarkdown({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      selectable: true,
      data: data,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(color: Colors.black54.withOpacity(0.6), fontSize: 16), // نص عادي
        h1: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold), // عنوان 1
        h2: TextStyle(color: AppColors.primaryColor, fontSize: 22, fontWeight: FontWeight.bold), // عنوان 2
        h3: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold), // عنوان 3
        strong: TextStyle(color:  AppColors.primaryColor, fontWeight: FontWeight.bold), // نص مهم
        em: TextStyle(color: Colors.purple), // نص مائل
        blockquote: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic), // اقتباس
        code: TextStyle(color: Colors.teal, fontFamily: 'monospace'), // كود
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.blue, width: 4)), // تزيين الاقتباس
        ),
        blockquotePadding: EdgeInsets.all(8), // padding للاقتباس
        codeblockDecoration: BoxDecoration(
          color: Colors.black12, // خلفية لكود متعدد الأسطر
          borderRadius: BorderRadius.circular(5),
        ),
        codeblockPadding: EdgeInsets.all(10), // padding لكود متعدد الأسطر
      ),
    );
  }
}