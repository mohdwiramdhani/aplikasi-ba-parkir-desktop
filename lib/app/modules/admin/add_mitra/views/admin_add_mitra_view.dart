import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_add_mitra_controller.dart';

class AdminAddMitraView extends GetView<AdminAddMitraController> {
  const AdminAddMitraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mitra Parkir'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: "Nama Lokasi",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.addressC,
            decoration: const InputDecoration(
              labelText: "Alamat",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.phoneC,
            decoration: const InputDecoration(
              labelText: "Nomor Telepon",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () => controller.addMitra(), child: const Text("TAMBAH"))
        ],
      ),
    );
  }
}
