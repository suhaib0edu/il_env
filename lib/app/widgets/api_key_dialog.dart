import 'package:il_env/index.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeyDialogWidget extends StatelessWidget {
  final controller = Get.put(ShowApiKeyDialogController());
  ApiKeyDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translateKeyTr(TranslationKey.keyCreateApiKey)),
      content: SizedBox(
        width: Get.width, // اجعل العرض يملأ الشاشة
        height: Get.height,
        child: GetBuilder<ShowApiKeyDialogController>(builder: (controller) {
          String apikeyLink = controller.selectedModel.value == ModelType.gemini
              ? 'https://aistudio.google.com/app/apikey'
              : 'https://platform.openai.com/api-keys';
          return Column(
            mainAxisSize: MainAxisSize.min, // استخدم min لحساب الارتفاع تلقائيا
            children: [
              // GetBuilder<SettingsController>(
              //   builder: (controller) => Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: ModelType.values
              //         .map((type) => _buildRadioOption(controller, type))
              //         .toList(),
              //   ),
              // ),
              CustomTextField(
                  labelText: 'API Key',
                  controller: controller.apiKeyController),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () => launchUrl(Uri.parse(apikeyLink)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new),
                    SizedBox(width: 4.0),
                    Text(translateKeyTr(TranslationKey.keyCreateApiKey)),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      actions: <Widget>[
        ElevatedButton.icon(
          label: Text(translateKeyTr(
            TranslationKey.keyUpdate,
          )),
          onPressed: controller.saveApiKey,
        ),
      ],
    );
  }
}

class ShowApiKeyDialogController extends GetxController {
  final apiKeyController = TextEditingController();
  final selectedModel = ModelType.gemini.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void saveApiKey() {
    storage.write(key: 'selectedModel', value: selectedModel.value.name);
    storage.write(key: selectedModel.value.name, value: apiKeyController.text);

    successSnackbar(TranslationKey.keySettingsSavedSuccessfully);
    Get.toNamed(Routes.HOME);
  }
}
