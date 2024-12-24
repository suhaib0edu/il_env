import 'package:il_env/index.dart';

class PoliciesAndTermsController extends GetxController {
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

## السياسات والشروط

---

**مقدمة:**

مرحباً بكم في بيئة التعليم الذكية. يرجى قراءة هذه السياسات والشروط وسياسة الخصوصية الخاصة بنا بعناية قبل استخدام موقعنا أو تطبيقاتنا أو خدماتنا (يُشار إليها مجتمعة بـ "الخدمات"). من خلال الوصول إلى خدماتنا أو استخدامها، فإنك توافق على الالتزام بهذه الشروط وسياسة الخصوصية. إذا كنت لا توافق على جميع هذه الشروط والسياسات، فيرجى عدم استخدام خدماتنا.

**سياسة الخصوصية:**

نحن نولي أهمية قصوى لخصوصية مستخدمينا. ونؤكد بشكل صريح أننا حاليًا **لا نقوم بجمع أي معلومات شخصية تعريفية عنك** عند استخدامك لخدماتنا.

*   **استخدام مفتاح API الخاص بـ Gemini:** تعتمد أدواتنا على نموذج Gemini، ولكي تتمكن من استخدام الأدوات، يلزمك إضافة مفتاح API الخاص بك. نود التأكيد على أن **مفتاح API هذا يتم تخزينه محليًا على جهازك فقط** (هاتفك أو جهاز الكمبيوتر الخاص بك)، و **لا يتم إرساله إلينا أو تخزينه على خوادمنا بأي شكل من الأشكال.**  أنت وحدك المسؤول عن إدارة مفتاح API الخاص بك.
*   **عدم جمع البيانات:** نكرر ونؤكد أننا **لا نقوم بجمع أو تخزين أي بيانات** تتعلق باستخدامك للأدوات أو البيانات التي تدخلها عند استخدامها.
*   **مسؤولية المستخدم:** أنت وحدك المسؤول عن الحفاظ على سرية مفتاح API الخاص بك وحمايته من الوصول غير المصرح به.
*   **مسؤولية استخدام Gemini API:**  باستخدامك لمفتاح Gemini API الخاص بك ضمن خدماتنا، فإنك توافق على الالتزام بشروط خدمة Gemini وسياساته.
*   **روابط الطرف الثالث:** قد تحتوي خدماتنا على روابط لمواقع أو خدمات طرف ثالث (مثل Google Cloud حيث يتم توفير Gemini). نحن لسنا مسؤولين عن ممارسات الخصوصية الخاصة بهذه الأطراف الثالثة وننصحك بمراجعة سياسات الخصوصية الخاصة بهم.

**شروط الاستخدام:**

*   **قبول الشروط:** باستخدام خدماتنا، فإنك تقر بأنك قرأت وفهمت وتوافق على الالتزام بهذه الشروط وسياسة الخصوصية.
*   **الأهلية:** أنت تقر بأن لديك الأهلية القانونية لإبرام هذه الشروط وأن استخدامك لخدماتنا لا ينتهك أي قوانين أو لوائح معمول بها.
*   **الاستخدام المسؤول:** أنت توافق على استخدام خدماتنا بطريقة مسؤولة وقانونية، وعدم استخدامها لأي أغراض غير قانونية أو ضارة أو مسيئة أو تنتهك حقوق الآخرين، بما في ذلك عدم استخدامها بشكل ينتهك شروط خدمة Gemini.
*   **مسؤولية مفتاح API:** أنت المسؤول الوحيد عن أي استخدام يتم لمفتاح API الخاص بك. نحن لسنا مسؤولين عن أي أضرار أو خسائر تنتج عن استخدام مفتاح API الخاص بك من قبل طرف آخر.
*   **حقوق الملكية الفكرية:** جميع حقوق الملكية الفكرية المتعلقة بالخدمات ومحتواها (باستثناء المحتوى الذي يتم إنشاؤه بواسطة المستخدمين باستخدام أدوات Gemini) مملوكة لنا أو لمرخصينا. لا يجوز لك نسخ أو تعديل أو توزيع أو استغلال أي جزء من خدماتنا دون الحصول على موافقة كتابية مسبقة منا. **ومع ذلك، فإنك تحتفظ بالحقوق في المحتوى الذي تقوم بإنشائه باستخدام أدوات Gemini من خلال مفتاح API الخاص بك.**
*   **إخلاء المسؤولية عن الضمانات:** يتم توفير خدماتنا "كما هي" و "حسب توفرها" دون أي ضمانات من أي نوع، صريحة أو ضمنية، بما في ذلك على سبيل المثال لا الحصر، ضمانات القابلية للتسويق أو الملاءمة لغرض معين أو عدم الانتهاك. نحن لا نضمن أن خدماتنا ستكون خالية من الأخطاء أو الانقطاع أو أنها ستلبي جميع متطلباتك.
*   **تحديد المسؤولية:** إلى أقصى حد يسمح به القانون المعمول به، لن نكون مسؤولين عن أي أضرار مباشرة أو غير مباشرة أو عرضية أو تبعية أو خاصة أو تأديبية تنشأ عن أو فيما يتعلق باستخدامك أو عدم قدرتك على استخدام خدماتنا، حتى لو تم إخطارنا باحتمالية وقوع مثل هذه الأضرار.
*   **تعديل الشروط:** نحتفظ بالحق في تعديل هذه الشروط في أي وقت دون إشعار مسبق. يعتبر استمرارك في استخدام خدماتنا بعد نشر أي تعديلات بمثابة موافقة منك على الشروط المعدلة. ننصحك بمراجعة هذه الصفحة بشكل دوري للاطلاع على أي تغييرات.
*   **القانون الحاكم:** تخضع هذه الشروط وتفسر وفقًا لقوانين ولاية كاليفورنيا، الولايات المتحدة الأمريكية، بغض النظر عن تعارضها مع مبادئ القوانين.

**الأمان :**

أنت مسؤول عن الحفاظ على أمان جهازك وحماية مفتاح API الخاص بك من الوصول غير المصرح به. ننصحك باتباع ممارسات الأمان الجيدة، مثل عدم مشاركة مفتاح API الخاص بك مع الآخرين وتحديث برامج جهازك بانتظام.

**الاتصال بنا:** إذا كان لديك أي أسئلة أو استفسارات حول هذه الشروط أو خدماتنا، فيرجى التواصل معنا عبر البريد الإلكتروني التالي: suhab.edu@gmail.com.

شكرًا لاستخدامكم بيئة التعليم الذكية!

''';

  final String _englishContent = '''

## Policies and Terms

---

**Introduction:**

Welcome to Smart Learning Environment. Please read these Policies and Terms and our Privacy Policy carefully before using our website, applications, or services (collectively, the "Services"). By accessing or using our Services, you agree to be bound by these Terms and our Privacy Policy. If you do not agree to all of these Terms and Policies, please do not use our Services.

**Privacy Policy:**

We take the privacy of our users extremely seriously. We explicitly state that we currently **do not collect any personally identifiable information about you** when you use our Services.

*   **Use of Gemini API Key:** Our tools rely on the Gemini model. To use these tools, you need to add your own Gemini API key. We want to emphasize that **this API key is stored locally on your device only** (your phone or computer), and **is not transmitted to us or stored on our servers in any way.** You are solely responsible for managing your API key.
*   **No Data Collection:** We reiterate and confirm that we **do not collect or store any data** related to your use of the tools or the data you enter when using them.
*   **User Responsibility:** You are solely responsible for maintaining the confidentiality of your API key and protecting it from unauthorized access.
*   **Responsibility for using Gemini API:** By using your own Gemini API key within our Services, you agree to comply with the Gemini Terms of Service and policies.
*   **Third-Party Links:** Our Services may contain links to third-party websites or services (such as Google Cloud where Gemini is provided). We are not responsible for the privacy practices of these third parties and encourage you to review their privacy policies.

**Terms of Use:**

*   **Acceptance of Terms:** By using our Services, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy.
*   **Eligibility:** You represent that you have the legal capacity to enter into these Terms and that your use of our Services does not violate any applicable laws or regulations.
*   **Responsible Use:** You agree to use our Services responsibly and legally, and not to use them for any illegal, harmful, abusive, or infringing purposes, including not using them in a way that violates the Gemini Terms of Service.
*   **API Key Responsibility:** You are solely responsible for any use of your API key. We are not responsible for any damages or losses resulting from the use of your API key by another party.
*   **Intellectual Property Rights:** All intellectual property rights relating to the Services and their content (excluding content generated by users using Gemini tools) are owned by us or our licensors. You may not copy, modify, distribute, or exploit any part of our Services without our prior written consent. **However, you retain the rights to the content you generate using the Gemini tools through your own API key.**
*   **Disclaimer of Warranties:** Our Services are provided "as is" and "as available" without any warranties of any kind, express or implied, including, but not limited to, warranties of merchantability, fitness for a particular purpose, or non-infringement. We do not warrant that our Services will be error-free, uninterrupted, or that they will meet all of your requirements.
*   **Limitation of Liability:** To the maximum extent permitted by applicable law, we shall not be liable for any direct, indirect, incidental, consequential, special, or exemplary damages arising out of or in connection with your use or inability to use our Services, even if we have been advised of the possibility of such damages.
*   **Modification of Terms:** We reserve the right to modify these Terms at any time without prior notice. Your continued use of our Services after the posting of any modifications constitutes your acceptance of the amended Terms. We encourage you to review this page periodically for any changes.
*   **Governing Law:** These Terms shall be governed by and construed in accordance with the laws of the State of California, United States of America, without regard to its conflict of law principles.

**Security (Optional but Recommended):**

You are responsible for maintaining the security of your device and protecting your API key from unauthorized access. We recommend following good security practices, such as not sharing your API key with others and regularly updating your device's software.

**Contact Us:** If you have any questions or concerns about these Terms or our Services, please contact us at: suhab.edu@gmail.com.

Thank you for using Smart Learning Environment!

''';
}
