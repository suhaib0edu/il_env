import 'package:il_env/index.dart';

import '../controllers/policies_and_terms_controller.dart';

class PoliciesAndTermsView extends GetView<PoliciesAndTermsController> {
  const PoliciesAndTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateKeyTr(TranslationKey.keyPoliciesAndTerms)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
              () => CustomMarkdown(data: controller.localizedContent.value)),
        ),
      ),
    );
  }
}
