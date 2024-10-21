import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/discussion_controller.dart';

class DiscussionView extends GetView<DiscussionController> {
  const DiscussionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DiscussionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DiscussionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
