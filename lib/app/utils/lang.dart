import 'package:get/get.dart';

class TranslationsService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'keyHelpText': 'How can I help you today?',
          'keyQuestionHint': 'Do you have a question or inquiry?',
          'keyStudyLessons': 'Study Lessons',
          'keyUpdateSettings': 'Update Settings',
          'keySettings': 'Settings',
          'keySuccess': 'Success',
          'keySettingsSavedSuccessfully': 'Settings saved successfully',
        },
        'ar_SA': {
          'keyHelpText': 'كيف يمكنني مساعدتك اليوم؟',
          'keyQuestionHint': 'هل لديك سؤل او استفسار؟',
          'keyStudyLessons': 'مذاكرة الدروس',
          'keyUpdateSettings': 'تحديث الإعدادات',
          'keySettings': 'الإعدادات',
          'keySuccess': 'نجاح',
          'keySettingsSavedSuccessfully': 'تم حفظ الإعدادات بنجاح',
        },
      };
}

enum TranslationKey {
  keyHelpText,
  keyQuestionHint,
  keyStudyLessons,
  keyUpdateSettings,
  keySettings,
  keySuccess,
  keySettingsSavedSuccessfully,
}

String translateKeyTr(TranslationKey key) {
  return key.name.tr;
}
