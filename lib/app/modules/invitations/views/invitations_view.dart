import 'package:flutter/services.dart';
import 'package:il_env/index.dart';
import '../controllers/invitations_controller.dart';

class InvitationsView extends GetView<InvitationsController> {
  const InvitationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitations'.tr),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isDataLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInvitationMessage(),
                    const SizedBox(height: 20),
                    _buildInvitationCodeCard(),
                    const SizedBox(height: 20),
                    _buildInviterCodeField(),
                    const SizedBox(height: 20),
                    if (controller.unlimitedAccess.value)
                      _buildUnlimitedAccessMessage(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInvitationMessage() {
    return Text(
      controller.unlimitedAccess.value
          ? 'unlimited_access_invitation_message'.tr
          : 'limited_access_invitation_message'.tr,
      style: Get.textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInvitationCodeCard() {
    return Card(
      color: AppColors.secondaryColor,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('your_invitation_code'.tr, style: Get.textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.invitationCode.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: controller.invitationCode.value));
                    Get.snackbar(
                      'Copied'.tr,
                      'invitation_code_copied'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviterCodeField() {
    return Obx(() {
      if (controller.inviterCode.value.isNotEmpty) {
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('inviter_code'.tr, style: Get.textTheme.titleMedium),
                const SizedBox(height: 10),
                Text(
                  controller.inviterCode.value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      } else {
        return TextField(
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.addInviterCode(value);
            }
          },
          decoration: InputDecoration(
            labelText: 'enter_inviter_code'.tr,
            border: const OutlineInputBorder(),
          ),
        );
      }
    });
  }

  Widget _buildUnlimitedAccessMessage() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'unlimited_access_message'.tr,
        style: const TextStyle(color: Colors.green),
        textAlign: TextAlign.center,
      ),
    );
  }
}