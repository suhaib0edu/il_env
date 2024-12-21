import 'package:il_env/app/widgets/api_key_dialog.dart';
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
            // _buildListTile(
            //   Icons.mail_outline,
            //   translateKeyTr(TranslationKey.keyInviteFriend),
            //   ()=> Get.toNamed(Routes.INVITATIONS),
            // ),
            _buildListTile(
              Icons.vpn_key_rounded,
              translateKeyTr(TranslationKey.keyCreateApiKey),
              () => _showApiKeyDialog(),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _showApiKeyDialog() {
    Get.dialog(ApiKeyDialogWidget());
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
