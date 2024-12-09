import 'package:url_launcher/url_launcher.dart';
import 'package:il_env/index.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateKeyTr(TranslationKey.keySettings)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<SettingsController>(
              builder: (controller) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ModelType.values
                    .map((type) => _buildRadioOption(controller, type))
                    .toList(),
              ),
            ),
            SizedBox(height: 16.0),
            CustomTextField(
                labelText: 'API Key', controller: controller.apiKeyController),
            GetBuilder<SettingsController>(
              builder: (controller) {
                String apikeyLink =
                    controller.selectedModel.value == ModelType.gemini
                        ? 'https://aistudio.google.com/app/apikey'
                        : 'https://platform.openai.com/api-keys';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => launchUrl(Uri.parse(apikeyLink)),
                      icon: Icon(Icons.open_in_new),
                      label: Text(translateKeyTr(TranslationKey.keyCreateApiKey)),
                    ),
                  ],
                );
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: CustomTextButton(
                    text: translateKeyTr(
                      TranslationKey.keyUpdateSettings,
                    ),
                    onPressed: controller.saveSettings),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(SettingsController controller, ModelType type) {
    return Row(
      children: [
        Text(type == ModelType.gemini ? 'Gemini' : 'GPT'),
        Radio<ModelType>(
          value: type,
          groupValue: controller.selectedModel.value,
          onChanged: controller.updateSelectedModel,
        ),
      ],
    );
  }
}
