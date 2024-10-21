import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/evaluations_controller.dart';

class EvaluationsView extends GetView<EvaluationsController> {
  const EvaluationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EvaluationsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EvaluationsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
