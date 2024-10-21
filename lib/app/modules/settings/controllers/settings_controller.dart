import 'package:il_env/index.dart';

class SettingsController extends GetxController {
  final selectedModel = ModelType.gemini.obs;
  final apiKeyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final savedModel = await storage.read(key: 'selectedModel');
    if (savedModel != null) {
      selectedModel.value = ModelType.values.firstWhere(
        (model) => model.toString() == savedModel,
        orElse: () => selectedModel.value,
      );
    }
    await _updateApiKeyController();
  }

  Future<void> _updateApiKeyController() async {
    final apiKeyKey = selectedModel.value.name;
    final savedApiKey = await storage.read(key: apiKeyKey);
    if (savedApiKey != null) {
      apiKeyController.text = savedApiKey;
    }
  }

  void updateSelectedModel(ModelType? newModel) {
    if (newModel != null) {
      selectedModel.value = newModel;
      _updateApiKeyController();
    }
  }

  void saveSettings() {
    storage.write(key: 'selectedModel', value: selectedModel.value.toString());
    storage.write(key: selectedModel.value.name, value: apiKeyController.text);

    Get.snackbar(
      translateKeyTr(TranslationKey.keySuccess),
      translateKeyTr(TranslationKey.keySettingsSavedSuccessfully),
    );
    Get.toNamed(Routes.HOME);
  }
}

enum ModelType { gemini, gpt }