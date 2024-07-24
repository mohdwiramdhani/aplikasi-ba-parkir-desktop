import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/parking_price_controller.dart';

class ParkingPriceView extends GetView<ParkingPriceController> {
  ParkingPriceView({super.key});
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    // controller.priceCarC.value = user['priceCar'];
    // controller.priceC.value = user['parking'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('TARIF PARKIR'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Obx(() => Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Tarif Mobil"),
                      subtitle: Text(
                        'Rp ${NumberFormat.decimalPattern('id_ID').format(controller.priceC.value)}',
                      ),
                    ),
                    Slider(
                      value: controller.priceC.toDouble(),
                      onChanged: (value) {
                        controller.priceC.value = value.toInt();
                      },
                      min: 500,
                      max: 50000,
                      divisions: 495,
                      label: controller.priceC.toString(),
                    ),
                  ],
                ),
              )),
          // const SizedBox(height: 30), // Spasi antara card
          // Obx(() => Card(
          //       child: Column(
          //         children: [
          //           ListTile(
          //             title: const Text("Tarif Motor / Jam"),
          //             subtitle: Text(
          //               'Rp ${NumberFormat.decimalPattern('id_ID').format(controller.priceC.value)}',
          //             ),
          //           ),
          //           Slider(
          //             value: controller.priceC.toDouble(),
          //             onChanged: (value) {
          //               controller.priceC.value = value.toInt();
          //             },
          //             min: 500,
          //             max: 50000,
          //             divisions: 495,
          //             label: controller.priceC.toString(),
          //           ),
          //         ],
          //       ),
          //     )),

          const SizedBox(
            height: 30,
          ),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.updateProfile(user["uid"]);
                  }
                },
                child:
                    Text(controller.isLoading.isFalse ? "SIMPAN" : "LOADING"),
              )),
        ],
      ),
    );
  }
}
