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
      savedModel == ModelType.gemini.name
          ? selectedModel.value = ModelType.gemini
          : selectedModel.value = ModelType.gpt;
    }
    await _updateApiKeyController();
  }

  Future<void> _updateApiKeyController() async {
    apiKeyController.clear();
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
    update();
  }

  void saveApiKey() {
    storage.write(key: 'selectedModel', value: selectedModel.value.name);
    storage.write(key: selectedModel.value.name, value: apiKeyController.text);

    successSnackbar(TranslationKey.keySettingsSavedSuccessfully);
    Get.toNamed(Routes.HOME);
  }
  
}
