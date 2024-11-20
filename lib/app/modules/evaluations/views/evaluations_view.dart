import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/evaluations_controller.dart';
import 'package:il_env/app/widgets/custom_spinKit_wave_spinner.dart'; 

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
          return const Center(child: CustomSpinKitWaveSpinner(color: Colors.blue)); // Added color parameter
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'التقييم العام:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(controller.overallEvaluation.value),
                const SizedBox(height: 16.0),
                const Text(
                  'نقاط الضعف:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(controller.weaknesses.value),
                const SizedBox(height: 16.0),
                const Text(
                  'النصائح:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(controller.advice.value),
              ],
            ),
          );
        }
      }),
    );
  }
}
