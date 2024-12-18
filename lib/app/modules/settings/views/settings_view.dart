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
            _buildListTile(
              Icons.mail_outline,
              translateKeyTr(TranslationKey.keyInviteFriend),
              () {},
            ),
            _buildListTile(
              Icons.vpn_key_rounded,
              translateKeyTr(TranslationKey.keyCreateApiKey),
              () => _showApiKeyDialog(context),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(translateKeyTr(TranslationKey.keyCreateApiKey)),
        content: SizedBox(
           width: Get.width, // اجعل العرض يملأ الشاشة
           height: Get.height,
           child: GetBuilder<SettingsController>(
            builder: (controller) {
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
      ),
    );
  }


  // Widget _buildRadioOption(SettingsController controller, ModelType type) {
  //   return Row(
  //     children: [
  //       Text(type == ModelType.gemini ? 'Gemini' : 'GPT'),
  //       Radio<ModelType>(
  //         value: type,
  //         groupValue: controller.selectedModel.value,
  //         onChanged: controller.updateSelectedModel,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildListTile(leading, title, onTap) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        iconColor: AppColors.primaryColor,
        textColor: AppColors.primaryColor,
        leading: Icon(leading),
        title: Text(title),
        trailing: Icon(Icons.arrow_right_rounded),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}