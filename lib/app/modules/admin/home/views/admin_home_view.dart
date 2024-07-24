import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.adminAddMitra);
                },
                child: const Text("Tambah Mitra")),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.adminAllMitra);
                },
                child: const Text("Mitra Parkir")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> hasil = await controller.logout();
          if (hasil["error"] == false) {
            Get.offAllNamed(Routes.login);
          } else {
            Get.snackbar("error", hasil["message"]);
          }
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
