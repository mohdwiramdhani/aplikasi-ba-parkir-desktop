import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_all_mitra_controller.dart';

class AdminAllMitraView extends GetView<AdminAllMitraController> {
  const AdminAllMitraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Mitra Parkir'),
        centerTitle: true,
      ),
      body: GetBuilder<AdminAllMitraController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getAllMitra(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty || snapshot.data?.docs == null) {
                return const Center(
                  child: Text("Belum ada mitra parkir"),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data!.docs[index].data();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Get.toNamed(
                          Routes.adminDetailMitra,
                          arguments: data,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data['name'] ?? '-'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${data['address'] ?? '-'}",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
