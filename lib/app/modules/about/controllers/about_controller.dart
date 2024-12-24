import 'package:il_env/index.dart';

class AboutController extends GetxController {
  final localizedContent = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateLocalizedContent();
  }

  void updateLocalizedContent() {
    if (Get.locale?.languageCode == 'en') {
      localizedContent.value = _englishContent;
    } else {
      localizedContent.value = _arabicContent;
    }
  }

  final String _arabicContent = '''
## معلومات وتواصل

**أهلاً بك في مجتمع بيئة التعليم الذكية!**

**من نحن؟**

بيئة التعليم الذكية هي منصة تعليمية مبتكرة تسعى إلى إحداث ثورة في طريقة تعلم الطلاب من خلال توفير أدوات متقدمة مدعومة بتقنيات الذكاء الاصطناعي. نهدف إلى تمكين الطلاب من مذاكرة دروسهم بفعالية أكبر، والحصول على إجابات دقيقة لأسئلتهم، وتقييم مستواهم بشكل مستمر لتحديد نقاط القوة والضعف لديهم. نسعى جاهدين لتوفير أفضل تجربة تعليمية ممكنة من خلال أدواتنا الذكية.

**انضم إلى مجتمعنا وابق على اطلاع دائم:**

ندعوك لتكون جزءًا من مجتمع بيئة التعليم الذكية النشط! تابع قناتنا الرسمية على يوتيوب لتكون أول من يعرف عن كل جديد يتعلق بالتطبيق والمحتوى التعليمي القيّم الذي نقدمه:

[قناة IL-ENV على يوتيوب](https://www.youtube.com/@IL-ENV)

ستجد هناك:

*   شروحات حصرية ومفصلة عن ميزات التطبيق وكيفية استخدامها بفعالية لتحقيق أقصى استفادة.
*   تحديثات مستمرة حول تطويرات التطبيق ومستقبله، وآخر المستجدات.

**تواصل مباشر وشارك أفكارك عبر تيليجرام:**

قناتنا على تيليجرام هي المكان الأمثل للتواصل المباشر مع فريق التطوير ومع مستخدمين آخرين مثلك. انضم الآن لطرح استفساراتك، ومشاركة أفكارك واقتراحاتك لتطوير التطبيق بشكل أفضل:

[قناة IL-ENV على تيليجرام](https://t.me/+YiOL78HkW003Y2Zk)

نؤمن بأن التفاعل المستمر هو مفتاح التطور والتحسين، ونرحب بجميع استفساراتكم وملاحظاتكم. فريقنا متواجد للإجابة على أسئلتكم وتقديم المساعدة اللازمة. نتطلع إلى مشاركتكم الفعالة ومساهمتكم في بناء بيئة تعليمية أفضل للجميع!
''';

  final String _englishContent = '''
## Information and Contact

**Welcome to the Smart Learning Environment Community!**

**Who We Are?**

Smart Learning Environment is an innovative educational platform seeking to revolutionize the way students learn by providing advanced tools powered by artificial intelligence technologies. We aim to empower students to study their lessons more effectively, get accurate answers to their questions, and continuously assess their level to identify their strengths and weaknesses. We strive to provide the best possible learning experience through our smart tools.

**Join Our Community and Stay Updated:**

We invite you to be part of the active Smart Learning Environment community! Follow our official YouTube channel to be the first to know about everything new related to the application and the valuable educational content we offer:

[IL-ENV YouTube Channel](https://www.youtube.com/@IL-ENV)

There you will find:

*   Exclusive and detailed explanations about the application's features and how to use them effectively to maximize benefits.
*   Continuous updates on application developments and its future, and the latest news.

**Connect Directly and Share Your Ideas via Telegram:**

Our Telegram channel is the ideal place to communicate directly with the development team and other users like you. Join now to ask your questions and share your ideas and suggestions for better application development:

[IL-ENV Telegram Channel](https://t.me/+YiOL78HkW003Y2Zk)

We believe that continuous interaction is the key to development and improvement, and we welcome all your inquiries and feedback. Our team is available to answer your questions and provide the necessary assistance. We look forward to your active participation and contribution to building a better learning environment for everyone!
''';
}
