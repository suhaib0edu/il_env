import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/flash_cards_controller.dart';

class FlashCardsView extends GetView<FlashCardsController> {
  const FlashCardsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlashCardsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FlashCardsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
