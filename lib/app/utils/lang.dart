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
          'keyError': 'Error',
          'keyCheckConnection': 'Please check your internet connection and try again.',
          'keyApiKeyError': 'We could not connect to the model. Make sure to add your API key correctly or switch to a different provider.',
        },
        'ar_SA': {
          'keyHelpText': 'كيف يمكنني مساعدتك اليوم؟',
          'keyQuestionHint': 'هل لديك سؤال أو استفسار؟',
          'keyStudyLessons': 'مذاكرة الدروس',
          'keyUpdateSettings': 'تحديث الإعدادات',
          'keySettings': 'الإعدادات',
          'keySuccess': 'نجاح',
          'keySettingsSavedSuccessfully': 'تم حفظ الإعدادات بنجاح',
          'keyError': 'خطأ',
          'keyCheckConnection': 'يرجى التحقق من الاتصال بالإنترنت والمحاولة مرة أخرى.',
          'keyApiKeyError': 'لم نتمكن من الاتصال بالنموذج. تأكد من إضافة مفتاح API الخاص بك بشكل صحيح أو التبديل لمزود مختلف.',
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
  keyError,
  keyCheckConnection,
  keyApiKeyError,
}

String translateKeyTr(TranslationKey key) {
  return key.name.tr;
}
