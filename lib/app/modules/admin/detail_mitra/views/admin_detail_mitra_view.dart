import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_detail_mitra_controller.dart';

class AdminDetailMitraView extends GetView<AdminDetailMitraController> {
  final Map<String, dynamic> mitra = Get.arguments;

  AdminDetailMitraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mitra'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${mitra['name'] ?? "-"}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${mitra['address'] ?? "-"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Email: ${mitra['email'] ?? "-"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nomor Telepon: ${mitra['phone'] ?? "-"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tarif Parkir: ${mitra['price'] ?? "-"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
