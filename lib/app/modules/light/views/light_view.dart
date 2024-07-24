import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/light_controller.dart';

class LightView extends GetView<LightController> {
  const LightView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LightView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LightView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
