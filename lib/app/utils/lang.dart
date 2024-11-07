import 'package:get/get.dart';

class TranslationsService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'keyHelpText': 'What will we learn today?',
          'keyQuestionHint': 'Do you have a question regarding this section?',
          'keyStudyLessons': 'Start Studying',
          'keyUpdateSettings': 'Update Settings',
          'keySettings': 'Settings',
          'keySuccess': 'Success',
          'keySettingsSavedSuccessfully': 'Settings saved successfully',
          'keyError': 'Error',
          'keyCheckConnection':
              'Please check your internet connection and try again.',
          'keyApiKeyError':
              'We could not connect to the model. Make sure to add your API key correctly or switch to a different provider.',
          'keyApiKeyInfo':
              'You can get your API key by visiting the following link: ',
          'keyLessonPrompt': 'Enter the lesson or article here',
          'keyMainGoals': 'Main Goals',
          'keyCoreConcepts': 'Core Concepts',
          'keyImportantPoints': 'Important Points',
          'keyContentPreparation': 'Content is being prepared',
          'keyNoData': 'No data available',
          'keyLessonBasicsTitle': 'Lesson Basics',
          'keyDeepExplanation': 'Deeper Explanation',
          'keyExploreQuestions': 'Exploratory Questions',
          'keyDirectQuestion': 'Direct Question',
          'keySuccessCopied': 'Copied to clipboard',
        },
        'ar_SA': {
          'keyHelpText': 'ماذا سنتعلم اليوم؟',
          'keyQuestionHint': 'هل لديك سؤال في هذه الجزئية؟',
          'keyStudyLessons': 'إبدأ المذاكرة',
          'keyUpdateSettings': 'تحديث الإعدادات',
          'keySettings': 'الإعدادات',
          'keySuccess': 'نجاح',
          'keySettingsSavedSuccessfully': 'تم حفظ الإعدادات بنجاح',
          'keyError': 'خطأ',
          'keyCheckConnection':
              'يرجى التحقق من الاتصال بالإنترنت والمحاولة مرة أخرى.',
          'keyApiKeyError':
              'لم نتمكن من الاتصال بالنموذج. تأكد من إضافة مفتاح API الخاص بك بشكل صحيح أو التبديل لمزود مختلف.',
          'keyApiKeyInfo':
              'يمكنك الحصول على مفتاح API الخاص بك من خلال زيارة الرابط التالي: ',
          'keyLessonPrompt': 'ضع الدرس أو المقالة هنا',
          'keyMainGoals': 'الأهداف الرئيسية',
          'keyCoreConcepts': 'المفاهيم الأساسية',
          'keyImportantPoints': 'النقاط المهمة',
          'keyContentPreparation': 'يتم تجهيز المحتوى',
          'keyNoData': 'لا يوجد بيانات',
          'keyLessonBasicsTitle': 'أساسيات الدرس',
          'keyDeepExplanation': 'شرح أعمق',
          'keyExploreQuestions': 'أسئلة استكشافية',
          'keyDirectQuestion': 'سؤال مباشر',
          'keySuccessCopied': 'تم النسخ إلى الحافظة',
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
  keyApiKeyInfo,
  keyLessonPrompt,
  keyMainGoals,
  keyCoreConcepts,
  keyImportantPoints,
  keyContentPreparation,
  keyNoData,
  keyLessonBasicsTitle,
  keyDeepExplanation,
  keyExploreQuestions,
  keyDirectQuestion,
  keySuccessCopied,
}

String translateKeyTr(TranslationKey key) {
  return key.name.tr;
}
