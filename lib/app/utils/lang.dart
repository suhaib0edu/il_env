import 'package:get/get.dart';

class TranslationsService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'help_text': 'How can I help you today?',
          'question_hint': 'Do you have a question or inquiry?',
          'study_lessons': 'Study Lessons',
        },
        'ar_SA': {
          'help_text': 'كيف يمكنني مساعدتك اليوم؟',
          'question_hint': 'هل لديك سؤل او استفسار؟',
          'study_lessons': 'مذاكرة الدورس',
        },
      };
}
