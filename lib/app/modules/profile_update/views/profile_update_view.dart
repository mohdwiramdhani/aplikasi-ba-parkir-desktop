import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_update_controller.dart';

class ProfileUpdateView extends GetView<ProfileUpdateController> {
  const ProfileUpdateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileUpdateView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileUpdateView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
