// import 'package:ba_parkir_desktop/app/modules/parking_add_slot/controllers/parking_add_slot_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/parking_slot_detail_controller.dart';

class ParkingSlotDetailView extends GetView<ParkingSlotDetailController> {
  ParkingSlotDetailView({super.key});
  final number = Get.arguments;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Slot Parkir'),
        centerTitle: true,
      ),
      body: const Text("data"),
    );
  }
}
