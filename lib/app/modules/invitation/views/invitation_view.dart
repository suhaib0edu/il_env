import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/invitation_controller.dart';

class InvitationView extends GetView<InvitationController> {
  const InvitationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvitationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InvitationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
