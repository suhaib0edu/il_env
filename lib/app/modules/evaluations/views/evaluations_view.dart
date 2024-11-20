import 'package:il_env/index.dart';
import '../controllers/evaluations_controller.dart';

class EvaluationsView extends GetView<EvaluationsController> {
  const EvaluationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقييم'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CustomSpinKitWaveSpinner(color: Colors.blue));
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<EvaluationsController>(
                  id: 'overallEvaluation',
                  builder: (controller) => _buildSection(
                    'التقييم العام:',
                    controller.overallEvaluation.value,
                    controller.isVisibleOverallEvaluation.value,
                    () => controller.toggleVisibilityOverallEvaluation(),
                  ),
                ),
                GetBuilder<EvaluationsController>(
                  id: 'weaknesses',
                  builder: (controller) => _buildSection(
                    'نقاط الضعف:',
                    controller.weaknesses.value,
                    controller.isVisibleWeaknesses.value,
                    () => controller.toggleVisibilityWeaknesses(),
                  ),
                ),
                GetBuilder<EvaluationsController>(
                  id: 'advice',
                  builder: (controller) => _buildSection(
                    'النصائح:',
                    controller.advice.value,
                    controller.isVisibleAdvice.value,
                    () => controller.toggleVisibilityAdvice(),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildSection(
      String title, String data, bool isVisible, Function()? onPressed) {
    return CustomContainer(
      padding: EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            color: AppColors.primaryColor,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor),
                ),
                IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.secondaryColor,
                  ),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
          Visibility(
            visible: isVisible,
            child: CustomMarkdown(data: data),
          ),
        ],
      ),
    );
  }
}
