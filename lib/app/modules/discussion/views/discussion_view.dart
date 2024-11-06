import 'package:il_env/app/widgets/custom_spinKit_wave_spinner.dart';
import 'package:il_env/index.dart';
import '../controllers/discussion_controller.dart';

class DiscussionView extends GetView<DiscussionController> {
  const DiscussionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DiscussionController>(
        id: 'discussionView',
        builder: (controller) {
          if (controller.isMakingRequest) {
            return const LoadingIndicator();
          } else if (controller.contentParts.isEmpty) {
            return const NoDataIndicator();
          } else {
            return DiscussionContent(controller: controller);
          }
        },
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(translateKeyTr(TranslationKey.keyContentPreparation)),
          ),
        ],
      ),
    );
  }
}

class NoDataIndicator extends StatelessWidget {
  const NoDataIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(translateKeyTr(TranslationKey.keyNoData)));
  }
}

class DiscussionContent extends StatelessWidget {
  final DiscussionController controller;

  const DiscussionContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              _buildContentTitle(),
              _buildContentDescription(),
              GetBuilder<DiscussionController>(
                id: 'deepExplanationControls',
                builder: (ctr) => _buildDeepExplanation(),
              ),
              GetBuilder<DiscussionController>(
                id: 'exploreQuestionsControls',
                builder: (ctr) => _buildExploreQuestions(),
              ),
              GetBuilder<DiscussionController>(
                id: 'directQuestionsControls',
                builder: (ctr) => _buildDirectQuestions(),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        GetBuilder<DiscussionController>(
          id: 'buildRequestIndicator',
          builder: (ctr) => _buildRequestIndicator(),
        ),
        SizedBox(height: 8),
        _buildActionButtons()
      ],
    );
  }

  Widget _buildContentTitle() {
    return Center(
      child: Text(
        controller.contentParts[controller.currentPart - 1]['t'],
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildContentDescription() {
    return CustomContainer(
      margin: const EdgeInsets.all(16),
      child: CustomMarkdown(
          data: controller.contentParts[controller.currentPart - 1]['c']),
    );
  }

  Widget _buildDeepExplanation() {
    if (!controller.deepExplanationMap.containsKey(controller.currentPart) ||
        controller.deepExplanationMap[controller.currentPart]!.isEmpty) {
      return const SizedBox();
    }

    return _buildContent(
      titleKey: TranslationKey.keyDeepExplanation,
      currentIndex: controller.currentDeepExplanation,
      dataList: controller.deepExplanationMap[controller.currentPart]!,
      onPrevious: () {
        if (controller.currentDeepExplanation > 0) {
          controller.currentDeepExplanation--;
          controller.update(['deepExplanationControls']);
        }
      },
      onNext: () {
        if (controller.currentDeepExplanation <
            controller.deepExplanationMap[controller.currentPart]!.length - 1) {
          controller.currentDeepExplanation++;
          controller.update(['deepExplanationControls']);
        }
      },
      showContent: controller.showdeepExplanation,
      toggleShowContent: () {
        controller.showdeepExplanation = !controller.showdeepExplanation;
        controller.update(['deepExplanationControls']);
      },
    );
  }

  Widget _buildExploreQuestions() {
    if (!controller.exploreQuestionsMap.containsKey(controller.currentPart) ||
        controller.exploreQuestionsMap[controller.currentPart]!.isEmpty) {
      return const SizedBox();
    }

    return _buildContent(
      titleKey: TranslationKey.keyExploreQuestions,
      currentIndex: controller.currentExploreQuestion,
      dataList: controller.exploreQuestionsMap[controller.currentPart]!,
      onPrevious: () {
        if (controller.currentExploreQuestion > 0) {
          controller.currentExploreQuestion--;
          controller.update(['exploreQuestionsControls']);
        }
      },
      onNext: () {
        if (controller.currentExploreQuestion <
            controller.exploreQuestionsMap[controller.currentPart]!.length -
                1) {
          controller.currentExploreQuestion++;
          controller.update(['exploreQuestionsControls']);
        }
      },
      showContent: controller.showExploreQuestions,
      toggleShowContent: () {
        controller.showExploreQuestions = !controller.showExploreQuestions;
        controller.update(['exploreQuestionsControls']);
      },
    );
  }

  Widget _buildDirectQuestions() {
    if (!controller.directQuestionMap.containsKey(controller.currentPart) ||
        controller.directQuestionMap[controller.currentPart]!.isEmpty) {
      return const SizedBox();
    }

    return _buildContent(
      titleKey: TranslationKey.keyDirectQuestion,
      currentIndex: controller.currentDirectQuestion,
      dataList: controller.directQuestionMap[controller.currentPart]!,
      onPrevious: () {
        if (controller.currentDirectQuestion > 0) {
          controller.currentDirectQuestion--;
          controller.update(['directQuestionsControls']);
        }
      },
      onNext: () {
        if (controller.currentDirectQuestion <
            controller.directQuestionMap[controller.currentPart]!.length - 1) {
          controller.currentDirectQuestion++;
          controller.update(['directQuestionsControls']);
        }
      },
      showContent: controller.showDirectQuestion,
      toggleShowContent: () {
        controller.showDirectQuestion = !controller.showDirectQuestion;
        controller.update(['directQuestionsControls']);
      },
    );
  }

  Widget _buildRequestIndicator() {
    return controller.isThinking
        ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomSpinKitWaveSpinner(
                  color: AppColors.primaryColor,
                  size: 35.0,
                ),
              ),
          ],
        )
        : const SizedBox();
  }

  Widget _buildNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextButton(
          textPadding: EdgeInsets.zero,
          onPressed: () => controller.previous(),
          fontSize: 19,
          text: '<',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '${controller.currentPart} / ${controller.contentParts.length}',
            style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
          ),
        ),
        CustomTextButton(
          textPadding: EdgeInsets.zero,
          onPressed: () => controller.next(),
          fontSize: 19,
          text: '>',
        ),
      ],
    );
  }

  Widget _buildContent({
    required TranslationKey titleKey,
    required int currentIndex,
    required List<dynamic> dataList,
    required void Function() onPrevious,
    required void Function() onNext,
    required bool showContent,
    required void Function() toggleShowContent,
  }) {
    // تحقق من صحة الفهرس
    if (dataList.isEmpty ||
        currentIndex < 0 ||
        currentIndex >= dataList.length) {
      return Container(); // أو يمكن عرض رسالة مناسبة
    }

    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          CustomContainer(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    translateKeyTr(titleKey),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.quaternaryColor,
                    ),
                  ),
                ),
                Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.quaternaryColor,
                  ),
                  onPressed: onPrevious,
                  child: const Text('<'),
                ),
                Text(
                  '${currentIndex + 1}/${dataList.length}',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.quaternaryColor,
                  ),
                  onPressed: onNext,
                  child: const Text('>'),
                ),
                SizedBox(width: 2),
                IconButton(
                  onPressed: toggleShowContent,
                  icon: Icon(
                    showContent
                        ? Icons.arrow_drop_down_rounded
                        : Icons.arrow_right_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: showContent,
            child: CustomMarkdown(data: dataList[currentIndex]),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextButton(
                  textPadding: EdgeInsets.zero,
                  text: translateKeyTr(TranslationKey.keyDeepExplanation),
                  onPressed: () => controller.deepExplanation(),
                ),
                const SizedBox(height: 10),
                CustomTextButton(
                  textPadding: EdgeInsets.zero,
                  text: translateKeyTr(TranslationKey.keyExploreQuestions),
                  onPressed: () => controller.exploreQuestions(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavigationRow(),
                const SizedBox(height: 10),
                CustomTextButton(
                  textPadding: EdgeInsets.zero,
                  text: translateKeyTr(TranslationKey.keyDirectQuestion),
                  onPressed: () {
                    if (!controller.isDialogOpen) {
                      controller.isDialogOpen = true;
                      Get.dialog(
                        Dialog(
                          backgroundColor: AppColors.secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 40,
                              horizontal: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                  controller:
                                      controller.directQuestionController,
                                  maxLength: 500,
                                  labelText: translateKeyTr(
                                      TranslationKey.keyDirectQuestion),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        controller.directQuestion(),
                                    icon: Icon(
                                      Icons.send,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
