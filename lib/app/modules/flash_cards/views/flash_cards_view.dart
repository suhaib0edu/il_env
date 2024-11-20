import 'package:il_env/app/modules/flash_cards/controllers/flash_cards_controller.dart';
import 'package:il_env/index.dart';

class FlashCardsView extends GetView<FlashCardsController> {
  const FlashCardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Cards'),
      ),
      body: GetBuilder<FlashCardsController>(
        id: 'flashcards',
        builder: (controller) => controller.flashcards.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.flashcards.length,
                itemBuilder: (context, index) {
                  final cardData = controller.flashcards[index];
                  return Card(
                    color: AppColors.secondaryColor,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(cardData['question']),
                          onTap: () => controller.toggleAnswer(index),
                        ),
                        Visibility(
                          visible: controller.showAnswer,
                          child: ListTile(title: Text(cardData['answer'])),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
