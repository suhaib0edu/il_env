import 'package:il_env/index.dart';

class DiscussionItem extends StatelessWidget {
  final Widget? child;
  final String? text;
  const DiscussionItem({super.key, this.child, this.text});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(16),
      child: child ?? Text(text ?? ''),
    );
  }
}

class LessonKeysItems extends StatelessWidget {
  final String title;
  final String content;
  const LessonKeysItems(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return DiscussionItem(
      child: Column(
        children: [
          CustomContainer(
            radius: 20,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(color: AppColors.tertiaryColor, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomMarkdown(data: content),
            ),
          ),
        ],
      ),
    );
  }
}
