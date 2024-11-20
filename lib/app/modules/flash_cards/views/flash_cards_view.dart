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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  InkWell(
                    radius: 20,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    onTap: () => controller.toggleAnswer(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: AppColors.secondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.flashcards[controller.currentIndex]
                                    ['question'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Visibility(
                                visible: controller.showAnswer,
                                child: SizedBox(
                                  height: 8,
                                ),
                              ),
                              Visibility(
                                visible: controller.showAnswer,
                                child: Text(
                                    controller
                                            .flashcards[controller.currentIndex]
                                        ['answer'],
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: controller.previousCard,
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: controller.nextCard,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
      ),
    );
  }
}
